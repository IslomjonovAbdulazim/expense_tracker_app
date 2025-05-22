// lib/shared/widgets/setup_progress_indicator.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/extenstions/color_extension.dart';
import '../../utils/extenstions/text_style_extention.dart';

class SetupProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;
  final bool showLabels;
  final double height;

  const SetupProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
    this.showLabels = true,
    this.height = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        _buildProgressBar(context),

        if (showLabels) ...[
          const SizedBox(height: 12),
          _buildStepLabels(context),
        ],
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final progress = totalSteps > 0 ? (currentStep / totalSteps).clamp(0.0, 1.0) : 0.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.dividerColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: height,
            width: Get.width * progress,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primary,
                  context.secondary,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(height / 2),
              boxShadow: [
                BoxShadow(
                  color: context.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLabels(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        stepLabels.length,
            (index) => _buildStepLabel(context, index),
      ),
    );
  }

  Widget _buildStepLabel(BuildContext context, int index) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final isUpcoming = index > currentStep;

    Color color;
    FontWeight fontWeight;

    if (isCompleted) {
      color = context.primary;
      fontWeight = FontWeight.w600;
    } else if (isCurrent) {
      color = context.primary;
      fontWeight = FontWeight.bold;
    } else {
      color = context.textSecondary;
      fontWeight = FontWeight.normal;
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isCompleted || isCurrent
                  ? context.primary
                  : Colors.transparent,
              border: Border.all(
                color: isCompleted || isCurrent
                    ? context.primary
                    : context.dividerColor,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              )
                  : Text(
                '${index + 1}',
                style: context.bodySmall.copyWith(
                  color: isCurrent ? Colors.white : color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Step label
          Text(
            stepLabels[index],
            style: context.bodySmall.copyWith(
              color: color,
              fontWeight: fontWeight,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Simplified version for minimal UI
class SimpleProgressIndicator extends StatelessWidget {
  final double progress;
  final String? label;
  final Color? color;

  const SimpleProgressIndicator({
    Key? key,
    required this.progress,
    this.label,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.bodySmall.copyWith(
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],

        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: context.dividerColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? context.primary,
          ),
          minHeight: 6,
        ),
      ],
    );
  }
}