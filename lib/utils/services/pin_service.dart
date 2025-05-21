// lib/utils/services/pin_service.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../routes/app_routes.dart';
import '../constants/app_constants.dart';

/// Service to handle PIN authentication and security
class PinService extends GetxService with WidgetsBindingObserver {
  static PinService get to => Get.find();

  // Regular storage for flag indicating PIN is set
  final _storage = GetStorage();

  // Secure storage for PIN hash
  final _secureStorage = const FlutterSecureStorage();

  // Observable authentication state
  final isAuthenticated = false.obs;

  // Session timeout settings
  DateTime? _lastActivityTime;
  Timer? _inactivityTimer;

  /// Initialize service
  Future<PinService> init() async {
    isAuthenticated.value = false;
    _setupInactivityMonitor();
    return this;
  }

  /// Set up monitoring for app inactivity
  void _setupInactivityMonitor() {
    // Register with WidgetsBinding to receive lifecycle events
    WidgetsBinding.instance.addObserver(this);

    // Start inactivity timer
    _startInactivityTimer();

    // Set initial activity time
    _updateLastActivityTime();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came to foreground
      _updateLastActivityTime();
      _checkInactivityTimeout();
    } else if (state == AppLifecycleState.paused) {
      // Store the timestamp when app goes to background
      final pauseTime = DateTime.now();
      _storage.write(StorageKeys.appPausedAt, pauseTime.millisecondsSinceEpoch);
    }
  }

  /// Start timer to periodically check for inactivity
  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer.periodic(
        Duration(minutes: 1),
            (_) => _checkInactivityTimeout()
    );
  }

  /// Update the last activity timestamp
  void _updateLastActivityTime() {
    _lastActivityTime = DateTime.now();

    // Check if app was paused and for how long
    final pausedAt = _storage.read<int>(StorageKeys.appPausedAt);
    if (pausedAt != null) {
      final pausedDuration = DateTime.now().millisecondsSinceEpoch - pausedAt;
      final pausedMinutes = pausedDuration ~/ (1000 * 60);

      // If app was paused longer than timeout, lock it
      if (pausedMinutes >= TimeoutConstants.sessionTimeoutMinutes && isAuthenticated.value) {
        lockApp();
      }

      // Clear the pause timestamp
      _storage.remove(StorageKeys.appPausedAt);
    }
  }

  /// Check if the app should lock due to inactivity
  void _checkInactivityTimeout() {
    if (!isAuthenticated.value || _lastActivityTime == null) return;

    final now = DateTime.now();
    final difference = now.difference(_lastActivityTime!).inMinutes;

    if (difference >= TimeoutConstants.sessionTimeoutMinutes) {
      lockApp();
    }
  }

  /// Clean up resources when the service is closed
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.onClose();
  }

  /// Record user activity to prevent timeout
  /// Call this method from user interaction points in your app
  void recordActivity() {
    _updateLastActivityTime();
  }

  /// Check if PIN protection is enabled
  bool isPinEnabled() {
    return _storage.read(StorageKeys.pinProtected) == true;
  }

  /// Save a new PIN
  Future<void> savePin(String pin) async {
    // Generate secure hash from PIN
    final pinHash = _hashPin(pin);

    // Store hash in secure storage
    await _secureStorage.write(key: StorageKeys.pinHash, value: pinHash);

    // Set flag in regular storage
    await _storage.write(StorageKeys.pinProtected, true);

    // Auto-authenticate when setting a new PIN
    isAuthenticated.value = true;
    _updateLastActivityTime();
  }

  /// Create a secure hash of the PIN
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify the provided PIN against the stored PIN
  Future<bool> verifyPin(String pin) async {
    final storedPinHash = await _secureStorage.read(key: StorageKeys.pinHash);

    if (storedPinHash == null) return false;

    // Hash the input PIN and compare with stored hash
    final inputPinHash = _hashPin(pin);

    if (inputPinHash == storedPinHash) {
      isAuthenticated.value = true;
      _updateLastActivityTime();
      return true;
    }

    return false;
  }

  /// Remove the PIN protection
  Future<void> removePin() async {
    await _secureStorage.delete(key: StorageKeys.pinHash);
    await _storage.remove(StorageKeys.pinProtected);
    isAuthenticated.value = true;
  }

  /// Lock the application and redirect to PIN screen
  void lockApp() {
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.pinCode);
  }

  /// Authenticate the app without PIN
  void authenticateWithoutPin() {
    isAuthenticated.value = true;
    _updateLastActivityTime();
  }

  /// Change existing PIN
  Future<bool> changePin(String currentPin, String newPin) async {
    // Verify current PIN first
    final isCurrentPinValid = await verifyPin(currentPin);

    if (!isCurrentPinValid) return false;

    // Save new PIN
    await savePin(newPin);
    return true;
  }
}