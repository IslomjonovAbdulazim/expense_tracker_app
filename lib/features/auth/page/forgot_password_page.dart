// lib/features/auth/page/forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/textfield_components.dart';
import '../../../shared/widgets/platform_buttons.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
              ),

              // Back to login
              _buildBackToLogin(context),
            ],
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
      child: EmailTextField(
        controller: controller.resetEmailController,
        label: 'Email Address',
        hint: 'Enter your registered email',
        validator: controller.validateEmail,
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return Obx(() => PlatformButton.primary(
      text: controller.isLoading.value ? 'Sending...' : 'Send Reset Link',
      onPressed: controller.isLoading.value ? null : controller.resetPassword,
      isLoading: controller.isLoading.value,
      expanded: true,
      height: 56,
    ));
  }

  Widget _buildBackToLogin(BuildContext context) {
    return TextButton(
      onPressed: () => Get.back(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back,
            size: 16,
            color: context.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Back to Sign In',
            style: context.bodyMedium.copyWith(
              color: context.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// lib/features/auth/page/email_verification_page.dart
class EmailVerificationPage extends GetView<AuthController> {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Email illustration
                    _buildEmailIllustration(context),

                    const SizedBox(height: 32),

                    // Title and description
                    _buildHeader(context),

                    const SizedBox(height: 32),

                    // Resend button
                    _buildResendButton(context),

                    const SizedBox(height: 16),

                    // Check email app button
                    _buildOpenEmailButton(context),
                  ],
                ),
              ),

              // Logout option
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailIllustration(BuildContext context) {
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
          Icons.mark_email_read_outlined,
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
          'Verify Your Email',
          style: context.headingLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'We\'ve sent a verification link to',
          style: context.bodyMedium.copyWith(
            color: context.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          controller.currentUser?.email ?? '',
          style: context.bodyLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Please check your email and click the verification link to complete your account setup.',
          style: context.bodyMedium.copyWith(
            color: context.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResendButton(BuildContext context) {
    return Obx(() => PlatformButton.secondary(
      text: controller.isLoading.value ? 'Sending...' : 'Resend Verification Email',
      onPressed: controller.isLoading.value ? null : controller.resendVerificationEmail,
      isLoading: controller.isLoading.value,
      expanded: true,
      height: 48,
    ));
  }

  Widget _buildOpenEmailButton(BuildContext context) {
    return PlatformButton.primary(
      text: 'Open Email App',
      icon: const Icon(Icons.email_outlined),
      onPressed: () {
        // Open default email app
        // You can use url_launcher package for this
        // launch('mailto:');
      },
      expanded: true,
      height: 48,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton(
      onPressed: controller.logout,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout,
            size: 16,
            color: context.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            'Sign Out',
            style: context.bodyMedium.copyWith(
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}