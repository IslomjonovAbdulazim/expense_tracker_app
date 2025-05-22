// lib/utils/services/auth_service.dart
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';

import '../../core/network/network_service.dart';
import '../../utils/services/token_service.dart';
import '../../utils/helpers/logger.dart';
import '../../core/error/network_failure.dart';
import '../../data/models/auth_models.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  // Late initialization to avoid circular dependency
  late final NetworkService _networkService;
  late final TokenService _tokenService;

  // Firebase Auth instance (nullable for safety)
  fb.FirebaseAuth? _firebaseAuth;
  bool _firebaseAvailable = false;

  // Google Sign In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Current auth state
  final Rx<AuthState> authState = const AuthState.initial().obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    _initializeFirebase();
    _initializeAuthState();
  }

  void _initializeServices() {
    try {
      // Get services with null safety
      if (Get.isRegistered<NetworkService>()) {
        _networkService = Get.find<NetworkService>();
      } else {
        throw Exception('NetworkService not registered');
      }

      if (Get.isRegistered<TokenService>()) {
        _tokenService = Get.find<TokenService>();
      } else {
        throw Exception('TokenService not registered');
      }

      Logger.success('AuthService dependencies initialized');
    } catch (e) {
      Logger.error('AuthService initialization failed: $e');
      // Set to unauthenticated state if services are missing
      authState.value = const AuthState.unauthenticated();
    }
  }

  void _initializeFirebase() {
    try {
      // Check if Firebase is available and initialized
      if (Firebase.apps.isNotEmpty) {
        _firebaseAuth = fb.FirebaseAuth.instance;
        _firebaseAvailable = true;
        Logger.success('Firebase Auth initialized');
      } else {
        Logger.warning('Firebase not available - social auth disabled');
        _firebaseAvailable = false;
      }
    } catch (e) {
      Logger.error('Firebase Auth initialization failed: $e');
      _firebaseAvailable = false;
    }
  }

  Future<void> _initializeAuthState() async {
    try {
      // Check if user has valid token
      if (_tokenService.hasToken) {
        final result = await _getCurrentUser();
        result.fold(
              (failure) {
            Logger.error('Failed to get current user: ${failure.message}');
            authState.value = const AuthState.unauthenticated();
          },
              (user) {
            currentUser.value = user;
            authState.value = AuthState.authenticated(user);
          },
        );
      } else {
        authState.value = const AuthState.unauthenticated();
      }
    } catch (e) {
      Logger.error('Auth initialization error: $e');
      authState.value = const AuthState.unauthenticated();
    }
  }

  /// Email/Password Authentication
  Future<Either<NetworkFailure, User>> loginWithEmail(LoginRequest request) async {
    try {
      authState.value = const AuthState.loading();

      final result = await _networkService.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      return result.fold(
            (failure) {
          authState.value = AuthState.error(failure.message ?? 'Login failed');
          return Left(failure);
        },
            (data) async {
          final response = AuthResponse.fromJson(data);
          await _tokenService.saveToken(response.accessToken);
          if (response.refreshToken != null) {
            await _tokenService.saveRefreshToken(response.refreshToken!);
          }

          currentUser.value = response.user;
          authState.value = AuthState.authenticated(response.user);

          Logger.success('User logged in successfully');
          return Right(response.user);
        },
      );
    } catch (e) {
      final error = 'Login error: $e';
      Logger.error(error);
      authState.value = AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  Future<Either<NetworkFailure, User>> registerWithEmail(RegisterRequest request) async {
    try {
      authState.value = const AuthState.loading();

      final result = await _networkService.post<Map<String, dynamic>>(
        '/auth/register',
        data: request.toJson(),
      );

      return result.fold(
            (failure) {
          authState.value = AuthState.error(failure.message ?? 'Registration failed');
          return Left(failure);
        },
            (data) async {
          final response = AuthResponse.fromJson(data);
          await _tokenService.saveToken(response.accessToken);
          if (response.refreshToken != null) {
            await _tokenService.saveRefreshToken(response.refreshToken!);
          }

          currentUser.value = response.user;
          authState.value = AuthState.authenticated(response.user);

          Logger.success('User registered successfully');
          return Right(response.user);
        },
      );
    } catch (e) {
      final error = 'Registration error: $e';
      Logger.error(error);
      authState.value = AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Google Sign In
  Future<Either<NetworkFailure, User>> signInWithGoogle() async {
    if (!_firebaseAvailable) {
      const error = 'Firebase not available - cannot use Google Sign In';
      Logger.error(error);
      authState.value = const AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }

    try {
      authState.value = const AuthState.loading();

      // Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        authState.value = const AuthState.unauthenticated();
        return Left(NetworkFailure(
          message: 'Google sign in cancelled',
          statusCode: null,
        ));
      }

      // Get Google Auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final fb.UserCredential userCredential =
      await _firebaseAuth!.signInWithCredential(credential);

      // Get Firebase token
      final firebaseToken = await userCredential.user?.getIdToken();
      if (firebaseToken == null) {
        throw Exception('Failed to get Firebase token');
      }

      // Send to backend
      final socialAuthRequest = SocialAuthRequest(
        token: firebaseToken,
        provider: AuthProvider.google,
        email: googleUser.email,
        name: googleUser.displayName,
        photoUrl: googleUser.photoUrl,
      );

      return await _processSocialAuth(socialAuthRequest);
    } catch (e) {
      final error = 'Google sign in error: $e';
      Logger.error(error);
      authState.value = AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Apple Sign In
  Future<Either<NetworkFailure, User>> signInWithApple() async {
    if (!_firebaseAvailable) {
      const error = 'Firebase not available - cannot use Apple Sign In';
      Logger.error(error);
      authState.value = const AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }

    try {
      authState.value = const AuthState.loading();

      // Check if Apple Sign In is available
      if (!await SignInWithApple.isAvailable()) {
        const error = 'Apple Sign In is not available on this device';
        authState.value = const AuthState.error(error);
        return Left(NetworkFailure(
          message: error,
          statusCode: null,
        ));
      }

      // Trigger Apple Sign In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create Firebase credential
      final oauthCredential = fb.OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Sign in to Firebase
      final fb.UserCredential userCredential =
      await _firebaseAuth!.signInWithCredential(oauthCredential);

      // Get Firebase token
      final firebaseToken = await userCredential.user?.getIdToken();
      if (firebaseToken == null) {
        throw Exception('Failed to get Firebase token');
      }

      // Build name from Apple credential
      String? displayName;
      if (credential.givenName != null || credential.familyName != null) {
        displayName = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
        if (displayName.isEmpty) displayName = null;
      }

      // Send to backend
      final socialAuthRequest = SocialAuthRequest(
        token: firebaseToken,
        provider: AuthProvider.apple,
        email: credential.email,
        name: displayName,
      );

      return await _processSocialAuth(socialAuthRequest);
    } catch (e) {
      final error = 'Apple sign in error: $e';
      Logger.error(error);
      authState.value = AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Process social authentication
  Future<Either<NetworkFailure, User>> _processSocialAuth(SocialAuthRequest request) async {
    final result = await _networkService.post<Map<String, dynamic>>(
      '/auth/social',
      data: request.toJson(),
    );

    return result.fold(
          (failure) {
        authState.value = AuthState.error(failure.message ?? 'Social auth failed');
        return Left(failure);
      },
          (data) async {
        final response = AuthResponse.fromJson(data);
        await _tokenService.saveToken(response.accessToken);
        if (response.refreshToken != null) {
          await _tokenService.saveRefreshToken(response.refreshToken!);
        }

        currentUser.value = response.user;
        authState.value = AuthState.authenticated(response.user);

        Logger.success('Social auth successful');
        return Right(response.user);
      },
    );
  }

  /// Password Reset
  Future<Either<NetworkFailure, bool>> resetPassword(ResetPasswordRequest request) async {
    try {
      final result = await _networkService.post<Map<String, dynamic>>(
        '/auth/reset-password',
        data: request.toJson(),
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          Logger.success('Password reset email sent');
          return const Right(true);
        },
      );
    } catch (e) {
      final error = 'Reset password error: $e';
      Logger.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Change Password
  Future<Either<NetworkFailure, bool>> changePassword(ChangePasswordRequest request) async {
    try {
      final result = await _networkService.post<Map<String, dynamic>>(
        '/auth/change-password',
        data: request.toJson(),
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          Logger.success('Password changed successfully');
          return const Right(true);
        },
      );
    } catch (e) {
      final error = 'Change password error: $e';
      Logger.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Verify Email
  Future<Either<NetworkFailure, bool>> verifyEmail(VerifyEmailRequest request) async {
    try {
      final result = await _networkService.post<Map<String, dynamic>>(
        '/auth/verify-email',
        data: request.toJson(),
      );

      return result.fold(
            (failure) => Left(failure),
            (data) async {
          // Update current user's verification status
          if (currentUser.value != null) {
            currentUser.value = currentUser.value!.copyWith(isEmailVerified: true);
            authState.value = AuthState.authenticated(currentUser.value!);
          }

          Logger.success('Email verified successfully');
          return const Right(true);
        },
      );
    } catch (e) {
      final error = 'Email verification error: $e';
      Logger.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Resend Verification Email
  Future<Either<NetworkFailure, bool>> resendVerificationEmail() async {
    try {
      final result = await _networkService.post<Map<String, dynamic>>(
        '/auth/resend-verification',
        data: {},
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          Logger.success('Verification email sent');
          return const Right(true);
        },
      );
    } catch (e) {
      final error = 'Resend verification error: $e';
      Logger.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Get Current User
  Future<Either<NetworkFailure, User>> _getCurrentUser() async {
    try {
      final result = await _networkService.get<Map<String, dynamic>>(
        '/auth/me',
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          final user = User.fromJson(data);
          return Right(user);
        },
      );
    } catch (e) {
      final error = 'Get current user error: $e';
      Logger.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Refresh Token
  Future<Either<NetworkFailure, bool>> refreshToken() async {
    try {
      final result = await _networkService.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {},
      );

      return result.fold(
            (failure) => Left(failure),
            (data) async {
          final response = AuthResponse.fromJson(data);
          await _tokenService.saveToken(response.accessToken);
          if (response.refreshToken != null) {
            await _tokenService.saveRefreshToken(response.refreshToken!);
          }

          Logger.success('Token refreshed successfully');
          return const Right(true);
        },
      );
    } catch (e) {
      final error = 'Token refresh error: $e';
      Logger.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      authState.value = const AuthState.loading();

      // Call logout endpoint
      await _networkService.post('/auth/logout', data: {});

      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Sign out from Firebase if available
      if (_firebaseAvailable && _firebaseAuth != null) {
        await _firebaseAuth!.signOut();
      }

      // Clear local data
      await _tokenService.clearToken();
      currentUser.value = null;
      authState.value = const AuthState.unauthenticated();

      Logger.success('User logged out successfully');
    } catch (e) {
      Logger.error('Logout error: $e');
      // Even if logout fails, clear local data
      await _tokenService.clearToken();
      currentUser.value = null;
      authState.value = const AuthState.unauthenticated();
    }
  }

  /// Check Authentication Status
  bool get isAuthenticated => authState.value is AuthAuthenticated;
  bool get isLoading => authState.value is AuthLoading;
  bool get hasError => authState.value is AuthError;
  bool get isFirebaseAvailable => _firebaseAvailable;

  String? get errorMessage {
    final state = authState.value;
    return state is AuthError ? state.message : null;
  }

  /// Update User Profile
  Future<Either<NetworkFailure, User>> updateProfile(Map<String, dynamic> data) async {
    try {
      final result = await _networkService.put<Map<String, dynamic>>(
        '/auth/profile',
        data: data,
      );

      return result.fold(
            (failure) => Left(failure),
            (responseData) {
          final updatedUser = User.fromJson(responseData);
          currentUser.value = updatedUser;
          authState.value = AuthState.authenticated(updatedUser);

          Logger.success('Profile updated successfully');
          return Right(updatedUser);
        },
      );
    } catch (e) {
      final error = 'Update profile error: $e';
      Logger.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Delete Account
  Future<Either<NetworkFailure, bool>> deleteAccount() async {
    try {
      final result = await _networkService.delete<Map<String, dynamic>>(
        '/auth/account',
      );

      return result.fold(
            (failure) => Left(failure),
            (data) async {
          await logout(); // Clear all local data
          Logger.success('Account deleted successfully');
          return const Right(true);
        },
      );
    } catch (e) {
      final error = 'Delete account error: $e';
      Logger.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }
}