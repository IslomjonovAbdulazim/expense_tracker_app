// lib/core/di/service_locator.dart
import 'package:get/get.dart';

import '../../utils/services/connectivity_service.dart';
import '../../utils/services/token_service.dart';
import '../../utils/services/auth_service.dart';
import '../../utils/helpers/logger.dart';
import '../network/network_service.dart';

Future<void> setupServiceLocator() async {
  try {
    Logger.log('Starting service locator setup...');

    // Phase 1: Core infrastructure services (order matters!)
    await _initializeCoreServices();

    // Phase 2: Authentication services
    await _initializeAuthServices();

    // Phase 3: Network services
    await _initializeNetworkServices();

    Logger.success('Service locator setup completed successfully');

  } catch (e) {
    Logger.error('Critical error in service locator setup: $e');
    // Initialize minimal services to keep app functional
    await _initializeMinimalServices();
  }
}

Future<void> _initializeCoreServices() async {
  Logger.log('Initializing core services...');

  // Initialize TokenService FIRST (required by others)
  if (!Get.isRegistered<TokenService>()) {
    try {
      await Get.putAsync<TokenService>(
            () async => await TokenService().init(),
        permanent: true,
      );
      Logger.success('TokenService initialized');
    } catch (e) {
      Logger.error('TokenService initialization failed: $e');
      // Put a fallback instance
      Get.put(TokenService(), permanent: true);
    }
  }

  // Initialize NetworkService SECOND (requires TokenService)
  if (!Get.isRegistered<NetworkService>()) {
    final networkService = NetworkService();
    Get.put(networkService, permanent: true);
    Logger.success('NetworkService initialized');
  }
}

Future<void> _initializeAuthServices() async {
  Logger.log('Initializing authentication services...');

  // AuthService depends on both TokenService and NetworkService
  if (!Get.isRegistered<AuthService>()) {
    try {
      final authService = AuthService();
      Get.put(authService, permanent: true);
      Logger.success('AuthService initialized');
    } catch (e) {
      Logger.error('AuthService initialization failed: $e');
      // Continue without auth service - handle gracefully
    }
  }

  // PIN service - using your existing PinService for now
  // You can replace this with EnhancedPinService later
  /*
  if (!Get.isRegistered<EnhancedPinService>()) {
    try {
      await Get.putAsync<EnhancedPinService>(
        () async => await EnhancedPinService().init(),
        permanent: true,
      );
      Logger.success('EnhancedPinService initialized');
    } catch (e) {
      Logger.error('EnhancedPinService initialization failed: $e');
    }
  }
  */
}

Future<void> _initializeNetworkServices() async {
  Logger.log('Initializing network services...');

  // Connectivity service (initialize last due to navigation dependencies)
  if (!Get.isRegistered<ConnectivityService>()) {
    try {
      // Add a small delay to ensure other services are ready
      await Future.delayed(const Duration(milliseconds: 500));

      await Get.putAsync<ConnectivityService>(
            () async => await ConnectivityService().init(),
        permanent: true,
      );
      Logger.success('ConnectivityService initialized');
    } catch (e) {
      Logger.error('ConnectivityService initialization failed: $e');
    }
  }
}

Future<void> _initializeMinimalServices() async {
  Logger.warning('Initializing minimal services fallback...');

  try {
    // Ensure at least token service is available
    if (!Get.isRegistered<TokenService>()) {
      Get.put(TokenService(), permanent: true);
    }

    // Configure basic network
    if (!Get.isRegistered<NetworkService>()) {
      final networkService = NetworkService();
      Get.put(networkService, permanent: true);
    }

    // Basic auth service
    if (!Get.isRegistered<AuthService>()) {
      final authService = AuthService();
      Get.put(authService, permanent: true);
    }

  } catch (e) {
    Logger.error('Even minimal services failed: $e');
  }
}

// Service health check
bool areServicesHealthy() {
  final requiredServices = [
    TokenService,
    NetworkService,
    AuthService,
  ];

  for (final serviceType in requiredServices) {
    if (!Get.isRegistered(tag: serviceType.toString())) {
      Logger.warning('Service not registered: $serviceType');
      return false;
    }
  }

  return true;
}

// Service diagnostics
Map<String, bool> getServiceDiagnostics() {
  return {
    'TokenService': Get.isRegistered<TokenService>(),
    'NetworkService': Get.isRegistered<NetworkService>(),
    'AuthService': Get.isRegistered<AuthService>(),
    'ConnectivityService': Get.isRegistered<ConnectivityService>(),
  };
}