part of 'imports.dart';

class CurrencySetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CurrencySetupController());

    if (!Get.isRegistered<CurrencyService>()) {
      Get.put(CurrencyService(), permanent: true);
    }
  }
}