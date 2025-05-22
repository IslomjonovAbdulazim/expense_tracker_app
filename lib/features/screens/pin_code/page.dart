// lib/features/screens/pin_code/_page.dart
part of 'imports.dart';

class PinCodePage extends GetView<PinCodeController> {
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
          style: context.headingMedium,
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
          child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top section with instructions and PIN dots
                          Column(
                            children: [
                              // App logo or icon (optional) - Make this optional based on available space
                              constraints.maxHeight > 600
                                  ? Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Icon(
                                  Icons.lock_rounded,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                                  : const SizedBox(height: 12),

                              // Description text
                              Obx(() => Text(
                                controller.isPinSet.value
                                    ? 'Enter your PIN to unlock the app'
                                    : controller.isConfirming.value
                                    ? 'Confirm your new PIN'
                                    : 'Create a 4-digit PIN for app security',
                                style: context.bodyLarge,
                                textAlign: TextAlign.center,
                              )),

                              // Adjustable spacing
                              SizedBox(height: constraints.maxHeight > 700 ? 40 : 20),

                              // PIN dots
                              Obx(() {
                                // Create the dots manually to avoid references to other files
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    4, // hardcoded number of PIN digits
                                        (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                      width: index < controller.pin.value.length ? 24 : 20,
                                      height: index < controller.pin.value.length ? 24 : 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index < controller.pin.value.length
                                            ? Theme.of(context).colorScheme.primary
                                            : Theme.of(context).dividerColor,
                                        boxShadow: index < controller.pin.value.length
                                            ? [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          )
                                        ]
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              }),

                              const SizedBox(height: 16),

                              // Error message - Fixed height container
                              Obx(() => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: controller.errorMessage.value.isEmpty ? 0 : 40,
                                child: AnimatedOpacity(
                                  opacity: controller.errorMessage.value.isEmpty ? 0.0 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: context.bodyMedium.copyWith(
                                      color: Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )),
                            ],
                          ),

                          // Spacer for flexible spacing
                          const Spacer(),

                          // Bottom section with keypad
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // PIN keypad - Implementing it directly
                              buildPinKeypad(context, constraints),

                              // Adjustable spacing
                              SizedBox(height: constraints.maxHeight > 700 ? 24 : 12),

                              // Reset button for PIN setup - Keep minimal height when not shown
                              Obx(() {
                                if (!controller.isPinSet.value && controller.isConfirming.value) {
                                  return TextButton.icon(
                                    onPressed: controller.resetPinSetup,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Start Over'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context).colorScheme.primary,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      textStyle: context.labelLarge,
                                    ),
                                  );
                                }
                                return const SizedBox(height: 8);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }

  // Build PIN keypad directly in the page
  Widget buildPinKeypad(BuildContext context, BoxConstraints constraints) {
    // Adjust padding based on available height
    final buttonPadding = constraints.maxHeight < 600 ? 4.0 : 8.0;
    final rowSpacing = constraints.maxHeight < 600 ? 4.0 : 8.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            buildPinDigitButton(context, '1', buttonPadding),
            buildPinDigitButton(context, '2', buttonPadding),
            buildPinDigitButton(context, '3', buttonPadding),
          ],
        ),
        SizedBox(height: rowSpacing),
        Row(
          children: [
            buildPinDigitButton(context, '4', buttonPadding),
            buildPinDigitButton(context, '5', buttonPadding),
            buildPinDigitButton(context, '6', buttonPadding),
          ],
        ),
        SizedBox(height: rowSpacing),
        Row(
          children: [
            buildPinDigitButton(context, '7', buttonPadding),
            buildPinDigitButton(context, '8', buttonPadding),
            buildPinDigitButton(context, '9', buttonPadding),
          ],
        ),
        SizedBox(height: rowSpacing),
        Row(
          children: [
            const Expanded(child: SizedBox()),
            buildPinDigitButton(context, '0', buttonPadding),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: EdgeInsets.all(buttonPadding),
                  child: Material(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 1,
                    child: InkWell(
                      onTap: controller.removeLastDigit,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Icon(
                          Icons.backspace_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Build PIN digit button directly in the page
  Widget buildPinDigitButton(BuildContext context, String digit, double padding) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            elevation: 1,
            child: InkWell(
              onTap: () => controller.addDigit(digit),
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  digit,
                  style: context.numberLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ) ?? TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Show PIN settings dialog
  void _showPinSettings(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('PIN Settings', style: context.headingSmall),
        content: Text(
          'You can change your PIN or disable PIN protection.',
          style: context.bodyMedium,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              textStyle: context.labelMedium,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.changePin();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              textStyle: context.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            child: const Text('Change PIN'),
          ),
        ],
      ),
    );
  }
}