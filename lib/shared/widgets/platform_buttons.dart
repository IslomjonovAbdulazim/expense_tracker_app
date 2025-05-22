// lib/shared/buttons/platform_buttons.dart
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Base button configuration
class ButtonConfig {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool expanded;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ButtonConfig({
    this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.expanded = false,
    this.height,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
  });

  bool get isEnabled => onPressed != null && !isDisabled && !isLoading;
}

/// Universal platform-adaptive button
class PlatformButton extends StatelessWidget {
  final ButtonConfig config;
  final ButtonStyle style;

  const PlatformButton({
    Key? key,
    required this.config,
    this.style = ButtonStyle.primary,
  }) : super(key: key);

  // Named constructors for different button types
  PlatformButton.primary({
    Key? key,
    String? text,
    Widget? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    bool expanded = false,
    double? height,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? foregroundColor,
  }) : this(
          key: key,
          config: ButtonConfig(
            text: text,
            icon: icon,
            onPressed: onPressed,
            isLoading: isLoading,
            isDisabled: isDisabled,
            expanded: expanded,
            height: height,
            padding: padding,
            borderRadius: borderRadius,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
          ),
          style: ButtonStyle.primary,
        );

  PlatformButton.secondary({
    Key? key,
    String? text,
    Widget? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    bool expanded = false,
    double? height,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? foregroundColor,
  }) : this(
          key: key,
          config: ButtonConfig(
            text: text,
            icon: icon,
            onPressed: onPressed,
            isLoading: isLoading,
            isDisabled: isDisabled,
            expanded: expanded,
            height: height,
            padding: padding,
            borderRadius: borderRadius,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
          ),
          style: ButtonStyle.secondary,
        );

  PlatformButton.text({
    Key? key,
    String? text,
    Widget? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    EdgeInsetsGeometry? padding,
    Color? foregroundColor,
  }) : this(
          key: key,
          config: ButtonConfig(
            text: text,
            icon: icon,
            onPressed: onPressed,
            isLoading: isLoading,
            isDisabled: isDisabled,
            padding: padding,
            foregroundColor: foregroundColor,
          ),
          style: ButtonStyle.text,
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
    final theme = Theme.of(context);

    Widget button;

    switch (style) {
      case ButtonStyle.primary:
        button = ElevatedButton(
          onPressed: config.isEnabled ? config.onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                config.backgroundColor ?? theme.colorScheme.primary,
            foregroundColor:
                config.foregroundColor ?? theme.colorScheme.onPrimary,
            minimumSize: Size(
                config.expanded ? double.infinity : 0, config.height ?? 50),
            padding: config.padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: config.borderRadius ?? BorderRadius.circular(12),
            ),
          ),
          child: _buildButtonContent(context),
        );
        break;

      case ButtonStyle.secondary:
        button = OutlinedButton(
          onPressed: config.isEnabled ? config.onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor:
                config.foregroundColor ?? theme.colorScheme.primary,
            side: BorderSide(
              color: config.backgroundColor ?? theme.colorScheme.primary,
              width: 1.5,
            ),
            minimumSize: Size(
                config.expanded ? double.infinity : 0, config.height ?? 50),
            padding: config.padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: config.borderRadius ?? BorderRadius.circular(12),
            ),
          ),
          child: _buildButtonContent(context),
        );
        break;

      case ButtonStyle.text:
        button = TextButton(
          onPressed: config.isEnabled ? config.onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor:
                config.foregroundColor ?? theme.colorScheme.primary,
            padding: config.padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: _buildButtonContent(context),
        );
        break;
    }

    if (config.expanded) {
      return SizedBox(
        width: double.infinity,
        height: config.height,
        child: button,
      );
    }

    return button;
  }

  Widget _buildCupertinoButton(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color foregroundColor;

    switch (style) {
      case ButtonStyle.primary:
        backgroundColor = config.backgroundColor ?? theme.colorScheme.primary;
        foregroundColor = config.foregroundColor ?? CupertinoColors.white;
        break;
      case ButtonStyle.secondary:
        backgroundColor = Colors.transparent;
        foregroundColor = config.foregroundColor ?? theme.colorScheme.primary;
        break;
      case ButtonStyle.text:
        backgroundColor = Colors.transparent;
        foregroundColor = config.foregroundColor ?? theme.colorScheme.primary;
        break;
    }

    Widget button = CupertinoButton(
      onPressed: config.isEnabled ? config.onPressed : null,
      color: style == ButtonStyle.primary ? backgroundColor : null,
      padding: config.padding ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      borderRadius:
          config.borderRadius ?? const BorderRadius.all(Radius.circular(12)),
      child: _buildButtonContent(context, foregroundColor),
    );

    if (style == ButtonStyle.secondary) {
      button = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: config.backgroundColor ?? theme.colorScheme.primary,
            width: 1.5,
          ),
          borderRadius: config.borderRadius ?? BorderRadius.circular(12),
        ),
        child: button,
      );
    }

    if (config.expanded) {
      return SizedBox(
        width: double.infinity,
        height: config.height,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButtonContent(BuildContext context, [Color? textColor]) {
    if (config.isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(
                color: textColor ?? CupertinoColors.white)
            : CircularProgressIndicator(
                strokeWidth: 2,
                color: textColor ?? Theme.of(context).colorScheme.onPrimary,
              ),
      );
    }

    final List<Widget> children = [];

    if (config.icon != null) {
      children.add(IconTheme(
        data: IconThemeData(color: textColor),
        child: config.icon!,
      ));
      if (config.text != null) children.add(const SizedBox(width: 8));
    }

    if (config.text != null) {
      children.add(Text(
        config.text!,
        style: TextStyle(color: textColor),
        textAlign: TextAlign.center,
      ));
    }

    if (children.length == 1) return children.first;

    return Row(
      mainAxisSize: config.expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

enum ButtonStyle { primary, secondary, text }

/// Specialized buttons for common use cases
class BackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const BackButton({Key? key, this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformButton.text(
      icon: Icon(Platform.isIOS ? CupertinoIcons.back : Icons.arrow_back),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      foregroundColor: color,
    );
  }
}

class FloatingActionBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final String? tooltip;
  final bool isLoading;

  const FloatingActionBtn({
    Key? key,
    this.onPressed,
    this.icon,
    this.tooltip,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (Platform.isIOS) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
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
          onPressed: onPressed,
          child: isLoading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : icon ?? const Icon(Icons.add, color: Colors.white),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: isLoading
          ? CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.onPrimary,
            )
          : icon ?? const Icon(Icons.add),
    );
  }
}
