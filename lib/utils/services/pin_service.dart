// lib/utils/services/enhanced_pin_service.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:async';

import '../../routes/app_routes.dart';
import '../constants/app_constants.dart';
import '../helpers/logger.dart';

class EnhancedPinService extends GetxService with WidgetsBindingObserver {
  static EnhancedPinService get to => Get.find();

  final _storage = GetStorage();
  final _secureStorage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();

  // Authentication state
  final isAuthenticated = false.obs;
  final biometricsEnabled = false.obs;
  final biometricsAvailable = false.obs;
  final failedAttempts = 0.obs;

  // Security settings
  final maxFailedAttempts = 5;
  final lockoutDurationMinutes = 15;

  // Session management
  DateTime? _lastActivityTime;
  Timer? _inactivityTimer;
  Timer? _lockoutTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  // Add the missing init method for compatibility
  Future<EnhancedPinService> init() async {
    await _initializeService();
    return this;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    _lockoutTimer?.cancel();
    super.onClose();
  }

  Future<void> _initializeService() async {
    await _checkBiometricsAvailability();
    await _loadSettings();
    _startInactivityMonitoring();
  }

  Future<void> _checkBiometricsAvailability() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      biometricsAvailable.value = isAvailable && isDeviceSupported;

      if (biometricsAvailable.value) {
        final availableBiometrics = await _localAuth.getAvailableBiometrics();
        Logger.log('Available biometrics: $availableBiometrics');
      }
    } catch (e) {
      Logger.error('Error checking biometrics: $e');
      biometricsAvailable.value = false;
    }
  }

  Future<void> _loadSettings() async {
    biometricsEnabled.value = _storage.read(StorageKeys.biometricsEnabled) ?? false;
    failedAttempts.value = _storage.read('failed_pin_attempts') ?? 0;

    // Check if device is currently locked out
    final lockoutUntil = _storage.read('lockout_until');
    if (lockoutUntil != null) {
      final lockoutTime = DateTime.fromMillisecondsSinceEpoch(lockoutUntil);
      if (DateTime.now().isBefore(lockoutTime)) {
        _startLockoutTimer(lockoutTime.difference(DateTime.now()));
      } else {
        await _clearLockout();
      }
    }
  }

  // PIN Management
  bool isPinEnabled() {
    return _storage.read(StorageKeys.pinProtected) == true;
  }

  Future<void> savePin(String pin) async {
    try {
      final hashedPin = _hashPin(pin);
      await _secureStorage.write(key: StorageKeys.pinHash, value: hashedPin);
      await _storage.write(StorageKeys.pinProtected, true);

      // Reset failed attempts
      failedAttempts.value = 0;
      await _storage.write('failed_pin_attempts', 0);

      isAuthenticated.value = true;
      recordActivity();

      Logger.success('PIN saved successfully');
    } catch (e) {
      Logger.error('Error saving PIN: $e');
      rethrow;
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      // Check if device is locked out
      if (isLockedOut()) {
        throw Exception('Device is locked. Please wait before trying again.');
      }

      final storedHash = await _secureStorage.read(key: StorageKeys.pinHash);
      if (storedHash == null) return false;

      final inputHash = _hashPin(pin);

      if (inputHash == storedHash) {
        // Successful authentication
        isAuthenticated.value = true;
        await _clearFailedAttempts();
        recordActivity();

        // Haptic feedback
        HapticFeedback.lightImpact();

        return true;
      } else {
        // Failed authentication
        await _recordFailedAttempt();

        // Haptic feedback
        HapticFeedback.heavyImpact();

        return false;
      }
    } catch (e) {
      Logger.error('Error verifying PIN: $e');
      return false;
    }
  }

  Future<void> removePin() async {
    try {
      await _secureStorage.delete(key: StorageKeys.pinHash);
      await _storage.remove(StorageKeys.pinProtected);
      await _clearFailedAttempts();
      isAuthenticated.value = true;

      Logger.success('PIN removed successfully');
    } catch (e) {
      Logger.error('Error removing PIN: $e');
      rethrow;
    }
  }

  // Biometric Authentication
  Future<bool> enableBiometrics() async {
    if (!biometricsAvailable.value) return false;

    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Enable biometric authentication for app security',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        biometricsEnabled.value = true;
        await _storage.write(StorageKeys.biometricsEnabled, true);
        Logger.success('Biometrics enabled');
        return true;
      }

      return false;
    } catch (e) {
      Logger.error('Error enabling biometrics: $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    if (!biometricsEnabled.value || !biometricsAvailable.value) return false;

    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        this.isAuthenticated.value = true;
        await _clearFailedAttempts();
        recordActivity();

        HapticFeedback.mediumImpact();
        return true;
      }

      return false;
    } catch (e) {
      Logger.error('Biometric authentication error: $e');
      return false;
    }
  }

  Future<void> disableBiometrics() async {
    biometricsEnabled.value = false;
    await _storage.write(StorageKeys.biometricsEnabled, false);
    Logger.log('Biometrics disabled');
  }

  // Security & Session Management
  void recordActivity() {
    _lastActivityTime = DateTime.now();
  }

  void lockApp() {
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.pinCode);
  }

  bool isLockedOut() {
    return failedAttempts.value >= maxFailedAttempts;
  }

  String getLockoutMessage() {
    if (!isLockedOut()) return '';

    final lockoutUntil = _storage.read('lockout_until');
    if (lockoutUntil != null) {
      final lockoutTime = DateTime.fromMillisecondsSinceEpoch(lockoutUntil);
      final remaining = lockoutTime.difference(DateTime.now());

      if (remaining.isNegative) {
        _clearLockout();
        return '';
      }

      final minutes = remaining.inMinutes;
      final seconds = remaining.inSeconds % 60;
      return 'Device locked. Try again in ${minutes}m ${seconds}s';
    }

    return 'Device locked due to too many failed attempts';
  }

  Future<void> _recordFailedAttempt() async {
    failedAttempts.value++;
    await _storage.write('failed_pin_attempts', failedAttempts.value);

    if (failedAttempts.value >= maxFailedAttempts) {
      await _lockDevice();
    }

    Logger.warning('Failed PIN attempt: ${failedAttempts.value}/$maxFailedAttempts');
  }

  Future<void> _lockDevice() async {
    final lockoutUntil = DateTime.now().add(Duration(minutes: lockoutDurationMinutes));
    await _storage.write('lockout_until', lockoutUntil.millisecondsSinceEpoch);

    _startLockoutTimer(Duration(minutes: lockoutDurationMinutes));

    Logger.warning('Device locked for $lockoutDurationMinutes minutes');

    Get.snackbar(
      'Security Alert',
      'Device locked due to multiple failed attempts',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  void _startLockoutTimer(Duration duration) {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer(duration, () async {
      await _clearLockout();
    });
  }

  Future<void> _clearLockout() async {
    await _storage.remove('lockout_until');
    _lockoutTimer?.cancel();
  }

  Future<void> _clearFailedAttempts() async {
    failedAttempts.value = 0;
    await _storage.write('failed_pin_attempts', 0);
    await _clearLockout();
  }

  void _startInactivityMonitoring() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer.periodic(
      const Duration(minutes: 1),
          (_) => _checkInactivity(),
    );
  }

  void _checkInactivity() {
    if (!isAuthenticated.value || _lastActivityTime == null) return;

    final now = DateTime.now();
    final inactiveDuration = now.difference(_lastActivityTime!);

    if (inactiveDuration.inMinutes >= TimeoutConstants.sessionTimeoutMinutes) {
      Logger.log('Session timeout - locking app');
      lockApp();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        recordActivity();
        _checkInactivity();
        break;
      case AppLifecycleState.paused:
        final pauseTime = DateTime.now();
        _storage.write(StorageKeys.appPausedAt, pauseTime.millisecondsSinceEpoch);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  // Utility methods
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin + 'expense_tracker_salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> changePin(String currentPin, String newPin) async {
    try {
      final isCurrentValid = await verifyPin(currentPin);
      if (!isCurrentValid) return false;

      await savePin(newPin);
      return true;
    } catch (e) {
      Logger.error('Error changing PIN: $e');
      return false;
    }
  }

  // Quick authentication for returning users
  Future<bool> quickAuthenticate() async {
    if (biometricsEnabled.value && biometricsAvailable.value) {
      return await authenticateWithBiometrics();
    }
    return false;
  }

  // Security information for UI
  Map<String, dynamic> getSecurityInfo() {
    return {
      'isPinEnabled': isPinEnabled(),
      'biometricsAvailable': biometricsAvailable.value,
      'biometricsEnabled': biometricsEnabled.value,
      'failedAttempts': failedAttempts.value,
      'maxAttempts': maxFailedAttempts,
      'isLockedOut': isLockedOut(),
      'lockoutMessage': getLockoutMessage(),
    };
  }
}