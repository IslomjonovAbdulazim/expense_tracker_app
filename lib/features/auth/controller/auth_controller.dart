// lib/features/auth/controller/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/helpers/logger.dart';
import '../../../data/models/auth_models.dart';
import '../../../utils/services/auth_service.dart';

class AuthController extends GetxController {
  late AuthService _authService;

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();

  // Text controllers (removed phoneController)
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final resetEmailController = TextEditingController();

  // Focus nodes (removed phoneFocusNode)
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();

  // Observable states
  final isLoading = false.obs;
  final isLoginMode = true.obs;
  final acceptTerms = false.obs;
  final isServiceReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAuthService();
  }

  Future<void> _initializeAuthService() async {
    try {
      Logger.log('AuthController: Initializing auth service...');

      // Handle case where AuthService might not be registered yet
      if (Get.isRegistered<AuthService>()) {
        _authService = Get.find<AuthService>();
        isServiceReady.value = true;
        Logger.success('AuthController initialized with existing AuthService');
      } else {
        // If not registered, try to wait for it
        _waitForAuthService();
      }
    } catch (e) {
      Logger.error('Failed to initialize AuthController: $e');
      _showErrorSnackbar('Failed to initialize authentication. Please restart the app.');
    }
  }

  Future<void> _waitForAuthService() async {
    // Wait for AuthService to be registered
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (Get.isRegistered<AuthService>()) {
        _authService = Get.find<AuthService>();
        isServiceReady.value = true;
        Logger.success('AuthController initialized with AuthService after waiting');
        return;
      }

      attempts++;
      Logger.log('AuthController: Waiting for AuthService... (${attempts}/${maxAttempts})');
    }

    // If still not available, create a temporary version to avoid null errors
    _createTemporaryAuthService();
  }

  void _createTemporaryAuthService() {
    try {
      // Create a temporary AuthService to avoid null errors
      if (!Get.isRegistered<AuthService>()) {
        final tempService = AuthService();
        Get.put(tempService, permanent: true);
        _authService = tempService;
      } else {
        _authService = Get.find<AuthService>();
      }

      isServiceReady.value = true;
      Logger.warning('AuthController created with temporary AuthService');
    } catch (e) {
      Logger.error('Failed to create temporary AuthService: $e');
    }
  }

  // Safely get current user
  User? get currentUser {
    try {
      return isServiceReady.value ? _authService.currentUser.value : null;
    } catch (e) {
      return null;
    }
  }

  bool get isAuthenticated {
    try {
      return isServiceReady.value && _authService.isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes (removed phone-related ones)
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    resetEmailController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    nameFocusNode.dispose();

    super.onClose();
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
    resetEmailController.clear();
    acceptTerms.value = false;
  }

  // Check service before trying operations
  bool _checkServiceReady() {
    if (!isServiceReady.value) {
      _showErrorSnackbar('Authentication service is not ready. Please wait and try again.');
      return false;
    }
    return true;
  }

  // Auth operations
  void toggleAuthMode() {
    isLoginMode.value = !isLoginMode.value;
    _clearForms();
  }

  // Login with email/password
  Future<void> loginWithEmail() async {
    if (!_checkServiceReady()) return;
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // Simulating network delay for demo purposes
      await Future.delayed(const Duration(seconds: 2));

      // Create login request
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Check if AuthService is properly initialized
      if (Get.isRegistered<AuthService>()) {
        final result = await _authService.loginWithEmail(request);

        result.fold(
              (failure) {
            _showErrorSnackbar(failure.message ?? 'Login failed. Please try again.');
          },
              (user) {
            _showSuccessSnackbar('Login successful');
            _onAuthSuccess(user);
          },
        );
      } else {
        // Fallback for demo or testing
        _showSuccessSnackbar('Login successful (demo mode)');
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Logger.error('Login error: $e');
      _showErrorSnackbar('Login failed. Please check your connection and try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Register with email/password (removed phone number)
  Future<void> registerWithEmail() async {
    if (!_checkServiceReady()) return;
    if (!registerFormKey.currentState!.validate()) return;

    if (!acceptTerms.value) {
      _showErrorSnackbar('Please accept the terms and conditions');
      return;
    }

    try {
      isLoading.value = true;

      // Simulating network delay for demo purposes
      await Future.delayed(const Duration(seconds: 2));

      // Create register request without phone number
      final request = RegisterRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        // phoneNumber: null, // Removed phone number completely
      );

      // Check if AuthService is properly initialized
      if (Get.isRegistered<AuthService>()) {
        final result = await _authService.registerWithEmail(request);

        result.fold(
              (failure) {
            _showErrorSnackbar(failure.message ?? 'Registration failed. Please try again.');
          },
              (user) {
            _showSuccessSnackbar('Registration successful');
            _onAuthSuccess(user);
          },
        );
      } else {
        // Fallback for demo or testing
        _showSuccessSnackbar('Registration successful (demo mode)');
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Logger.error('Registration error: $e');
      _showErrorSnackbar('Registration failed. Please check your connection and try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Process successful authentication
  void _onAuthSuccess(User user) {
    _clearForms();

    // Navigate based on email verification status
    if (user.isEmailVerified) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.emailVerification);
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    if (!_checkServiceReady()) return;

    try {
      isLoading.value = true;

      // Simulating network delay for demo purposes
      await Future.delayed(const Duration(seconds: 2));

      if (Get.isRegistered<AuthService>()) {
        final result = await _authService.signInWithGoogle();

        result.fold(
              (failure) {
            _showErrorSnackbar(failure.message ?? 'Google sign in failed. Please try again.');
          },
              (user) {
            _showSuccessSnackbar('Google sign in successful');
            _onAuthSuccess(user);
          },
        );
      } else {
        // Fallback for demo or testing
        _showSuccessSnackbar('Google sign in successful (demo mode)');
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Logger.error('Google sign in error: $e');
      _showErrorSnackbar('Google sign in failed. Please check your connection and try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Apple Sign In
  Future<void> signInWithApple() async {
    if (!_checkServiceReady()) return;

    try {
      isLoading.value = true;

      // Simulating network delay for demo purposes
      await Future.delayed(const Duration(seconds: 2));

      if (Get.isRegistered<AuthService>()) {
        final result = await _authService.signInWithApple();

        result.fold(
              (failure) {
            _showErrorSnackbar(failure.message ?? 'Apple sign in failed. Please try again.');
          },
              (user) {
            _showSuccessSnackbar('Apple sign in successful');
            _onAuthSuccess(user);
          },
        );
      } else {
        // Fallback for demo or testing
        _showSuccessSnackbar('Apple sign in successful (demo mode)');
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Logger.error('Apple sign in error: $e');
      _showErrorSnackbar('Apple sign in failed. Please check your connection and try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password
  Future<void> resetPassword() async {
    if (!_checkServiceReady()) return;
    if (!resetPasswordFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // Simulating network delay for demo purposes
      await Future.delayed(const Duration(seconds: 2));

      final request = ResetPasswordRequest(
        email: resetEmailController.text.trim(),
      );

      if (Get.isRegistered<AuthService>()) {
        final result = await _authService.resetPassword(request);

        result.fold(
              (failure) {
            _showErrorSnackbar(failure.message ?? 'Reset failed. Please try again.');
          },
              (success) {
            _showSuccessSnackbar('Reset instructions sent to your email');
            Get.back(); // Close reset password dialog/page
          },
        );
      } else {
        // Fallback for demo or testing
        _showSuccessSnackbar('Reset instructions sent to your email (demo mode)');
        Get.back(); // Close reset password dialog/page
      }
    } catch (e) {
      Logger.error('Reset password error: $e');
      _showErrorSnackbar('Reset failed. Please check your connection and try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Validation methods
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

  // Removed validatePhone method since phone is no longer used

  // Navigation helpers
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
    // Navigate to terms and conditions page or show a dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
              'These are the terms and conditions for using this application. '
                  'By using this app, you agree to abide by these terms. '
                  'This is a placeholder text and should be replaced with actual terms.'
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void goToPrivacyPolicy() {
    // Navigate to privacy policy page or show a dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
              'This privacy policy explains how we collect, use, and protect your data. '
                  'We respect your privacy and are committed to protecting your personal information. '
                  'This is a placeholder text and should be replaced with actual privacy policy.'
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Logout functionality
  Future<void> logout() async {
    try {
      if (!isServiceReady.value) return;

      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Simulate delay

      if (Get.isRegistered<AuthService>()) {
        await _authService.logout();
      }

      _showSuccessSnackbar('Logged out successfully');
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      Logger.error('Logout error: $e');
      _showErrorSnackbar('Logout failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    if (!_checkServiceReady()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2)); // Simulate delay

      if (Get.isRegistered<AuthService>()) {
        final result = await _authService.resendVerificationEmail();

        result.fold(
              (failure) {
            _showErrorSnackbar(failure.message ?? 'Failed to resend email');
          },
              (success) {
            _showSuccessSnackbar('Verification email sent');
          },
        );
      } else {
        // Fallback for demo
        _showSuccessSnackbar('Verification email sent (demo mode)');
      }
    } catch (e) {
      Logger.error('Resend verification error: $e');
      _showErrorSnackbar('Failed to resend email. Please try again later.');
    } finally {
      isLoading.value = false;
    }
  }

  // Dynamic text getters
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