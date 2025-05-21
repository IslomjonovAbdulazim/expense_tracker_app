import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A Text widget that automatically translates its content
class TrText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Map<String, String>? params;
  final num? count;

  const TrText(
      this.text, {
        Key? key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.params,
        this.count,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String translatedText;

    if (count != null) {
      if (params != null) {
        translatedText = text.trPluralParams(count!, params!);
      } else {
        translatedText = text.trPlural(count!);
      }
    } else if (params != null) {
      translatedText = text.trParams(params!);
    } else {
      translatedText = text.tr;
    }

    return Text(
      translatedText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}