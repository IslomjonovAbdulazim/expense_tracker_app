import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TokenService extends GetxService {
  static TokenService get to => Get.find<TokenService>();

  final _storage = GetStorage();
  final _tokenKey = 'auth_token';
  final _refreshTokenKey = 'refresh_token';

  final RxString _token = ''.obs;
  final RxString _refreshToken = ''.obs;

  Future<TokenService> init() async {
    _token.value = _storage.read(_tokenKey) ?? '';
    _refreshToken.value = _storage.read(_refreshTokenKey) ?? '';
    return this;
  }

  Future<void> saveToken(String token) async {
    _token.value = token;
    await _storage.write(_tokenKey, token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    _refreshToken.value = refreshToken;
    await _storage.write(_refreshTokenKey, refreshToken);
  }

  Future<void> clearTokens() async {
    _token.value = '';
    _refreshToken.value = '';
    await _storage.remove(_tokenKey);
    await _storage.remove(_refreshTokenKey);
  }

  bool get hasToken => _token.value.isNotEmpty;

  String get token => _token.value.isNotEmpty ? 'Bearer ${_token.value}' : '';

  String get tokenWithoutBearer => _token.value;

  String get refreshToken => _refreshToken.value;
}
