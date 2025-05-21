part of 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.pinCode,
      page: () => const PinCodePage(),
      binding: PinCodeBinding(),
    ),
  ];
}
