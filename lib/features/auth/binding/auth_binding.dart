import 'package:get/get.dart';
import '../../../utils/services/auth_service.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthService if not already registered
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }

    // Register AuthController
    Get.lazyPut(() => AuthController());
  }
}
