import 'package:get/get.dart';
import '../../data/providers/dio_manager.dart';
import '../../utils/services/connectivity_service.dart';
import '../../utils/services/pin_service.dart';
import '../../utils/services/theme_service.dart';
import '../../utils/services/token_service.dart';

/// Setup all services and dependencies
Future<void> setupServiceLocator() async {
  // Initialize network client
  Get.put(DioManager(), permanent: true);

  // Initialize services
  await Get.putAsync<TokenService>(() async => await TokenService().init());
  await Get.putAsync<PinService>(() async => await PinService().init());
  await Get.putAsync<ConnectivityService>(() async => await ConnectivityService().init());

  // Initialize controllers that should be available globally
  Get.put(ThemeController(), permanent: true);
}
