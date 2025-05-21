// lib/widgets/buttons/platform_buttons.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

/// Base class for all platform-adaptive buttons
abstract class PlatformButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;

  const PlatformButton({
    Key? key,
    this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
  }) : super(key: key);

  bool get _isEnabled => onPressed != null && !isDisabled && !isLoading;
}

/// Primary button - Used for primary actions (Save, Submit, Continue, etc.)
class PrimaryButton extends PlatformButton {
  final bool expanded;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const PrimaryButton({
    Key? key,
    String? text,
    Widget? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    this.expanded = false,
    this.height,
    this.padding,
    this.borderRadius,
  }) : super(
    key: key,
    text: text,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
  );

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoButton(context);
    } else {
      return _buildMaterialButton(context);
    }
  }

  Widget _buildMaterialButton(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: _isEnabled
          ? context.theme.colorScheme.primary
          : context.theme.colorScheme.primary.withOpacity(0.5),
      foregroundColor: context.theme.colorScheme.onPrimary,
      minimumSize: Size(expanded ? double.infinity : 0, height ?? 50),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
    );

    Widget buttonChild = _isEnabled
        ? _buildButtonContent(context, context.theme.colorScheme.onPrimary)
        : _buildButtonContent(context, context.theme.colorScheme.onPrimary.withOpacity(0.7));

    return ElevatedButton(
      style: style,
      onPressed: _isEnabled ? onPressed : null,
      child: buttonChild,
    );
  }

  Widget _buildCupertinoButton(BuildContext context) {
    Widget buttonContent = _buildButtonContent(
      context,
      _isEnabled ? CupertinoColors.white : CupertinoColors.white.withOpacity(0.7),
    );

    final Widget button = CupertinoButton(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: _isEnabled
          ? context.theme.colorScheme.primary
          : context.theme.colorScheme.primary.withOpacity(0.5),
      disabledColor: context.theme.colorScheme.primary.withOpacity(0.5),
      onPressed: _isEnabled ? onPressed : null,
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16)),
      child: buttonContent,
    );

    if (expanded) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: button,
      );
    } else {
      return SizedBox(
        height: height,
        child: button,
      );
    }
  }

  Widget _buildButtonContent(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: Platform.isIOS
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : CircularProgressIndicator(
          strokeWidth: 2,
          color: textColor,
        ),
      );
    }

    if (text != null && icon != null) {
      return Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(data: IconThemeData(color: textColor), child: icon!),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text!,
              style: TextStyle(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else if (icon != null) {
      return IconTheme(data: IconThemeData(color: textColor), child: icon!);
    } else if (text != null) {
      return Text(
        text!,
        style: TextStyle(color: textColor),
        textAlign: TextAlign.center,
      );
    }

    return const SizedBox.shrink();
  }
}

/// Secondary button - Used for secondary actions (Cancel, Back, etc.)
class SecondaryButton extends PlatformButton {
  final bool expanded;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const SecondaryButton({
    Key? key,
    String? text,
    Widget? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    this.expanded = false,
    this.height,
    this.padding,
    this.borderRadius,
  }) : super(
    key: key,
    text: text,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
  );

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoButton(context);
    } else {
      return _buildMaterialButton(context);
    }
  }

  Widget _buildMaterialButton(BuildContext context) {
    final ButtonStyle style = OutlinedButton.styleFrom(
      foregroundColor: _isEnabled
          ? context.theme.colorScheme.primary
          : context.theme.colorScheme.primary.withOpacity(0.5),
      side: BorderSide(
        color: _isEnabled
            ? context.theme.colorScheme.primary
            : context.theme.colorScheme.primary.withOpacity(0.5),
        width: 1.5,
      ),
      minimumSize: Size(expanded ? double.infinity : 0, height ?? 50),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
    );

    Widget buttonChild = _isEnabled
        ? _buildButtonContent(context, context.theme.colorScheme.primary)
        : _buildButtonContent(context, context.theme.colorScheme.primary.withOpacity(0.7));

    return OutlinedButton(
      style: style,
      onPressed: _isEnabled ? onPressed : null,
      child: buttonChild,
    );
  }

  Widget _buildCupertinoButton(BuildContext context) {
    final Color textColor =
    _isEnabled ? context.theme.colorScheme.primary : context.theme.colorScheme.primary.withOpacity(0.5);

    Widget buttonChild = _buildButtonContent(context, textColor);

    final Widget button = CupertinoButton(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Colors.transparent,
      onPressed: _isEnabled ? onPressed : null,
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: textColor,
            width: 1.5,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: buttonChild,
      ),
    );

    if (expanded) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: button,
      );
    } else {
      return SizedBox(
        height: height,
        child: button,
      );
    }
  }

  Widget _buildButtonContent(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(color: textColor)
            : CircularProgressIndicator(
          strokeWidth: 2,
          color: textColor,
        ),
      );
    }

    if (text != null && icon != null) {
      return Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(data: IconThemeData(color: textColor), child: icon!),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text!,
              style: TextStyle(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else if (icon != null) {
      return IconTheme(data: IconThemeData(color: textColor), child: icon!);
    } else if (text != null) {
      return Text(
        text!,
        style: TextStyle(color: textColor),
        textAlign: TextAlign.center,
      );
    }

    return const SizedBox.shrink();
  }
}

