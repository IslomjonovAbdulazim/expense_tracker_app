part of 'imports.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_Controller>(() => _Controller());
  }
}