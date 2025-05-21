part of 'imports.dart';

class PinCodeController extends GetxController {
  // Reactive variables
  final pinLength = 4;
  final pin = RxString('');
  final isPinSet = RxBool(false);
  final isConfirming = RxBool(false);
  final temporaryPin = RxString('');
  final errorMessage = RxString('');
  final isAuthenticated = RxBool(false);

  // Storage key
  final String _pinStorageKey = 'app_pin_code';

  @override
  void onInit() {
    super.onInit();
    _checkExistingPin();
  }

  // Check if PIN is already set
  Future<void> _checkExistingPin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(_pinStorageKey);
    isPinSet.value = savedPin != null && savedPin.isNotEmpty;
  }

  // Add digit to PIN
  void addDigit(String digit) {
    if (pin.value.length < pinLength) {
      pin.value = pin.value + digit;

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
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(_pinStorageKey) ?? '';

    if (pin.value == savedPin) {
      // PIN correct, proceed to app
      isAuthenticated.value = true;
      errorMessage.value = '';

      // Navigate to home or previous page
      Get.offAllNamed(AppRoutes.home);
    } else {
      // PIN incorrect
      errorMessage.value = 'Incorrect PIN. Please try again.';
      pin.value = '';
    }
  }

  // Confirm PIN during setup
  Future<void> _confirmPin() async {
    if (pin.value == temporaryPin.value) {
      // PINs match, save to storage
      await _savePin();
      isPinSet.value = true;
      isAuthenticated.value = true;

      // Navigate to home page
      Get.offAllNamed(AppRoutes.home);
    } else {
      // PINs don't match
      errorMessage.value = 'PINs do not match. Please try again.';
      pin.value = '';
      temporaryPin.value = '';
      isConfirming.value = false;
    }
  }

  // Save PIN to storage
  Future<void> _savePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinStorageKey, pin.value);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinStorageKey);

    isPinSet.value = false;
    resetPinSetup();
  }
}