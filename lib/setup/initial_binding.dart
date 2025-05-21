import 'package:get/get.dart';

import '../data/providers/dio_manager.dart';
import '../utils/services/connectivity_service.dart';
import '../utils/services/pin_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    configureDio();
    await Get.putAsync<PinService>(() async => await PinService().init());
    Get.put(ConnectivityService());
  }
}
