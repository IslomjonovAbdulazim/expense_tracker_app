// lib/features/screens/pin_code/_page.dart
part of 'imports.dart';

class PinCodePage extends GetView<_Controller> {
  const PinCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isPinSet.value
              ? 'Enter PIN'
              : controller.isConfirming.value
              ? 'Confirm PIN'
              : 'Create PIN',
          style: context.biggerName,
        )),
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.isPinSet.value) {
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showPinSettings(context),
                tooltip: 'PIN Settings',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top section with instructions and PIN dots
              Column(
                children: [
                  // Description text
                  Obx(() => Text(
                    controller.isPinSet.value
                        ? 'Enter your PIN to unlock the app'
                        : controller.isConfirming.value
                        ? 'Confirm your new PIN'
                        : 'Create a 4-digit PIN for app security',
                    style: context.body,
                    textAlign: TextAlign.center,
                  )),

                  const SizedBox(height: 40),

                  // PIN dots
                  Obx(() => _PinDots(
                    length: _Controller.pinLength,
                    pin: controller.pin.value,
                  )),

                  const SizedBox(height: 20),

                  // Error message
                  Obx(() => AnimatedOpacity(
                    opacity: controller.errorMessage.value.isEmpty ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      controller.errorMessage.value,
                      style: context.body.copyWith(
                        color: context.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ],
              ),

              // Bottom section with keypad
              Column(
                children: [
                  // PIN keypad
                  _PinKeypad(
                    onDigitPressed: controller.addDigit,
                    onBackspacePressed: controller.removeLastDigit,
                  ),

                  const SizedBox(height: 20),

                  // Reset button for PIN setup
                  Obx(() {
                    if (!controller.isPinSet.value && controller.isConfirming.value) {
                      return TextButton(
                        onPressed: controller.resetPinSetup,
                        child: const Text('Start Over'),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show PIN settings dialog
  void _showPinSettings(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('PIN Settings'),
        content: const Text('Do you want to change your PIN?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.changePin();
            },
            style: TextButton.styleFrom(
              foregroundColor: context.error,
            ),
            child: const Text('Change PIN'),
          ),
        ],
      ),
    );
  }
}