/// Text button - Used for tertiary actions (Forgot Password, Learn More, etc.)
class TextActionButton extends PlatformButton {
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const TextActionButton({
    Key? key,
    String? text,
    Widget? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    this.textStyle,
    this.padding,
  }) : super(
    key: key,
    text: text,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
  );

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoButton(context);
    } else {
      return _buildMaterialButton(context);
    }
  }

  Widget _buildMaterialButton(BuildContext context) {
    final Color textColor = _isEnabled
        ? context.theme.colorScheme.primary
        : context.theme.colorScheme.primary.withOpacity(0.5);

    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: textColor,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );

    Widget buttonChild = _buildButtonContent(context, textColor);

    return TextButton(
      style: style,
      onPressed: _isEnabled ? onPressed : null,
      child: buttonChild,
    );
  }

  Widget _buildCupertinoButton(BuildContext context) {
    final Color textColor = _isEnabled
        ? context.theme.colorScheme.primary
        : context.theme.colorScheme.primary.withOpacity(0.5);

    Widget buttonChild = _buildButtonContent(context, textColor);

    return CupertinoButton(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onPressed: _isEnabled ? onPressed : null,
      child: buttonChild,
    );
  }

  Widget _buildButtonContent(BuildContext context, Color textColor) {
    final effectiveTextStyle = textStyle ??
        TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        );

    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(color: textColor)
            : CircularProgressIndicator(
          strokeWidth: 2,
          color: textColor,
        ),
      );
    }

    if (text != null && icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(data: IconThemeData(color: textColor), child: icon!),
          const SizedBox(width: 4),
          Text(
            text!,
            style: effectiveTextStyle,
          ),
        ],
      );
    } else if (icon != null) {
      return IconTheme(data: IconThemeData(color: textColor), child: icon!);
    } else if (text != null) {
      return Text(
        text!,
        style: effectiveTextStyle,
      );
    }

    return const SizedBox.shrink();
  }
}

/// Icon button - Used for compact actions (Add, Delete, etc.)
class IconActionButton extends PlatformButton {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final BorderRadius? borderRadius;

  const IconActionButton({
    Key? key,
    Widget? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
  }) : super(
    key: key,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
  );

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoButton(context);
    } else {
      return _buildMaterialButton(context);
    }
  }

  Widget _buildMaterialButton(BuildContext context) {
    final Color effectiveIconColor = iconColor ??
        (_isEnabled
            ? context.theme.colorScheme.primary
            : context.theme.colorScheme.primary.withOpacity(0.5));

    final Color effectiveBackgroundColor = backgroundColor ??
        (_isEnabled ? context.theme.cardColor : context.theme.cardColor.withOpacity(0.5));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
          onTap: _isEnabled ? onPressed : null,
          child: _buildIconContent(effectiveIconColor),
        ),
      ),
    );
  }

  Widget _buildCupertinoButton(BuildContext context) {
    final Color effectiveIconColor = iconColor ??
        (_isEnabled
            ? context.theme.colorScheme.primary
            : context.theme.colorScheme.primary.withOpacity(0.5));

    final Color effectiveBackgroundColor = backgroundColor ??
        (_isEnabled ? context.theme.cardColor : context.theme.cardColor.withOpacity(0.5));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _isEnabled ? onPressed : null,
        child: _buildIconContent(effectiveIconColor),
      ),
    );
  }

  Widget _buildIconContent(Color iconColor) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: size / 2.5,
          width: size / 2.5,
          child: Platform.isIOS
              ? CupertinoActivityIndicator(color: iconColor)
              : CircularProgressIndicator(
            strokeWidth: 2,
            color: iconColor,
          ),
        ),
      );
    }

    return Center(
      child: IconTheme(
        data: IconThemeData(
          color: iconColor,
          size: size / 2,
        ),
        child: icon ?? const Icon(Icons.add),
      ),
    );
  }
}

