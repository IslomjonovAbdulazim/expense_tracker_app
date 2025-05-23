// lib/features/auth/page/forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/extenstions/color_extension.dart';
import '../../../utils/extenstions/text_style_extention.dart';
import '../controller/auth_controller.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          // Dismiss keyboard when tapping outside inputs
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            // Make the whole content scrollable when keyboard appears
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              // Ensure minimum height even when scrolling
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom - 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Illustration
                  _buildIllustration(context),

                  const SizedBox(height: 32),

                  // Title and description
                  _buildHeader(context),

                  const SizedBox(height: 32),

                  // Email form
                  _buildEmailForm(context),

                  const SizedBox(height: 24),

                  // Reset button
                  _buildResetButton(context),

                  const SizedBox(height: 32),

                  // Back to login
                  _buildBackToLogin(context),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primary.withOpacity(0.1),
            context.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.lock_reset,
          size: 60,
          color: context.primary,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Forgot Password?',
          style: context.headingLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Don\'t worry! Enter your email address and we\'ll send you instructions to reset your password.',
          style: context.bodyMedium.copyWith(
            color: context.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return Form(
      key: controller.resetPasswordFormKey,
      child: TextFormField(
        controller: controller.resetEmailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email Address',
          hintText: 'Enter your registered email',
          prefixIcon: Icon(Icons.email_outlined, color: context.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
          filled: true,
          fillColor: context.cardColor,
        ),
        validator: controller.validateEmail,
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: controller.isLoading.value
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          'Send Reset Link',
          style: context.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }

  Widget _buildBackToLogin(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Get.back(),
      icon: Icon(
        Icons.arrow_back,
        size: 16,
        color: context.primary,
      ),
      label: Text(
        'Back to Sign In',
        style: context.bodyMedium.copyWith(
          color: context.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}