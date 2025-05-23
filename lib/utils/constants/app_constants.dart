// lib/utils/constants/app_constants.dart

/// Core application constants
class AppConstants {
  AppConstants._();  // Private constructor to prevent instantiation

  // API Constants
  static const String baseUrl = "https://api.example.com";
  static const String apiKey = "YOUR_API_KEY";
  static const int timeoutSeconds = 30;
}

/// Storage key constants
class StorageKeys {
  StorageKeys._();  // Private constructor

  // Authentication & Security
  static const String pinProtected = "is_pin_protected";
  static const String pinHash = "pin_hash";
  static const String appPausedAt = "app_paused_at";
  static const String hasCompletedOnboarding = "has_completed_onboarding";
  static const String hasCompletedPreferences = "has_completed_preferences"; // NEW
  static const String authToken = "auth_token";
  static const String refreshToken = "refresh_token";
  static const String userProfile = "user_profile";

  // App Settings
  static const String selectedTheme = "selected_theme";
  static const String selectedLanguage = "selected_language";
  static const String selectedCurrency = "selected_currency"; // NEW
  static const String notificationsEnabled = "notifications_enabled";
  static const String biometricsEnabled = "biometrics_enabled";

  // Feature Flags
  static const String premiumEnabled = "premium_enabled";
  static const String betaFeaturesEnabled = "beta_features_enabled";

  // Cache Keys
  static const String lastSyncTimestamp = "last_sync_timestamp";
  static const String cachedCategories = "cached_categories";
  static const String cachedTransactions = "cached_transactions";
}

class DevConstants {
  static const bool enableAuthMiddleware = false; // Set to false for UI development
}

/// Timeout value constants
class TimeoutConstants {
  TimeoutConstants._();  // Private constructor

  static const int sessionTimeoutMinutes = 5;
  static const int tokenExpiryMinutes = 60;
  static const int splashScreenDelayMillis = 1500;
  static const int animationDurationMillis = 300;
  static const int networkTimeoutSeconds = 30;
  static const int cacheExpiryHours = 24;
}

/// UI-related constants
class UIConstants {
  UIConstants._();  // Private constructor

  static const double borderRadius = 12.0;
  static const double buttonHeight = 50.0;
  static const double iconSize = 24.0;
  static const double spacing = 16.0;
  static const double cardElevation = 2.0;
  static const double maxContentWidth = 600.0;
}

/// Feature limit constants
class LimitConstants {
  LimitConstants._();  // Private constructor

  static const int maxPinAttempts = 5;
  static const int maxCategoriesPerUser = 50;
  static const int maxTransactionsPerPage = 20;
  static const int maxRecentItems = 10;
  static const int maxSearchResults = 50;
}

/// Default value constants
class DefaultConstants {
  DefaultConstants._();  // Private constructor

  static const String defaultCurrency = "USD";
  static const String defaultLanguage = "en";
  static const String defaultDateFormat = "yyyy-MM-dd";
  static const double defaultTransactionAmount = 0.0;
}