/// Floating action button - Used for the primary action on a screen
class FloatingActionBtn extends PlatformButton {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;

  const FloatingActionBtn({
    Key? key,
    Widget? icon,
    String? text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    this.size = 56,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
  }) : super(
    key: key,
    icon: icon,
    text: text,
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
  );

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoButton(context);
    } else {
      return _buildMaterialButton(context);
    }
  }

  Widget _buildMaterialButton(BuildContext context) {
    final Color effectiveBackgroundColor = backgroundColor ??
        (_isEnabled
            ? context.theme.colorScheme.primary
            : context.theme.colorScheme.primary.withOpacity(0.5));

    final Color effectiveIconColor =
        iconColor ?? (_isEnabled ? Colors.white : Colors.white.withOpacity(0.7));

    Widget buttonContent = _buildButtonContent(effectiveIconColor);

    return FloatingActionButton(
      onPressed: _isEnabled ? onPressed : null,
      backgroundColor: effectiveBackgroundColor,
      tooltip: tooltip,
      elevation: 6,
      child: buttonContent,
    );
  }

  Widget _buildCupertinoButton(BuildContext context) {
    final Color effectiveBackgroundColor = backgroundColor ??
        (_isEnabled
            ? context.theme.colorScheme.primary
            : context.theme.colorScheme.primary.withOpacity(0.5));

    final Color effectiveIconColor =
        iconColor ?? (_isEnabled ? Colors.white : Colors.white.withOpacity(0.7));

    Widget buttonContent = _buildButtonContent(effectiveIconColor);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _isEnabled ? onPressed : null,
        child: buttonContent,
      ),
    );
  }

  Widget _buildButtonContent(Color iconColor) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: Platform.isIOS
            ? const CupertinoActivityIndicator(color: Colors.white)
            : CircularProgressIndicator(
          strokeWidth: 2,
          color: iconColor,
        ),
      );
    }

    if (text != null && icon != null) {
      // Extended FAB
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(data: IconThemeData(color: iconColor), child: icon!),
          const SizedBox(width: 8),
          Text(
            text!,
            style: TextStyle(color: iconColor),
          ),
        ],
      );
    } else if (icon != null) {
      return IconTheme(data: IconThemeData(color: iconColor), child: icon!);
    } else if (text != null) {
      return Text(
        text!,
        style: TextStyle(color: iconColor),
      );
    }

    return Icon(Icons.add, color: iconColor);
  }
}

/// Back button - Platform-specific back button
class BackBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final String? tooltip;

  const BackBtn({
    Key? key,
    this.onPressed,
    this.color,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
        child: Icon(
          CupertinoIcons.back,
          color: color ?? context.theme.colorScheme.primary,
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        color: color ?? context.theme.colorScheme.primary,
        tooltip: tooltip ?? 'Back',
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
      );
    }
  }
}

/// Toggle button - For on/off states
class ToggleActionButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool isDisabled;

  const ToggleActionButton({
    Key? key,
    required this.value,
    this.onChanged,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoToggle(context);
    } else {
      return _buildMaterialToggle(context);
    }
  }

  Widget _buildMaterialToggle(BuildContext context) {
    final effectiveActiveColor = activeColor ?? context.theme.colorScheme.primary;

    Widget toggleWidget = Switch(
      value: value,
      onChanged: isDisabled ? null : onChanged,
      activeColor: effectiveActiveColor,
      inactiveThumbColor: inactiveColor,
    );

    if (label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: TextStyle(
              color: isDisabled
                  ? context.theme.colorScheme.onSurface.withOpacity(0.5)
                  : context.theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          toggleWidget,
        ],
      );
    }

    return toggleWidget;
  }

  Widget _buildCupertinoToggle(BuildContext context) {
    final effectiveActiveColor = activeColor ?? context.theme.colorScheme.primary;

    Widget toggleWidget = CupertinoSwitch(
      value: value,
      onChanged: isDisabled ? null : onChanged,
      activeColor: effectiveActiveColor,
      thumbColor: CupertinoColors.white,
    );

    if (label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: TextStyle(
              color: isDisabled
                  ? context.theme.colorScheme.onSurface.withOpacity(0.5)
                  : context.theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          toggleWidget,
        ],
      );
    }

    return toggleWidget;
  }
}

