part of 'imports.dart';

class PinCodePage extends GetView<_Controller> {
  const PinCodePage({super.key});

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
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Show change PIN dialog
                  Get.dialog(
                    AlertDialog(
                      title: Text('PIN Settings'),
                      content: Text('Do you want to change your PIN?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.changePin();
                          },
                          child: Text('Change PIN'),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

            SizedBox(height: 40),

            // PIN dots
            Obx(() => _PinDots(
              length: _Controller.PIN_LENGTH,
              pin: controller.pin.value,
            )),

            SizedBox(height: 20),

            // Error message
            Obx(() => AnimatedOpacity(
              opacity: controller.errorMessage.value.isEmpty ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: Text(
                controller.errorMessage.value,
                style: context.body.copyWith(
                  color: context.error,
                ),
                textAlign: TextAlign.center,
              ),
            )),

            SizedBox(height: 40),

            // PIN keypad
            Expanded(
              child: _PinKeypad(
                onDigitPressed: controller.addDigit,
                onBackspacePressed: controller.removeLastDigit,
              ),
            ),

            // Reset button for PIN setup
            Obx(() {
              if (!controller.isPinSet.value && controller.isConfirming.value) {
                return TextButton(
                  onPressed: controller.resetPinSetup,
                  child: Text('Start Over'),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}