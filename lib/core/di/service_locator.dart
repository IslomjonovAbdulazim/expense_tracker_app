// lib/core/di/service_locator.dart
import 'package:get/get.dart';

import '../../data/providers/dio_manager.dart';
import '../../utils/services/connectivity_service.dart';
import '../../utils/services/pin_service.dart';
import '../../utils/services/token_service.dart';
import '../../utils/services/network_service.dart';
import '../../utils/helpers/logger.dart';

Future<void> setupServiceLocator() async {
  try {
    Logger.log('Starting service locator setup...');

    // Phase 1: Core infrastructure services
    await _initializeCoreServices();

    // Phase 2: Authentication services
    await _initializeAuthServices();

    // Phase 3: Network services
    await _initializeNetworkServices();

    // Phase 4: App-specific services
    await _initializeAppServices();

    Logger.success('Service locator setup completed successfully');

  } catch (e) {
    Logger.error('Critical error in service locator setup: $e');
    // Initialize minimal services to keep app functional
    await _initializeMinimalServices();
  }
}

Future<void> _initializeCoreServices() async {
  Logger.log('Initializing core services...');

  // Configure Dio first
  configureDio();

  // Initialize network service
  if (!Get.isRegistered<NetworkService>()) {
    final networkService = NetworkService();
    networkService.initialize();
    Get.put(networkService, permanent: true);
  }
}

Future<void> _initializeAuthServices() async {
  Logger.log('Initializing authentication services...');

  // Token service
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

  // PIN service
  if (!Get.isRegistered<PinService>()) {
    try {
      await Get.putAsync<PinService>(
            () async => await PinService().init(),
        permanent: true,
      );
      Logger.success('PinService initialized');
    } catch (e) {
      Logger.error('PinService initialization failed: $e');
    }
  }
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

Future<void> _initializeAppServices() async {
  Logger.log('Initializing app-specific services...');

  // Add any additional app-specific services here
  // Example: Analytics, Crash reporting, etc.
}

Future<void> _initializeMinimalServices() async {
  Logger.warning('Initializing minimal services fallback...');

  try {
    // Ensure at least token service is available
    if (!Get.isRegistered<TokenService>()) {
      Get.put(TokenService(), permanent: true);
    }

    // Configure basic network
    configureDio();
    if (!Get.isRegistered<NetworkService>()) {
      final networkService = NetworkService();
      networkService.initialize();
      Get.put(networkService, permanent: true);
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
    'PinService': Get.isRegistered<PinService>(),
    'NetworkService': Get.isRegistered<NetworkService>(),
    'ConnectivityService': Get.isRegistered<ConnectivityService>(),
  };
}