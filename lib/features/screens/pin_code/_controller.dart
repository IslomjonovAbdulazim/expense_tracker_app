part of 'imports.dart';

class PinCodeController extends GetxController {
  static const PIN_LENGTH = 4;
  static const _PIN_STORAGE_KEY = 'app_pin_code';

  // Reactive state
  final RxString pin = ''.obs;
  final RxBool isPinSet = false.obs;
  final RxBool isConfirming = false.obs;
  final RxString temporaryPin = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkExistingPin();

    // Listen for completed pin entry
    ever(pin, (value) {
      if (value.length == PIN_LENGTH) {
        _processPin();
      }
    });
  }

  Future<void> _checkExistingPin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(_PIN_STORAGE_KEY);
    isPinSet.value = savedPin != null && savedPin.isNotEmpty;
  }

  void addDigit(String digit) {
    if (pin.value.length < PIN_LENGTH) {
      pin.value += digit;
    }
  }

  void removeLastDigit() {
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  void _processPin() {
    if (isPinSet.value) {
      _verifyPin();
    } else if (isConfirming.value) {
      _confirmPin();
    } else {
      _prepareForConfirmation();
    }
  }

  void _prepareForConfirmation() {
    temporaryPin.value = pin.value;
    isConfirming.value = true;
    errorMessage.value = '';
    pin.value = '';
  }

  Future<void> _verifyPin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(_PIN_STORAGE_KEY) ?? '';

    if (pin.value == savedPin) {
      isAuthenticated.value = true;
      errorMessage.value = '';
      Get.offAllNamed(AppRoutes.home);
    } else {
      errorMessage.value = 'Incorrect PIN. Please try again.';
      pin.value = '';
    }
  }

  Future<void> _confirmPin() async {
    if (pin.value == temporaryPin.value) {
      await _savePin();
      isPinSet.value = true;
      isAuthenticated.value = true;
      Get.offAllNamed(AppRoutes.home);
    } else {
      errorMessage.value = 'PINs do not match. Please try again.';
      resetPinSetup();
    }
  }

  Future<void> _savePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_PIN_STORAGE_KEY, pin.value);
  }

  void resetPinSetup() {
    pin.value = '';
    temporaryPin.value = '';
    isConfirming.value = false;
    errorMessage.value = '';
  }

  Future<void> changePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_PIN_STORAGE_KEY);
    isPinSet.value = false;
    resetPinSetup();
  }
}