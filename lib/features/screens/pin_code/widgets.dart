// PIN keypad
part of 'imports.dart';

class _PinKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onBackspacePressed;

  const _PinKeypad({
    required this.onDigitPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          // Adjust padding based on available height
          final buttonPadding = constraints.maxHeight < 300 ? 4.0 : 8.0;
          final rowSpacing = constraints.maxHeight < 300 ? 4.0 : 8.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _PinDigitButton(
                    digit: '1',
                    onPressed: () => onDigitPressed('1'),
                    padding: buttonPadding,
                  ),
                  _PinDigitButton(
                    digit: '2',
                    onPressed: () => onDigitPressed('2'),
                    padding: buttonPadding,
                  ),
                  _PinDigitButton(
                    digit: '3',
                    onPressed: () => onDigitPressed('3'),
                    padding: buttonPadding,
                  ),
                ],
              ),
              SizedBox(height: rowSpacing),
              Row(
                children: [
                  _PinDigitButton(
                    digit: '4',
                    onPressed: () => onDigitPressed('4'),
                    padding: buttonPadding,
                  ),
                  _PinDigitButton(
                    digit: '5',
                    onPressed: () => onDigitPressed('5'),
                    padding: buttonPadding,
                  ),
                  _PinDigitButton(
                    digit: '6',
                    onPressed: () => onDigitPressed('6'),
                    padding: buttonPadding,
                  ),
                ],
              ),
              SizedBox(height: rowSpacing),
              Row(
                children: [
                  _PinDigitButton(
                    digit: '7',
                    onPressed: () => onDigitPressed('7'),
                    padding: buttonPadding,
                  ),
                  _PinDigitButton(
                    digit: '8',
                    onPressed: () => onDigitPressed('8'),
                    padding: buttonPadding,
                  ),
                  _PinDigitButton(
                    digit: '9',
                    onPressed: () => onDigitPressed('9'),
                    padding: buttonPadding,
                  ),
                ],
              ),
              SizedBox(height: rowSpacing),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  _PinDigitButton(
                    digit: '0',
                    onPressed: () => onDigitPressed('0'),
                    padding: buttonPadding,
                  ),
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
                            onTap: onBackspacePressed,
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: Icon(
                                Icons.backspace_outlined,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 24, // Slightly smaller icon
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
    );
  }
}

// And update the PinDigitButton to accept flexible padding
class _PinDigitButton extends StatelessWidget {
  final String digit;
  final VoidCallback onPressed;
  final double padding;

  const _PinDigitButton({
    required this.digit,
    required this.onPressed,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
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
              onTap: onPressed,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  digit,
                  style: context.numberLarge.copyWith(
                    fontSize: 26, // Slightly smaller for better fit
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
}