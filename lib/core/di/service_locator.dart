// lib/core/di/service_locator.dart
import 'package:get/get.dart';

import '../../utils/services/connectivity_service.dart';
import '../../utils/services/token_service.dart';
import '../../utils/services/auth_service.dart';
import '../../utils/helpers/logger.dart';
import '../network/network_service.dart';

Future<void> setupServiceLocator() async {
  try {
    Logger.log('🔧 Starting service locator setup...');

    // Phase 1: Core infrastructure services (order is critical!)
    await _initializeCoreServices();

    // Phase 2: Network services
    await _initializeNetworkServices();

    // Phase 3: Authentication services
    await _initializeAuthServices();

    // Phase 4: Additional services
    await _initializeAdditionalServices();

    // Phase 5: Verify all services
    _verifyServices();

    Logger.success('✅ Service locator setup completed successfully');

  } catch (e) {
    Logger.error('❌ Critical error in service locator setup: $e');
    // Initialize minimal services to keep app functional
    await _initializeMinimalServices();
  }
}

Future<void> _initializeCoreServices() async {
  Logger.log('🏗️ Phase 1: Initializing core services...');

  // Initialize TokenService FIRST (required by NetworkService)
  if (!Get.isRegistered<TokenService>()) {
    try {
      Logger.log('📦 Initializing TokenService...');
      final tokenService = TokenService();
      await tokenService.init(); // Initialize synchronously first
      Get.put(tokenService, permanent: true);
      Logger.success('✅ TokenService initialized and registered');
    } catch (e) {
      Logger.error('❌ TokenService initialization failed: $e');
      // Put a fallback instance
      Get.put(TokenService(), permanent: true);
      Logger.warning('⚠️ TokenService fallback instance created');
    }
  } else {
    Logger.log('ℹ️ TokenService already registered');
  }

  // Small delay to ensure token service is ready
  await Future.delayed(const Duration(milliseconds: 100));
}

Future<void> _initializeNetworkServices() async {
  Logger.log('🌐 Phase 2: Initializing network services...');

  // Initialize NetworkService SECOND (requires TokenService)
  if (!Get.isRegistered<NetworkService>()) {
    try {
      Logger.log('🔌 Initializing NetworkService...');
      final networkService = NetworkService();
      networkService.initialize(); // Initialize the Dio instance
      Get.put(networkService, permanent: true);
      Logger.success('✅ NetworkService initialized and registered');
    } catch (e) {
      Logger.error('❌ NetworkService initialization failed: $e');
      // Create a fallback network service
      final fallbackService = NetworkService();
      Get.put(fallbackService, permanent: true);
      Logger.warning('⚠️ NetworkService fallback instance created');
    }
  } else {
    Logger.log('ℹ️ NetworkService already registered');
  }

  // Small delay to ensure network service is ready
  await Future.delayed(const Duration(milliseconds: 100));
}

Future<void> _initializeAuthServices() async {
  Logger.log('🔐 Phase 3: Initializing authentication services...');

  // AuthService depends on both TokenService and NetworkService
  if (!Get.isRegistered<AuthService>()) {
    try {
      Logger.log('👤 Initializing AuthService...');
      final authService = AuthService();
      Get.put(authService, permanent: true);

      // Allow AuthService to initialize asynchronously
      Logger.log('⏳ Waiting for AuthService initialization...');
      await Future.delayed(const Duration(milliseconds: 500));

      Logger.success('✅ AuthService registered (initializing asynchronously)');
    } catch (e) {
      Logger.error('❌ AuthService initialization failed: $e');
      Logger.warning('⚠️ Auth features may not work properly');
    }
  } else {
    Logger.log('ℹ️ AuthService already registered');
  }
}

