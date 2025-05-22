// lib/features/screens/pin_code/_controller.dart
part of 'imports.dart';

class PinCodeController extends GetxController {
  // Constants
  static const int pinLength = 4;
  static const String _pinStorageKey = 'app_pin_code';

  // Reactive variables
  final pin = RxString('');
  final isPinSet = RxBool(false);
  final isConfirming = RxBool(false);
  final temporaryPin = RxString('');
  final errorMessage = RxString('');
  final isAuthenticated = RxBool(false);

  // Define vibration feedback if you want to use it
  final bool useHapticFeedback = true;

  @override
  void onInit() {
    super.onInit();
    _checkExistingPin();
  }

  // Check if PIN is already set
  Future<void> _checkExistingPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPin = prefs.getString(_pinStorageKey);
      isPinSet.value = savedPin != null && savedPin.isNotEmpty;
    } catch (e) {
      Logger.error('Error checking existing PIN: $e');
      isPinSet.value = false;
    }
  }

  // Add digit to PIN
  void addDigit(String digit) {
    if (pin.value.length < pinLength) {
      pin.value = pin.value + digit;

      // Provide haptic feedback if enabled
      if (useHapticFeedback) {
        HapticFeedback.lightImpact();
      }

      // If pin length reached, process it
      if (pin.value.length == pinLength) {
        _processPin();
      }
    }
  }

  // Remove last digit from PIN
  void removeLastDigit() {
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);

      // Provide haptic feedback if enabled
      if (useHapticFeedback) {
        HapticFeedback.lightImpact();
      }

      // Clear error message when user starts correcting
      if (errorMessage.value.isNotEmpty) {
        errorMessage.value = '';
      }
    }
  }

  // Process entered PIN
  void _processPin() {
    if (isPinSet.value) {
      // Authentication mode
      _verifyPin();
    } else {
      // PIN setup mode
      if (isConfirming.value) {
        _confirmPin();
      } else {
        // First-time PIN entry
        temporaryPin.value = pin.value;
        isConfirming.value = true;
        errorMessage.value = '';
        pin.value = '';
      }
    }
  }

  // Verify PIN during authentication
  Future<void> _verifyPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPin = prefs.getString(_pinStorageKey) ?? '';

      if (pin.value == savedPin) {
        // PIN correct, proceed to app
        isAuthenticated.value = true;
        errorMessage.value = '';

        // Provide success haptic feedback
        if (useHapticFeedback) {
          HapticFeedback.mediumImpact();
        }

        // Navigate to home or previous page
        Get.offAllNamed(AppRoutes.home);
      } else {
        // PIN incorrect
        errorMessage.value = 'Incorrect PIN. Please try again.';
        pin.value = '';

        // Provide error haptic feedback
        if (useHapticFeedback) {
          HapticFeedback.heavyImpact();
        }
      }
    } catch (e) {
      Logger.error('Error verifying PIN: $e');
      errorMessage.value = 'An error occurred. Please try again.';
      pin.value = '';
    }
  }

  // Confirm PIN during setup
  Future<void> _confirmPin() async {
    try {
      if (pin.value == temporaryPin.value) {
        // PINs match, save to storage
        await _savePin();
        isPinSet.value = true;
        isAuthenticated.value = true;

        // Provide success haptic feedback
        if (useHapticFeedback) {
          HapticFeedback.mediumImpact();
        }

        // Navigate to home page
        Get.offAllNamed(AppRoutes.home);
      } else {
        // PINs don't match
        errorMessage.value = 'PINs do not match. Please try again.';
        pin.value = '';
        temporaryPin.value = '';
        isConfirming.value = false;

        // Provide error haptic feedback
        if (useHapticFeedback) {
          HapticFeedback.heavyImpact();
        }
      }
    } catch (e) {
      Logger.error('Error confirming PIN: $e');
      errorMessage.value = 'An error occurred. Please try again.';
      pin.value = '';
      isConfirming.value = false;
    }
  }

  // Save PIN to storage
  Future<void> _savePin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pinStorageKey, pin.value);
    } catch (e) {
      Logger.error('Error saving PIN: $e');
      throw Exception('Failed to save PIN');
    }
  }

  // Reset PIN setup process
  void resetPinSetup() {
    pin.value = '';
    temporaryPin.value = '';
    isConfirming.value = false;
    errorMessage.value = '';
  }

  // Change existing PIN
  Future<void> changePin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pinStorageKey);

      isPinSet.value = false;
      resetPinSetup();
    } catch (e) {
      Logger.error('Error changing PIN: $e');
      errorMessage.value = 'Failed to reset PIN. Please try again.';
    }
  }
}