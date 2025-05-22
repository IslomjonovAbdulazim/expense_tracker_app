// lib/utils/helpers/app_diagnostics.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/connectivity_service.dart';
import '../services/token_service.dart';
import '../services/theme_service.dart';
import '../../core/network/network_service.dart';
import '../../core/translations/language_controller.dart';
import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';
import 'logger.dart';

class AppDiagnostics {
  static Future<Map<String, dynamic>> runDiagnostics() async {
    final diagnostics = <String, dynamic>{};

    Logger.log('AppDiagnostics: Starting comprehensive diagnostics');

    try {
      // 1. Flutter Framework Status
      diagnostics['flutter_binding'] = _checkFlutterBinding();

      // 2. GetX Status
      diagnostics['getx'] = _checkGetXStatus();

      // 3. Storage Status
      diagnostics['storage'] = await _checkStorageStatus();

      // 4. Services Status
      diagnostics['services'] = _checkServicesStatus();

      // 5. Navigation Status
      diagnostics['navigation'] = _checkNavigationStatus();

      // 6. Routes Status
      diagnostics['routes'] = _checkRoutesStatus();

      // 7. Memory and Performance
      diagnostics['performance'] = _checkPerformanceStatus();

      Logger.log('AppDiagnostics: Diagnostics completed');

    } catch (e) {
      Logger.error('AppDiagnostics: Error during diagnostics: $e');
      diagnostics['error'] = e.toString();
    }

    return diagnostics;
  }

  static Map<String, dynamic> _checkFlutterBinding() {
    return {
      'widgets_binding_initialized': WidgetsBinding.instance.isRootWidgetAttached,
      'debug_mode': kDebugMode,
      'release_mode': kReleaseMode,
      'profile_mode': kProfileMode,
    };
  }

  static Map<String, dynamic> _checkGetXStatus() {
    return {
      'get_initialized': Get.isLogEnable,
      'current_route': Get.currentRoute,
      'routing_key': Get.key.toString(),
      'context_available': Get.context != null,
      'registered_services_count': Get.size,
    };
  }

  static Future<Map<String, dynamic>> _checkStorageStatus() async {
    final storage = <String, dynamic>{};

    try {
      // Test GetStorage
      final getStorage = GetStorage();
      final testKey = 'diagnostic_test_${DateTime.now().millisecondsSinceEpoch}';
      await getStorage.write(testKey, 'test_value');
      final testValue = getStorage.read(testKey);
      await getStorage.remove(testKey);

      storage['get_storage'] = {
        'available': true,
        'read_write_test': testValue == 'test_value',
      };
    } catch (e) {
      storage['get_storage'] = {
        'available': false,
        'error': e.toString(),
      };
    }

    try {
      // Check SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final testKey = 'diagnostic_test_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(testKey, 'test_value');
      final testValue = prefs.getString(testKey);
      await prefs.remove(testKey);

      storage['shared_preferences'] = {
        'available': true,
        'read_write_test': testValue == 'test_value',
      };
    } catch (e) {
      storage['shared_preferences'] = {
        'available': false,
        'error': e.toString(),
      };
    }

    return storage;
  }

  static Map<String, dynamic> _checkServicesStatus() {
    return {
      'token_service': Get.isRegistered<TokenService>(),
      'connectivity_service': Get.isRegistered<ConnectivityService>(),
      'network_service': Get.isRegistered<NetworkService>(),
      'theme_controller': Get.isRegistered<ThemeController>(),
      'language_controller': Get.isRegistered<LanguageController>(),
    };
  }

  static Map<String, dynamic> _checkNavigationStatus() {
    return {
      'current_route': Get.currentRoute,
      'previous_route': Get.previousRoute,
      'has_navigator': Get.key != null,
      'can_pop': Get.context != null ? Navigator.of(Get.context!).canPop() : false,
    };
  }

  static Map<String, dynamic> _checkRoutesStatus() {
    try {
      return {
        'routes_defined': AppPages.routes.isNotEmpty,
        'routes_count': AppPages.routes.length,
        'splash_route_exists': AppPages.routes.any((route) => route.name == AppRoutes.splash),
        'home_route_exists': AppPages.routes.any((route) => route.name == AppRoutes.home),
        'onboarding_route_exists': AppPages.routes.any((route) => route.name == AppRoutes.onboarding),
        'pin_code_route_exists': AppPages.routes.any((route) => route.name == AppRoutes.pinCode),
      };
    } catch (e) {
      return {
        'error': e.toString(),
      };
    }
  }

  static Map<String, dynamic> _checkPerformanceStatus() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'available_memory_mb': _getAvailableMemory(),
    };
  }

  static double? _getAvailableMemory() {
    try {
      // This is a simplified memory check
      return null; // Platform-specific implementation would go here
    } catch (e) {
      return null;
    }
  }

  static String formatDiagnostics(Map<String, dynamic> diagnostics) {
    final buffer = StringBuffer();
    buffer.writeln('🔍 APP DIAGNOSTICS REPORT');
    buffer.writeln('=' * 40);

    diagnostics.forEach((category, data) {
      buffer.writeln('\n📋 ${category.toUpperCase()}:');
      if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          final status = _getStatusIcon(value);
          buffer.writeln('  $status $key: $value');
        });
      } else {
        buffer.writeln('  📝 $data');
      }
    });

    return buffer.toString();
  }

  static String _getStatusIcon(dynamic value) {
    if (value is bool) {
      return value ? '✅' : '❌';
    } else if (value is Map && value.containsKey('available')) {
      return value['available'] ? '✅' : '❌';
    } else if (value is String && value.toLowerCase().contains('error')) {
      return '❌';
    } else if (value != null) {
      return '✅';
    }
    return '⚠️';
  }

  // Quick diagnostic method for debugging
  static Future<void> printQuickDiagnostics() async {
    if (!kDebugMode) return;

    Logger.log('🚀 Quick Diagnostics:');
    Logger.log('- GetX initialized: ${Get.isLogEnable}');
    Logger.log('- Current route: ${Get.currentRoute}');
    Logger.log('- Context available: ${Get.context != null}');
    Logger.log('- Services registered: ${Get.size}');

    try {
      final storage = GetStorage();
      storage.write('test', 'ok');
      final test = storage.read('test');
      Logger.log('- GetStorage working: ${test == 'ok'}');
    } catch (e) {
      Logger.error('- GetStorage error: $e');
    }

    Logger.log('- TokenService: ${Get.isRegistered<TokenService>()}');
    Logger.log('- ConnectivityService: ${Get.isRegistered<ConnectivityService>()}');
  }
}