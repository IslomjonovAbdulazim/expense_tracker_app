// lib/features/auth/page/auth_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

import '../../../shared/widgets/textfield_components.dart';
import '../../../shared/widgets/platform_buttons.dart';
import '../../../shared/adaptive_logo.dart';
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

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
          const AdaptiveLogo(
            width: 80,
            height: 80,
          ),
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
        const AdaptiveLogo(
          width: 80,
          height: 80,
          showText: true,
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
          FormFieldWrapper(
            child: EmailTextField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              validator: controller.validateEmail,
              onChanged: (value) {},
            ),
          ),

          FormFieldWrapper(
            child: PasswordTextField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              validator: controller.validatePassword,
              onChanged: (value) {},
              textInputAction: TextInputAction.done,
            ),
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
          Obx(() => PlatformButton.primary(
            text: controller.primaryButtonText,
            onPressed: controller.isLoading.value ? null : controller.loginWithEmail,
            isLoading: controller.isLoading.value,
            expanded: true,
            height: 56,
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
          FormFieldWrapper(
            child: NameTextField(
              controller: controller.nameController,
              focusNode: controller.nameFocusNode,
              validator: controller.validateName,
              onChanged: (value) {},
            ),
          ),

          FormFieldWrapper(
            child: EmailTextField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              validator: controller.validateEmail,
              onChanged: (value) {},
            ),
          ),

          FormFieldWrapper(
            child: PhoneTextField(
              controller: controller.phoneController,
              focusNode: controller.phoneFocusNode,
              validator: controller.validatePhone,
              onChanged: (value) {},
            ),
          ),

          FormFieldWrapper(
            child: PasswordTextField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              validator: controller.validatePassword,
              onChanged: (value) {},
              isNewPassword: true,
              textInputAction: TextInputAction.next,
            ),
          ),

          FormFieldWrapper(
            child: PasswordTextField(
              label: 'Confirm Password',
              hint: 'Confirm your password',
              controller: controller.confirmPasswordController,
              focusNode: controller.confirmPasswordFocusNode,
              validator: controller.validateConfirmPassword,
              onChanged: (value) {},
              textInputAction: TextInputAction.done,
            ),
          ),

          // Terms and conditions
          Obx(() => CheckboxListTile(
            value: controller.acceptTerms.value,
            onChanged: (value) => controller.acceptTerms.value = value ?? false,
            title: RichText(
              text: TextSpan(
                style: context.bodySmall,
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
          Obx(() => PlatformButton.primary(
            text: controller.primaryButtonText,
            onPressed: controller.isLoading.value ? null : controller.registerWithEmail,
            isLoading: controller.isLoading.value,
            expanded: true,
            height: 56,
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
              PlatformButton.secondary(
                text: '${controller.socialButtonPrefix} with Google',
                icon: _buildGoogleIcon(),
                onPressed: isDisabled ? null : controller.signInWithGoogle,
                expanded: true,
                height: 56,
              ),

              const SizedBox(height: 12),

              // Apple Sign In (iOS only)
              if (Platform.isIOS)
                _buildAppleSignInButton(context, isDisabled),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildAppleSignInButton(BuildContext context, bool isDisabled) {
    if (isDisabled) {
      // Show disabled Apple button
      return Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Center(
          child: Text(
            '${controller.socialButtonPrefix} with Apple',
            style: context.bodyMedium.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 56,
      child: SignInWithAppleButton(
        onPressed: controller.signInWithApple,
        style: Get.isDarkMode
            ? SignInWithAppleButtonStyle.white
            : SignInWithAppleButtonStyle.black,
        borderRadius: BorderRadius.circular(12),
        text: controller.isLoginMode.value ? 'Sign in with Apple' : 'Sign up with Apple',
      ),
    );
  }

  Widget _buildGoogleIcon() {
    // Create a simple Google icon using Container
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
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
      child: Center(
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
}