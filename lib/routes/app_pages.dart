// app_pages.dart
import 'package:get/get.dart';
import '../features/home/imports.dart';
import '../features/screens/offline/imports.dart';
import '../features/screens/pin_code/imports.dart';
import 'app_routes.dart';
// Import other feature pages/bindings

class AppPages {
  static final List<GetPage> routes = [
    // Auth
    GetPage(
      name: AppRoutes.pinCode,
      page: () => const PinCodePage(),
      binding: PinCodeBinding(),
      transition: Transition.fadeIn,
    ),

    // Home
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: PinCodeBinding(),
      transition: Transition.fadeIn,
    ),

    // screens
    GetPage(
      name: AppRoutes.offline,
      page: () => OfflinePage(),
      bindings: [
        OfflineBinding(),
      ],
    ),
  ];
}