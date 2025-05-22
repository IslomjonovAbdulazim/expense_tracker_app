// lib/features/auth/page/email_verification_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/extenstions/color_extension.dart';
import '../../../utils/extenstions/text_style_extention.dart';
import '../controller/auth_controller.dart';

class EmailVerificationPage extends GetView<AuthController> {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          // Dismiss keyboard when tapping outside inputs
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            // Make everything scrollable when keyboard appears
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

                  const SizedBox(height: 32),

                  // Logout option
                  _buildLogoutButton(context),

                  const SizedBox(height: 20),
                ],
              ),
            ),
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
    final email = controller.currentUser?.email ?? 'your email';

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
          email,
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
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: controller.isLoading.value ? null : controller.resendVerificationEmail,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.isLoading.value
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.primary,
          ),
        )
            : Text(
          'Resend Verification Email',
          style: context.bodyLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ));
  }

  Widget _buildOpenEmailButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          // This would normally use url_launcher to open email app
          // Since we don't have that dependency, just show a snackbar
          Get.snackbar(
            'Open Email',
            'This would open your email app in a real implementation',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        icon: const Icon(Icons.email_outlined),
        label: const Text('Open Email App'),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton.icon(
      onPressed: controller.logout,
      icon: Icon(
        Icons.logout,
        size: 16,
        color: context.textSecondary,
      ),
      label: Text(
        'Sign Out',
        style: context.bodyMedium.copyWith(
          color: context.textSecondary,
        ),
      ),
    );
  }
}