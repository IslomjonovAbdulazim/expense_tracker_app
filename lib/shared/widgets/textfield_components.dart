// lib/shared/widgets/textfield_components.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/extenstions/color_extension.dart';
import '../../utils/extenstions/text_style_extention.dart';
import '../../utils/helpers/validation_helper.dart';

/// Enhanced text field with consistent styling and validation
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool showCounter;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onEditingComplete,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.controller,
    this.showCounter = false,
    this.helperText,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.showCounter ? widget.maxLength : null,
          inputFormatters: widget.inputFormatters,
          style: context.bodyLarge,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            helperText: widget.helperText,
            counterText: widget.showCounter ? null : '',
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

            // Borders
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.dividerColor.withOpacity(0.5)),
            ),

            // Colors
            filled: true,
            fillColor: widget.enabled
                ? (_isFocused ? context.surface : context.cardColor)
                : context.cardColor.withOpacity(0.5),

            // Label styling
            labelStyle: context.bodyMedium.copyWith(
              color: _isFocused ? context.primary : context.textSecondary,
            ),
            floatingLabelStyle: context.bodyMedium.copyWith(
              color: context.primary,
              fontWeight: FontWeight.w600,
            ),
            hintStyle: context.bodyMedium.copyWith(
              color: context.textSecondary.withOpacity(0.7),
            ),
            helperStyle: context.bodySmall.copyWith(
              color: context.textSecondary,
            ),
            errorStyle: context.bodySmall.copyWith(
              color: context.error,
            ),
          ),
        ),
      ],
    );
  }
}

/// Specialized text fields for common use cases
class EmailTextField extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;

  const EmailTextField({
    Key? key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label ?? 'Email',
      hint: hint ?? 'Enter your email address',
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: Icon(Icons.email_outlined, color: context.textSecondary),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!ValidationHelper.isValidEmail(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final bool isNewPassword;
  final TextInputAction? textInputAction;

  const PasswordTextField({
    Key? key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.isNewPassword = false,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label ?? 'Password',
      hint: widget.hint ?? 'Enter your password',
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      prefixIcon: Icon(Icons.lock_outlined, color: context.textSecondary),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: context.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      validator: widget.validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (widget.isNewPassword && !ValidationHelper.isValidPassword(value)) {
          return 'Password must be at least 8 characters with uppercase, digit, and special character';
        }
        return null;
      },
    );
  }
}

class NameTextField extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final bool isRequired;

  const NameTextField({
    Key? key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.isRequired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label ?? 'Full Name',
      hint: hint ?? 'Enter your full name',
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      prefixIcon: Icon(Icons.person_outlined, color: context.textSecondary),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      ],
      validator: validator ?? (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return 'Name is required';
        }
        if (value != null && value.trim().isNotEmpty && value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }
}

class PhoneTextField extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? countryCode;

  const PhoneTextField({
    Key? key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.countryCode = '+998',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label ?? 'Phone Number',
      hint: hint ?? 'Enter your phone number',
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone_outlined, color: context.textSecondary),
            const SizedBox(width: 8),
            Text(
              countryCode!,
              style: context.bodyMedium.copyWith(
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: context.dividerColor,
              margin: const EdgeInsets.only(left: 8),
            ),
          ],
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
      ],
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        if (value.length != 9) {
          return 'Phone number must be 9 digits';
        }
        return null;
      },
    );
  }
}

class SearchTextField extends StatelessWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;

  const SearchTextField({
    Key? key,
    this.hint,
    this.onChanged,
    this.onTap,
    this.controller,
    this.focusNode,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hint: hint ?? 'Search...',
      onChanged: onChanged,
      onTap: onTap,
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      prefixIcon: Icon(Icons.search, color: context.textSecondary),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
        icon: Icon(Icons.clear, color: context.textSecondary),
        onPressed: () {
          controller?.clear();
          onChanged?.call('');
        },
      )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class AmountTextField extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String currency;

  const AmountTextField({
    Key? key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.currency = 'UZS',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label ?? 'Amount',
      hint: hint ?? 'Enter amount',
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monetization_on_outlined, color: context.textSecondary),
            const SizedBox(width: 8),
            Text(
              currency,
              style: context.bodyMedium.copyWith(
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.split('.').length > 2) {
            return oldValue;
          }
          return newValue;
        }),
      ],
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Amount is required';
        }
        final amount = double.tryParse(value);
        if (amount == null) {
          return 'Please enter a valid amount';
        }
        if (amount <= 0) {
          return 'Amount must be greater than 0';
        }
        return null;
      },
    );
  }
}

/// Form field wrapper with consistent spacing
class FormFieldWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const FormFieldWrapper({
    Key? key,
    required this.child,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      child: child,
    );
  }
}