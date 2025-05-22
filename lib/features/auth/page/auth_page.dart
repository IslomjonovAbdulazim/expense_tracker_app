// lib/features/auth/page/auth_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../routes/app_routes.dart';
import '../../../utils/extenstions/color_extension.dart';
import '../../../utils/extenstions/text_style_extention.dart';
import '../controller/auth_controller.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // Show loading indicator while service is initializing
          if (!controller.isServiceReady.value) {
            return _buildServiceLoadingScreen(context);
          }

          return GestureDetector(
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
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom - 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Logo and branding
                    _buildHeader(context),

                    const SizedBox(height: 48),

                    // Auth form
                    Obx(() => controller.isLoginMode.value
                        ? _buildLoginForm(context)
                        : _buildRegisterForm(context)),

                    const SizedBox(height: 32),

                    // Social auth buttons
                    _buildSocialAuthSection(context),

                    const SizedBox(height: 32),

                    // Toggle auth mode
                    _buildToggleSection(context),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildServiceLoadingScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          CircularProgressIndicator(
            color: context.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Initializing authentication...',
            style: context.bodyMedium.copyWith(
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              // Force refresh or navigate away
              Get.offAllNamed('/home');
            },
            child: Text(
              'Skip for now',
              style: context.bodySmall.copyWith(
                color: context.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: context.primary.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: context.primary.withOpacity(0.5), width: 2),
          ),
          child: Icon(
            Icons.account_balance_wallet,
            size: 40,
            color: context.primary,
          ),
        ),
        const SizedBox(height: 24),
        Obx(() => Text(
          controller.isLoginMode.value ? 'Welcome Back!' : 'Create Account',
          style: context.headingLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )),
        const SizedBox(height: 8),
        Obx(() => Text(
          controller.isLoginMode.value
              ? 'Sign in to continue to your account'
              : 'Join us and start tracking your expenses',
          style: context.bodyMedium.copyWith(
            color: context.textSecondary,
          ),
          textAlign: TextAlign.center,
        )),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: [
          // Email Field
          _buildTextField(
            context: context,
            controller: controller.emailController,
            focusNode: controller.emailFocusNode,
            label: 'Email',
            hint: 'Enter your email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),

          const SizedBox(height: 16),

          // Password Field
          _buildTextField(
            context: context,
            controller: controller.passwordController,
            focusNode: controller.passwordFocusNode,
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: Icons.lock_outlined,
            obscureText: true,
            validator: controller.validatePassword,
          ),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.goToForgotPassword,
              child: Text(
                'Forgot Password?',
                style: context.bodyMedium.copyWith(
                  color: context.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Login button
          Obx(() => _buildPrimaryButton(
            context: context,
            text: controller.primaryButtonText,
            onPressed: controller.isLoading.value ? null : controller.loginWithEmail,
            isLoading: controller.isLoading.value,
          )),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Form(
      key: controller.registerFormKey,
      child: Column(
        children: [
          // Name Field
          _buildTextField(
            context: context,
            controller: controller.nameController,
            focusNode: controller.nameFocusNode,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outlined,
            validator: controller.validateName,
          ),

          const SizedBox(height: 16),

          // Email Field
          _buildTextField(
            context: context,
            controller: controller.emailController,
            focusNode: controller.emailFocusNode,
            label: 'Email',
            hint: 'Enter your email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),

          const SizedBox(height: 16),

          // Phone Field
          _buildTextField(
            context: context,
            controller: controller.phoneController,
            focusNode: controller.phoneFocusNode,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: controller.validatePhone,
          ),

          const SizedBox(height: 16),

          // Password Field
          _buildTextField(
            context: context,
            controller: controller.passwordController,
            focusNode: controller.passwordFocusNode,
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: Icons.lock_outlined,
            obscureText: true,
            validator: controller.validatePassword,
          ),

          const SizedBox(height: 16),

          // Confirm Password Field
          _buildTextField(
            context: context,
            controller: controller.confirmPasswordController,
            focusNode: controller.confirmPasswordFocusNode,
            label: 'Confirm Password',
            hint: 'Confirm your password',
            prefixIcon: Icons.lock_outlined,
            obscureText: true,
            validator: controller.validateConfirmPassword,
          ),

          // Terms and conditions
          Obx(() => CheckboxListTile(
            value: controller.acceptTerms.value,
            onChanged: (value) => controller.acceptTerms.value = value ?? false,
            title: RichText(
              text: TextSpan(
                style: context.bodySmall.copyWith(
                  color: context.textPrimary,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: context.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: context.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: context.primary,
          )),

          const SizedBox(height: 24),

          // Register button
          Obx(() => _buildPrimaryButton(
            context: context,
            text: controller.primaryButtonText,
            onPressed: controller.isLoading.value ? null : controller.registerWithEmail,
            isLoading: controller.isLoading.value,
          )),
        ],
      ),
    );
  }

  Widget _buildSocialAuthSection(BuildContext context) {
    return Obx(() {
      // Disable social auth if service is not ready
      final isDisabled = !controller.isServiceReady.value || controller.isLoading.value;

      return Column(
        children: [
          // Divider with "OR" text
          Row(
            children: [
              Expanded(child: Divider(color: context.dividerColor)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: context.bodySmall.copyWith(
                    color: context.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: context.dividerColor)),
            ],
          ),

          const SizedBox(height: 24),

          // Social auth buttons
          Column(
            children: [
              // Google Sign In
              _buildSocialButton(
                context: context,
                text: '${controller.socialButtonPrefix} with Google',
                icon: _buildGoogleIcon(),
                onPressed: isDisabled ? null : controller.signInWithGoogle,
              ),

              const SizedBox(height: 12),

              // Apple Sign In (iOS only)
              if (Platform.isIOS)
                _buildSocialButton(
                  context: context,
                  text: '${controller.socialButtonPrefix} with Apple',
                  icon: Icon(
                    Icons.apple,
                    color: context.textPrimary,
                  ),
                  onPressed: isDisabled ? null : controller.signInWithApple,
                  isPrimary: false,
                ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildToggleSection(BuildContext context) {
    return Column(
      children: [
        Obx(() => TextButton(
          onPressed: controller.toggleAuthMode,
          child: Text(
            controller.toggleModeText,
            style: context.bodyMedium.copyWith(
              color: context.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        )),

        const SizedBox(height: 16),

        // Additional links for login mode
        Obx(() {
          if (controller.isLoginMode.value) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: controller.goToTermsAndConditions,
                  child: Text(
                    'Terms',
                    style: context.bodySmall.copyWith(
                      color: context.textSecondary,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 12,
                  color: context.dividerColor,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                TextButton(
                  onPressed: controller.goToPrivacyPolicy,
                  child: Text(
                    'Privacy',
                    style: context.bodySmall.copyWith(
                      color: context.textSecondary,
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: context.textSecondary),
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
        filled: true,
        fillColor: context.cardColor,
      ),
      style: context.bodyLarge,
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          text,
          style: context.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String text,
    required Widget icon,
    required VoidCallback? onPressed,
    bool isPrimary = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: isPrimary ? context.primary : context.textPrimary,
          side: BorderSide(color: context.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    // Create a simple Google icon
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}