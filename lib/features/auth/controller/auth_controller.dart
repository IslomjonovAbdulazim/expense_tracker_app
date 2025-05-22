// lib/features/auth/controller/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/helpers/logger.dart';
import '../../../data/models/auth_models.dart';
import '../../../utils/services/auth_service.dart';

class AuthController extends GetxController {
  late final AuthService _authService;

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final resetEmailController = TextEditingController();

  // Focus nodes
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  // Observable states
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoginMode = true.obs;
  final acceptTerms = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAuthService();
  }

  void _initializeAuthService() {
    try {
      if (Get.isRegistered<AuthService>()) {
        _authService = Get.find<AuthService>();
        // Listen to auth state changes
        ever(_authService.authState, _handleAuthStateChange);
        Logger.success('AuthController initialized with AuthService');
      } else {
        Logger.error('AuthService not registered - auth will not work');
      }
    } catch (e) {
      Logger.error('Failed to initialize AuthController: $e');
    }
  }

  // Getters for auth service state (with null safety)
  AuthState get authState {
    try {
      return _authService.authState.value;
    } catch (e) {
      return const AuthState.unauthenticated();
    }
  }

  User? get currentUser {
    try {
      return _authService.currentUser.value;
    } catch (e) {
      return null;
    }
  }

  bool get isAuthenticated {
    try {
      return _authService.isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    resetEmailController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();

    super.onClose();
  }

  void _handleAuthStateChange(AuthState state) {
    state.when(
      initial: () => isLoading.value = false,
      loading: () => isLoading.value = true,
      authenticated: (user) {
        isLoading.value = false;
        _onAuthenticationSuccess();
      },
      unauthenticated: () => isLoading.value = false,
      error: (message) {
        isLoading.value = false;
        _showErrorSnackbar(message);
      },
    );
  }

  void _onAuthenticationSuccess() {
    // Clear form data
    _clearForms();

    // Navigate based on user state
    if (currentUser?.isEmailVerified == false) {
      Get.offAllNamed(AppRoutes.emailVerification);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }

    Get.snackbar(
      'Success',
      'Welcome ${currentUser?.name ?? 'back'}!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      colorText: Get.theme.colorScheme.primary,
      duration: const Duration(seconds: 2),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
      colorText: Get.theme.colorScheme.error,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      colorText: Get.theme.colorScheme.primary,
      duration: const Duration(seconds: 2),
    );
  }

  void _clearForms() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    phoneController.clear();
    resetEmailController.clear();
    acceptTerms.value = false;
  }

  /// Toggle between login and register modes
  void toggleAuthMode() {
    isLoginMode.value = !isLoginMode.value;
    _clearForms();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  /// Email/Password Login
  Future<void> loginWithEmail() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final result = await _authService.loginWithEmail(request);
      result.fold(
            (failure) => Logger.error('Login failed: ${failure.message}'),
            (user) => Logger.success('Login successful'),
      );
    } catch (e) {
      Logger.error('Login error: $e');
      _showErrorSnackbar('Login failed. Please try again.');
    }
  }

  /// Email/Password Registration
  Future<void> registerWithEmail() async {
    if (!registerFormKey.currentState!.validate()) return;

    if (!acceptTerms.value) {
      _showErrorSnackbar('Please accept the terms and conditions');
      return;
    }

    try {
      final request = RegisterRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        phoneNumber: phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : null,
      );

      final result = await _authService.registerWithEmail(request);
      result.fold(
            (failure) => Logger.error('Registration failed: ${failure.message}'),
            (user) => Logger.success('Registration successful'),
      );
    } catch (e) {
      Logger.error('Registration error: $e');
      _showErrorSnackbar('Registration failed. Please try again.');
    }
  }

  /// Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      final result = await _authService.signInWithGoogle();
      result.fold(
            (failure) => Logger.error('Google sign in failed: ${failure.message}'),
            (user) => Logger.success('Google sign in successful'),
      );
    } catch (e) {
      Logger.error('Google sign in error: $e');
      _showErrorSnackbar('Google sign in failed. Please try again.');
    }
  }

  /// Apple Sign In
  Future<void> signInWithApple() async {
    try {
      final result = await _authService.signInWithApple();
      result.fold(
            (failure) => Logger.error('Apple sign in failed: ${failure.message}'),
            (user) => Logger.success('Apple sign in successful'),
      );
    } catch (e) {
      Logger.error('Apple sign in error: $e');
      _showErrorSnackbar('Apple sign in failed. Please try again.');
    }
  }

  /// Reset Password
  Future<void> resetPassword() async {
    if (!resetPasswordFormKey.currentState!.validate()) return;

    try {
      final request = ResetPasswordRequest(
        email: resetEmailController.text.trim(),
      );

      final result = await _authService.resetPassword(request);
      result.fold(
            (failure) => _showErrorSnackbar(failure.message ?? 'Reset failed'),
            (success) {
          _showSuccessSnackbar('Reset instructions sent to your email');
          Get.back(); // Close reset password dialog/page
        },
      );
    } catch (e) {
      Logger.error('Reset password error: $e');
      _showErrorSnackbar('Reset failed. Please try again.');
    }
  }

  /// Resend Verification Email
  Future<void> resendVerificationEmail() async {
    try {
      final result = await _authService.resendVerificationEmail();
      result.fold(
            (failure) => _showErrorSnackbar(failure.message ?? 'Failed to resend email'),
            (success) => _showSuccessSnackbar('Verification email sent'),
      );
    } catch (e) {
      Logger.error('Resend verification error: $e');
      _showErrorSnackbar('Failed to resend email. Please try again.');
    }
  }

  /// Verify Email with Token
  Future<void> verifyEmail(String token) async {
    try {
      final request = VerifyEmailRequest(token: token);

      final result = await _authService.verifyEmail(request);
      result.fold(
            (failure) => _showErrorSnackbar(failure.message ?? 'Verification failed'),
            (success) {
          _showSuccessSnackbar('Email verified successfully!');
          Get.offAllNamed(AppRoutes.home);
        },
      );
    } catch (e) {
      Logger.error('Email verification error: $e');
      _showErrorSnackbar('Verification failed. Please try again.');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authService.logout();
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      Logger.error('Logout error: $e');
      _showErrorSnackbar('Logout failed. Please try again.');
    }
  }

  /// Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (isLoginMode.value) {
      return null; // For login, just check if not empty
    }

    // For registration, apply stricter validation
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  String? validatePhone(String? value) {
    // Phone is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    // Remove country code and validate
    final cleanedPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedPhone.length != 9) {
      return 'Phone number must be 9 digits';
    }

    return null;
  }

  /// Navigation helpers
  void goToRegister() {
    isLoginMode.value = false;
  }

  void goToLogin() {
    isLoginMode.value = true;
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void goToTermsAndConditions() {
    // Navigate to terms and conditions page
    Get.toNamed('/terms-and-conditions');
  }

  void goToPrivacyPolicy() {
    // Navigate to privacy policy page
    Get.toNamed('/privacy-policy');
  }

  /// Get appropriate button text
  String get primaryButtonText {
    if (isLoading.value) {
      return isLoginMode.value ? 'Signing In...' : 'Creating Account...';
    }
    return isLoginMode.value ? 'Sign In' : 'Create Account';
  }

  String get toggleModeText {
    return isLoginMode.value
        ? "Don't have an account? Sign Up"
        : "Already have an account? Sign In";
  }

  String get socialButtonPrefix {
    return isLoginMode.value ? 'Sign in' : 'Sign up';
  }
}