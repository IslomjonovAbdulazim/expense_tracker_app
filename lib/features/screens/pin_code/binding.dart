part of 'imports.dart';

class PinCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => _Controller());
  }
}