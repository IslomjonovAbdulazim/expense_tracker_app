// lib/utils/services/connectivity_service.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class ConnectivityService extends GetxService {
  final RxBool isOnline = true.obs;
  final Connectivity _connectivity = Connectivity();
  String? lastRoute;

  Future<ConnectivityService> init() async {
    // Wait for GetX to initialize routes before listening to connectivity changes
    await Future.delayed(Duration(milliseconds: 100));

    final List<ConnectivityResult> result =
    await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    return this;
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool currentlyOnline =
    results.any((result) => result != ConnectivityResult.none);

    // Update the online status
    isOnline.value = currentlyOnline;

    // Only perform navigation if Get.currentRoute is not null and app is fully initialized
    if (Get.key.currentContext != null && Get.isRegistered<GetMaterialController>()) {
      if (!currentlyOnline) {
        if (Get.currentRoute != AppRoutes.offline) {
          lastRoute = Get.currentRoute;
          Get.offNamed(AppRoutes.offline);
        }
      } else {
        if (Get.currentRoute == AppRoutes.offline && lastRoute != null) {
          Get.offNamed(lastRoute!);
        }
      }
    }
  }
}