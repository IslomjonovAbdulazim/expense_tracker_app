part of 'imports.dart';

class LanguageSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageSetupController());
  }
}