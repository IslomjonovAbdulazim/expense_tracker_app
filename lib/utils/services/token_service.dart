// lib/utils/services/token_service.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/app_constants.dart';

class TokenService extends GetxService {
  static TokenService get to => Get.find();

  final _storage = GetStorage();
  final _token = RxString('');

  /// Called immediately after the service is registered.
  Future<TokenService> init() async {
    _token.value = _storage.read(StorageKeys.authToken) ?? '';
    print("-------------------------------token");
    print(_token.value);
    return this;
  }

  Future<void> saveToken(String token) async {
    _token.value = token;
    print("------------------------------token");
    print(_token.value);
    await _storage.write(StorageKeys.authToken, token);
    print(_storage.read(StorageKeys.authToken));
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(StorageKeys.refreshToken, refreshToken);
  }

  Future<void> clearToken() async {
    _token.value = '';
    await _storage.remove(StorageKeys.authToken);
  }

  /// Check if token is available and non-empty.
  bool get hasToken => _token.value.isNotEmpty;

  /// (Optional) Expose the token publicly if needed
  String get token {
    if (_token.value.isNotEmpty) {
      return "Bearer ${_token.value}";
    } else {
      return "";
    }
  }

  /// (Optional) Expose the token publicly if needed
  String get withoutBearer {
    if (_token.value.isNotEmpty) {
      return _token.value;
    } else {
      return "";
    }
  }
}