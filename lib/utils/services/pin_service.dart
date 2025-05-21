import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';

class PinService extends GetxService {
  static PinService get to => Get.find();

  final _storage = GetStorage();
  final _pinKey = 'app_pin_code';

  final isAuthenticated = false.obs;

  /// Called immediately after the service is registered.
  Future<PinService> init() async {
    // Initialize authentication state
    isAuthenticated.value = false;
    return this;
  }

  /// Check if PIN protection is enabled
  bool isPinEnabled() {
    return _storage.read(_pinKey) != null;
  }

  /// Save a new PIN
  Future<void> savePin(String pin) async {
    await _storage.write(_pinKey, pin);
  }

  /// Verify the provided PIN against the stored PIN
  bool verifyPin(String pin) {
    final storedPin = _storage.read<String>(_pinKey);

    if (storedPin == pin) {
      isAuthenticated.value = true;
      return true;
    }

    return false;
  }

  /// Remove the PIN protection
  Future<void> removePin() async {
    await _storage.remove(_pinKey);
    isAuthenticated.value = false;
  }

  /// Lock the application and redirect to PIN screen
  void lockApp() {
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.pinCode);
  }

  /// Authenticate the app without PIN
  void authenticateWithoutPin() {
    isAuthenticated.value = true;
  }
}