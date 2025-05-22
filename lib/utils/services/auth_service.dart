// lib/utils/services/auth_service.dart
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import '../../core/network/network_service.dart';
import '../../utils/services/token_service.dart';
import '../../utils/helpers/logger.dart';
import '../../core/error/network_failure.dart';
import '../../data/models/auth_models.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  // Dependencies - marked as nullable for safety
  NetworkService? _networkService;
  TokenService? _tokenService;

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

  // Initialization status
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    try {
      Logger.log('AuthService: Starting initialization...');

      await _initializeServices();
      await _initializeFirebase();
      await _initializeAuthState();

      _isInitialized = true;
      Logger.success('AuthService: Initialization completed');
    } catch (e) {
      Logger.error('AuthService initialization failed: $e');
      authState.value = const AuthState.unauthenticated();
    }
  }

  Future<void> _initializeServices() async {
    try {
      // Wait for services to be registered with timeout
      int retries = 0;
      const maxRetries = 10;
      const retryDelay = Duration(milliseconds: 500);

      while (retries < maxRetries) {
        if (Get.isRegistered<NetworkService>() && Get.isRegistered<TokenService>()) {
          _networkService = Get.find<NetworkService>();
          _tokenService = Get.find<TokenService>();
          Logger.success('AuthService: Dependencies found');
          return;
        }

        retries++;
        Logger.log('AuthService: Waiting for dependencies... (${retries}/${maxRetries})');
        await Future.delayed(retryDelay);
      }

      throw Exception('Required services not available after ${maxRetries} retries');
    } catch (e) {
      Logger.error('AuthService: Service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _initializeFirebase() async {
    try {
      // Check if Firebase is available and initialized
      if (Firebase.apps.isNotEmpty) {
        _firebaseAuth = fb.FirebaseAuth.instance;
        _firebaseAvailable = true;
        Logger.success('Firebase Auth initialized');

        // Listen to Firebase auth state changes
        _firebaseAuth!.authStateChanges().listen((fb.User? user) {
          Logger.log('Firebase auth state changed: ${user?.uid}');
        });
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
      if (_tokenService?.hasToken == true) {
        Logger.log('AuthService: Found existing token, checking validity...');

        final result = await _getCurrentUser();
        result.fold(
              (failure) {
            Logger.error('Failed to get current user: ${failure.message}');
            // Token might be expired, clear it
            _tokenService?.clearToken();
            authState.value = const AuthState.unauthenticated();
          },
              (user) {
            Logger.success('AuthService: User authenticated from stored token');
            currentUser.value = user;
            authState.value = AuthState.authenticated(user);
          },
        );
      } else {
        Logger.log('AuthService: No existing token found');
        authState.value = const AuthState.unauthenticated();
      }
    } catch (e) {
      Logger.error('Auth state initialization error: $e');
      authState.value = const AuthState.unauthenticated();
    }
  }

  // Ensure services are available before making API calls
  bool _ensureServicesAvailable() {
    if (_networkService == null || _tokenService == null) {
      Logger.error('AuthService: Required services not available');
      authState.value = const AuthState.error('Authentication services not available');
      return false;
    }
    return true;
  }

  /// Email/Password Authentication
  Future<Either<NetworkFailure, User>> loginWithEmail(LoginRequest request) async {
    try {
      if (!_ensureServicesAvailable()) {
        return Left(NetworkFailure(
          message: 'Authentication services not available',
          statusCode: null,
        ));
      }

      authState.value = const AuthState.loading();

      final result = await _networkService!.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      return result.fold(
            (failure) {
          authState.value = AuthState.error(failure.message ?? 'Login failed');
          return Left(failure);
        },
            (data) async {
          try {
            final response = AuthResponse.fromJson(data);
            await _tokenService!.saveToken(response.accessToken);
            if (response.refreshToken != null) {
              await _tokenService!.saveRefreshToken(response.refreshToken!);
            }

            currentUser.value = response.user;
            authState.value = AuthState.authenticated(response.user);

            Logger.success('User logged in successfully');
            return Right(response.user);
          } catch (e) {
            Logger.error('Login response parsing failed: $e');
            authState.value = AuthState.error('Login response invalid');
            return Left(NetworkFailure(
              message: 'Invalid login response',
              statusCode: null,
            ));
          }
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
      if (!_ensureServicesAvailable()) {
        return Left(NetworkFailure(
          message: 'Authentication services not available',
          statusCode: null,
        ));
      }

      authState.value = const AuthState.loading();

      final result = await _networkService!.post<Map<String, dynamic>>(
        '/auth/register',
        data: request.toJson(),
      );

      return result.fold(
            (failure) {
          authState.value = AuthState.error(failure.message ?? 'Registration failed');
          return Left(failure);
        },
            (data) async {
          try {
            final response = AuthResponse.fromJson(data);
            await _tokenService!.saveToken(response.accessToken);
            if (response.refreshToken != null) {
              await _tokenService!.saveRefreshToken(response.refreshToken!);
            }

            currentUser.value = response.user;
            authState.value = AuthState.authenticated(response.user);

            Logger.success('User registered successfully');
            return Right(response.user);
          } catch (e) {
            Logger.error('Registration response parsing failed: $e');
            authState.value = AuthState.error('Registration response invalid');
            return Left(NetworkFailure(
              message: 'Invalid registration response',
              statusCode: null,
            ));
          }
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
      const error = 'Google Sign In is not available';
      Logger.error(error);
      authState.value = const AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }

    if (!_ensureServicesAvailable()) {
      return Left(NetworkFailure(
        message: 'Authentication services not available',
        statusCode: null,
      ));
    }

    try {
      authState.value = const AuthState.loading();

      // Sign out first to ensure clean state
      await _googleSignIn.signOut();

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

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

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

      // Clean up on error
      try {
        await _googleSignIn.signOut();
        if (_firebaseAvailable) {
          await _firebaseAuth?.signOut();
        }
      } catch (cleanupError) {
        Logger.error('Error during Google sign in cleanup: $cleanupError');
      }

      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Apple Sign In
  Future<Either<NetworkFailure, User>> signInWithApple() async {
    // Check platform support
    if (!Platform.isIOS) {
      const error = 'Apple Sign In is only available on iOS';
      Logger.error(error);
      authState.value = const AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }

    if (!_firebaseAvailable) {
      const error = 'Apple Sign In requires Firebase';
      Logger.error(error);
      authState.value = const AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }

    if (!_ensureServicesAvailable()) {
      return Left(NetworkFailure(
        message: 'Authentication services not available',
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

      if (credential.identityToken == null) {
        throw Exception('Failed to get Apple identity token');
      }

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
    try {
      final result = await _networkService!.post<Map<String, dynamic>>(
        '/auth/social',
        data: request.toJson(),
      );

      return result.fold(
            (failure) {
          authState.value = AuthState.error(failure.message ?? 'Social auth failed');
          return Left(failure);
        },
            (data) async {
          try {
            final response = AuthResponse.fromJson(data);
            await _tokenService!.saveToken(response.accessToken);
            if (response.refreshToken != null) {
              await _tokenService!.saveRefreshToken(response.refreshToken!);
            }

            currentUser.value = response.user;
            authState.value = AuthState.authenticated(response.user);

            Logger.success('Social auth successful');
            return Right(response.user);
          } catch (e) {
            Logger.error('Social auth response parsing failed: $e');
            authState.value = AuthState.error('Social auth response invalid');
            return Left(NetworkFailure(
              message: 'Invalid social auth response',
              statusCode: null,
            ));
          }
        },
      );
    } catch (e) {
      final error = 'Social auth processing error: $e';
      Logger.error(error);
      authState.value = AuthState.error(error);
      return Left(NetworkFailure(
        message: error,
        statusCode: null,
      ));
    }
  }

  /// Password Reset
  Future<Either<NetworkFailure, bool>> resetPassword(ResetPasswordRequest request) async {
    try {
      if (!_ensureServicesAvailable()) {
        return Left(NetworkFailure(
          message: 'Authentication services not available',
          statusCode: null,
        ));
      }

      final result = await _networkService!.post<Map<String, dynamic>>(
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

  /// Verify Email
  Future<Either<NetworkFailure, bool>> verifyEmail(VerifyEmailRequest request) async {
    try {
      if (!_ensureServicesAvailable()) {
        return Left(NetworkFailure(
          message: 'Authentication services not available',
          statusCode: null,
        ));
      }

      final result = await _networkService!.post<Map<String, dynamic>>(
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
      if (!_ensureServicesAvailable()) {
        return Left(NetworkFailure(
          message: 'Authentication services not available',
          statusCode: null,
        ));
      }

      final result = await _networkService!.post<Map<String, dynamic>>(
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
      if (!_ensureServicesAvailable()) {
        return Left(NetworkFailure(
          message: 'Authentication services not available',
          statusCode: null,
        ));
      }

      final result = await _networkService!.get<Map<String, dynamic>>(
        '/auth/me',
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          try {
            final user = User.fromJson(data);
            return Right(user);
          } catch (e) {
            Logger.error('User data parsing failed: $e');
            return Left(NetworkFailure(
              message: 'Invalid user data received',
              statusCode: null,
            ));
          }
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

  /// Logout
  Future<void> logout() async {
    try {
      authState.value = const AuthState.loading();

      // Call logout endpoint (don't fail if this fails)
      if (_ensureServicesAvailable()) {
        try {
          await _networkService!.post('/auth/logout', data: {});
        } catch (e) {
          Logger.warning('Server logout failed (continuing with local logout): $e');
        }
      }

      // Sign out from Google if signed in
      try {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.signOut();
        }
      } catch (e) {
        Logger.warning('Google sign out failed: $e');
      }

      // Sign out from Firebase if available
      try {
        if (_firebaseAvailable && _firebaseAuth != null) {
          await _firebaseAuth!.signOut();
        }
      } catch (e) {
        Logger.warning('Firebase sign out failed: $e');
      }

      // Clear local data
      await _tokenService?.clearToken();
      currentUser.value = null;
      authState.value = const AuthState.unauthenticated();

      Logger.success('User logged out successfully');
    } catch (e) {
      Logger.error('Logout error: $e');
      // Even if logout fails, clear local data
      await _tokenService?.clearToken();
      currentUser.value = null;
      authState.value = const AuthState.unauthenticated();
    }
  }

  /// Check Authentication Status
  bool get isAuthenticated => authState.value is AuthAuthenticated;
  bool get isLoading => authState.value is AuthLoading;
  bool get hasError => authState.value is AuthError;
  bool get isFirebaseAvailable => _firebaseAvailable;
  bool get isInitialized => _isInitialized;

  String? get errorMessage {
    final state = authState.value;
    return state is AuthError ? state.message : null;
  }

  /// Wait for initialization to complete
  Future<void> waitForInitialization() async {
    if (_isInitialized) return;

    int attempts = 0;
    const maxAttempts = 20; // 10 seconds max

    while (!_isInitialized && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 500));
      attempts++;
    }

    if (!_isInitialized) {
      Logger.warning('AuthService initialization timeout');
    }
  }
}