/// Card button - A button that looks like a clickable card
class CardButton extends PlatformButton {
  final Widget? leading;
  final Widget? trailing;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double elevation;

  const CardButton({
    Key? key,
    String? text,
    Widget? icon,
    this.leading,
    this.trailing,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    this.height,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.elevation = 1,
  }) : super(
    key: key,
    text: text,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
  );

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor = backgroundColor ??
        (_isEnabled ? context.theme.cardColor : context.theme.cardColor.withOpacity(0.8));

    if (Platform.isIOS) {
      return _buildCupertinoCard(context, effectiveBackgroundColor);
    } else {
      return _buildMaterialCard(context, effectiveBackgroundColor);
    }
  }

  Widget _buildMaterialCard(BuildContext context, Color backgroundColor) {
    return Card(
      elevation: elevation,
      color: backgroundColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        onTap: _isEnabled ? onPressed : null,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: _buildCardContent(context),
        ),
      ),
    );
  }

  Widget _buildCupertinoCard(BuildContext context, Color backgroundColor) {
    return GestureDetector(
      onTap: _isEnabled ? onPressed : null,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          boxShadow: elevation > 0
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: elevation * 2,
              spreadRadius: elevation / 2,
            ),
          ]
              : null,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: _buildCardContent(context),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: Platform.isIOS
              ? const CupertinoActivityIndicator()
              : CircularProgressIndicator(
            strokeWidth: 2,
            color: context.theme.colorScheme.primary,
          ),
        ),
      );
    }

    final List<Widget> rowChildren = [];

    if (leading != null) {
      rowChildren.add(leading!);
      rowChildren.add(const SizedBox(width: 16));
    } else if (icon != null) {
      rowChildren.add(icon!);
      rowChildren.add(const SizedBox(width: 16));
    }

    if (text != null) {
      rowChildren.add(
        Expanded(
          child: Text(
            text!,
            style: TextStyle(
              color: _isEnabled
                  ? context.theme.colorScheme.onSurface
                  : context.theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    if (trailing != null) {
      rowChildren.add(const SizedBox(width: 16));
      rowChildren.add(trailing!);
    } else {
      rowChildren.add(
        Icon(
          Platform.isIOS ? Icons.chevron_right : Icons.arrow_forward_ios,
          size: 16,
          color: _isEnabled
              ? context.theme.colorScheme.onSurface.withOpacity(0.5)
              : context.theme.colorScheme.onSurface.withOpacity(0.3),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: rowChildren,
    );
  }
}

/// Chip button - For filters, tags, or small actions
class ChipButton extends PlatformButton {
  final bool selected;
  final VoidCallback? onSelected;
  final Color? selectedColor;
  final Color? backgroundColor;
  final Widget? avatar;
  final bool showCheckmark;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const ChipButton({
    Key? key,
    String? text,
    Widget? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    this.selected = false,
    this.onSelected,
    this.selectedColor,
    this.backgroundColor,
    this.avatar,
    this.showCheckmark = false,
    this.padding,
    this.borderRadius,
  }) : super(
    key: key,
    text: text,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
  );

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? context.theme.colorScheme.primary;
    final effectiveBackgroundColor = backgroundColor ?? context.theme.cardColor;

    if (Platform.isIOS) {
      return _buildCupertinoChip(context, effectiveSelectedColor, effectiveBackgroundColor);
    } else {
      return _buildMaterialChip(context, effectiveSelectedColor, effectiveBackgroundColor);
    }
  }

  Widget _buildMaterialChip(
      BuildContext context, Color selectedColor, Color backgroundColor) {
    return FilterChip(
      label: Text(
        text ?? '',
        style: TextStyle(
          color: selected
              ? context.theme.colorScheme.onPrimary
              : _isEnabled
              ? context.theme.colorScheme.onSurface
              : context.theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      avatar: avatar,
      showCheckmark: showCheckmark,
      selected: selected,
      onSelected: _isEnabled
          ? (value) {
        if (onSelected != null) {
          onSelected!();
        } else if (onPressed != null) {
          onPressed!();
        }
      }
          : null,
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      disabledColor: backgroundColor.withOpacity(0.7),
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(50),
      ),
    );
  }

  Widget _buildCupertinoChip(
      BuildContext context, Color selectedColor, Color backgroundColor) {
    return GestureDetector(
      onTap: _isEnabled
          ? () {
        if (onSelected != null) {
          onSelected!();
        } else if (onPressed != null) {
          onPressed!();
        }
      }
          : null,
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
        decoration: BoxDecoration(
          color: selected ? selectedColor : backgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(50),
          border: Border.all(
            color: selected ? selectedColor : context.theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar != null) ...[
              avatar!,
              const SizedBox(width: 8),
            ],
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: selected
                      ? context.theme.colorScheme.onPrimary
                      : _isEnabled
                      ? context.theme.colorScheme.onSurface
                      : context.theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 16,
                ),
                child: icon!,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              text ?? '',
              style: TextStyle(
                color: selected
                    ? context.theme.colorScheme.onPrimary
                    : _isEnabled
                    ? context.theme.colorScheme.onSurface
                    : context.theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            if (selected && showCheckmark) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.check,
                size: 16,
                color: context.theme.colorScheme.onPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bottom Action Button - A fixed button at the bottom of the screen
class BottomActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const BottomActionButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.padding,
    this.margin,
  }) : super(key: key);

  bool get _isEnabled => onPressed != null && !isDisabled && !isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ??
        (_isEnabled
            ? context.theme.colorScheme.primary
            : context.theme.colorScheme.primary.withOpacity(0.5));

    final effectiveTextColor =
        textColor ?? (_isEnabled ? Colors.white : Colors.white.withOpacity(0.7));

    return Container(
      width: double.infinity,
      padding: margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Platform.isIOS
          ? CupertinoButton(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        color: effectiveBackgroundColor,
        disabledColor: effectiveBackgroundColor,
        onPressed: _isEnabled ? onPressed : null,
        child: _buildButtonContent(effectiveTextColor),
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isEnabled ? onPressed : null,
        child: _buildButtonContent(effectiveTextColor),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: Platform.isIOS
            ? const CupertinoActivityIndicator(color: Colors.white)
            : CircularProgressIndicator(
          strokeWidth: 2,
          color: textColor,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(data: IconThemeData(color: textColor), child: icon!),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Segmented control - For selecting from a small set of options
class SegmentedControl<T extends Object> extends StatelessWidget {
  final Map<T, Widget> children;
  final T? groupValue;
  final ValueChanged<T?>? onValueChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final bool isDisabled;

  const SegmentedControl({
    Key? key,
    required this.children,
    required this.groupValue,
    required this.onValueChanged,
    this.backgroundColor,
    this.selectedColor,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoSegmentedControl(context);
    } else {
      return _buildMaterialSegmentedControl(context);
    }
  }

  Widget _buildCupertinoSegmentedControl(BuildContext context) {
    // Handle the case where groupValue might be null
    if (groupValue == null) {
      return const SizedBox.shrink();
    }

    // Fixed: The onValueChanged function is properly cast now
    final ValueChanged<T>? effectiveOnValueChanged = isDisabled
        ? null
        : (T value) => onValueChanged?.call(value);

    return CupertinoSegmentedControl<T>(
      children: children,
      groupValue: groupValue!,
      onValueChanged: effectiveOnValueChanged!,
      selectedColor: selectedColor ?? context.theme.colorScheme.primary,
      borderColor: isDisabled
          ? context.theme.colorScheme.primary.withOpacity(0.3)
          : context.theme.colorScheme.primary,
      pressedColor: isDisabled
          ? context.theme.colorScheme.primary.withOpacity(0.1)
          : context.theme.colorScheme.primary.withOpacity(0.2),
    );
  }

  Widget _buildMaterialSegmentedControl(BuildContext context) {
    // Handle the case where groupValue might be null
    if (groupValue == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SegmentedButton<T>(
        segments: children.entries.map((entry) {
          return ButtonSegment<T>(
            value: entry.key,
            label: entry.value,
          );
        }).toList(),
        selected: {groupValue!},
        onSelectionChanged: isDisabled
            ? null
            : (Set<T> newSelection) {
          if (newSelection.isNotEmpty) {
            onValueChanged?.call(newSelection.first);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return selectedColor ?? context.theme.colorScheme.primary;
            }
            return null;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return context.theme.colorScheme.onPrimary;
            }
            return context.theme.colorScheme.onSurface;
          }),
        ),
      ),
    );
  }
}
