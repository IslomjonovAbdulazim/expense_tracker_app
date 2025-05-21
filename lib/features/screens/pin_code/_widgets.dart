part of 'imports.dart';

class _PinDigitButton extends StatelessWidget {
  final String digit;
  final VoidCallback onPressed;

  const _PinDigitButton({
    required this.digit,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Text(
                  digit,
                  style: context.title.copyWith(
                    fontSize: 28,
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

// PIN indicator dots
class _PinDots extends StatelessWidget {
  final int length;
  final String pin;

  const _PinDots({
    required this.length,
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pin.length
                ? context.primary
                : context.dividerColor,
          ),
        ),
      ),
    );
  }
}

// PIN keypad
class _PinKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onBackspacePressed;

  const _PinKeypad({
    required this.onDigitPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _PinDigitButton(digit: '1', onPressed: () => onDigitPressed('1')),
            _PinDigitButton(digit: '2', onPressed: () => onDigitPressed('2')),
            _PinDigitButton(digit: '3', onPressed: () => onDigitPressed('3')),
          ],
        ),
        Row(
          children: [
            _PinDigitButton(digit: '4', onPressed: () => onDigitPressed('4')),
            _PinDigitButton(digit: '5', onPressed: () => onDigitPressed('5')),
            _PinDigitButton(digit: '6', onPressed: () => onDigitPressed('6')),
          ],
        ),
        Row(
          children: [
            _PinDigitButton(digit: '7', onPressed: () => onDigitPressed('7')),
            _PinDigitButton(digit: '8', onPressed: () => onDigitPressed('8')),
            _PinDigitButton(digit: '9', onPressed: () => onDigitPressed('9')),
          ],
        ),
        Row(
          children: [
            Expanded(child: SizedBox()),
            _PinDigitButton(digit: '0', onPressed: () => onDigitPressed('0')),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onBackspacePressed,
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Icon(
                          Icons.backspace_outlined,
                          color: context.textPrimary,
                          size: 28,
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
}