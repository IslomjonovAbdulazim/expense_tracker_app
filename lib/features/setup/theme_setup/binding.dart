part of 'imports.dart';

class ThemeSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThemeSetupController());
  }
}
