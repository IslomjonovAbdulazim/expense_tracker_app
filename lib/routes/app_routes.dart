class AppRoutes {
  // Core feature routes
  static const String home = '/home';
  static const String admin = '/admin';

  // Authentication routes
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';

  // Setup/Preference routes (NEW)
  static const String languageSetup = '/language-setup';
  static const String themeSetup = '/theme-setup';
  static const String currencySetup = '/currency-setup';

  // Feature routes
  static const String transactions = '/transactions';
  static const String addTransaction = '/add-transaction';
  static const String categories = '/categories';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String pinCode = '/pin-code';

  // Utility routes
  static const String offline = '/offline';
  static const String internalError = '/internal-error';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String splash = "/splash";
}