Future<void> _initializeAdditionalServices() async {
  Logger.log('🔧 Phase 4: Initializing additional services...');

  // Connectivity service (initialize with delay to avoid navigation issues)
  if (!Get.isRegistered<ConnectivityService>()) {
    try {
      Logger.log('📡 Initializing ConnectivityService...');

      // Add delay to ensure navigation system is ready
      await Future.delayed(const Duration(milliseconds: 1000));

      final connectivityService = ConnectivityService();
      Get.put(connectivityService, permanent: true);

      // Initialize asynchronously
      connectivityService.init().catchError((e) {
        Logger.warning('ConnectivityService init failed: $e');
      });

      Logger.success('✅ ConnectivityService registered');
    } catch (e) {
      Logger.error('❌ ConnectivityService initialization failed: $e');
      Logger.warning('⚠️ Offline detection may not work');
    }
  } else {
    Logger.log('ℹ️ ConnectivityService already registered');
  }

  // PIN service initialization (commented out for now)
  /*
  if (!Get.isRegistered<EnhancedPinService>()) {
    try {
      Logger.log('🔒 Initializing EnhancedPinService...');
      final pinService = EnhancedPinService();
      await pinService.init();
      Get.put(pinService, permanent: true);
      Logger.success('✅ EnhancedPinService initialized');
    } catch (e) {
      Logger.error('❌ EnhancedPinService initialization failed: $e');
      Logger.warning('⚠️ PIN security features may not work');
    }
  }
  */
}

Future<void> _initializeMinimalServices() async {
  Logger.warning('🚨 Initializing minimal services fallback...');

  try {
    // Ensure at least token service is available
    if (!Get.isRegistered<TokenService>()) {
      Get.put(TokenService(), permanent: true);
      Logger.log('📦 Minimal TokenService created');
    }

    // Configure basic network
    if (!Get.isRegistered<NetworkService>()) {
      final networkService = NetworkService();
      networkService.initialize();
      Get.put(networkService, permanent: true);
      Logger.log('🔌 Minimal NetworkService created');
    }

    // Basic auth service
    if (!Get.isRegistered<AuthService>()) {
      final authService = AuthService();
      Get.put(authService, permanent: true);
      Logger.log('👤 Minimal AuthService created');
    }

    Logger.warning('⚠️ Minimal services initialized - some features may not work');
  } catch (e) {
    Logger.error('❌ Even minimal services failed: $e');
  }
}

void _verifyServices() {
  Logger.log('🔍 Phase 5: Verifying services...');

  final services = getServiceDiagnostics();

  services.forEach((serviceName, isRegistered) {
    if (isRegistered) {
      Logger.success('✅ $serviceName: Registered');
    } else {
      Logger.warning('⚠️ $serviceName: Not registered');
    }
  });

  final healthyServices = services.values.where((v) => v).length;
  final totalServices = services.length;

  Logger.log('📊 Service Health: $healthyServices/$totalServices services registered');

  if (healthyServices >= 3) { // TokenService, NetworkService, AuthService
    Logger.success('✅ Core services are healthy');
  } else {
    Logger.warning('⚠️ Some core services are missing');
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

// Force re-initialization of a specific service
Future<void> reinitializeService<T>() async {
  try {
    Logger.log('🔄 Reinitializing ${T.toString()}...');

    if (Get.isRegistered<T>()) {
      Get.delete<T>();
      Logger.log('🗑️ Removed existing ${T.toString()}');
    }

    // Wait a bit for cleanup
    await Future.delayed(const Duration(milliseconds: 100));

    // Reinitialize based on service type
    if (T == TokenService) {
      final service = TokenService();
      await service.init();
      Get.put<T>(service as T, permanent: true);
    } else if (T == NetworkService) {
      final service = NetworkService();
      service.initialize();
      Get.put<T>(service as T, permanent: true);
    } else if (T == AuthService) {
      final service = AuthService();
      Get.put<T>(service as T, permanent: true);
    } else if (T == ConnectivityService) {
      final service = ConnectivityService();
      Get.put<T>(service as T, permanent: true);
      service.init();
    }

    Logger.success('✅ ${T.toString()} reinitialized');
  } catch (e) {
    Logger.error('❌ Failed to reinitialize ${T.toString()}: $e');
  }
}

// Emergency service recovery
Future<void> emergencyServiceRecovery() async {
  Logger.warning('🚨 Starting emergency service recovery...');

  try {
    // Clear all services
    Get.deleteAll();
    Logger.log('🗑️ Cleared all services');

    // Wait for cleanup
    await Future.delayed(const Duration(milliseconds: 500));

    // Re-run service locator
    await setupServiceLocator();

    Logger.success('✅ Emergency recovery completed');
  } catch (e) {
    Logger.error('❌ Emergency recovery failed: $e');
    await _initializeMinimalServices();
  }
}