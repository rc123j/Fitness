import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';
  static const _userRoleKey = 'user_role';
  static const _onboardingDoneKey = 'onboarding_done';

  String? get accessToken => _storage.read(_accessTokenKey);
  String? get refreshToken => _storage.read(_refreshTokenKey);
  int? get userId => _storage.read(_userIdKey);
  String? get userEmail => _storage.read(_userEmailKey);
  String? get userRole => _storage.read(_userRoleKey);
  bool get isLoggedIn => accessToken != null;
  bool get isOnboardingDone => _storage.read(_onboardingDoneKey) ?? false;

  void saveSession({
    required String accessToken,
    required String refreshToken,
    required int userId,
    required String email,
    required String role,
    bool isOnboarded = false,
  }) {
    _storage.write(_accessTokenKey, accessToken);
    _storage.write(_refreshTokenKey, refreshToken);
    _storage.write(_userIdKey, userId);
    _storage.write(_userEmailKey, email);
    _storage.write(_userRoleKey, role);
    _storage.write(_onboardingDoneKey, isOnboarded);
  }

  void updateAccessToken(String token) {
    _storage.write(_accessTokenKey, token);
  }

  void setOnboardingDone(bool value) {
    _storage.write(_onboardingDoneKey, value);
  }

  Future<void> clearSession() async {
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_userIdKey);
    await _storage.remove(_userEmailKey);
    await _storage.remove(_userRoleKey);
    await _storage.remove(_onboardingDoneKey);
  }

  Future<void> logout() async {
    await clearSession();
    Get.offAllNamed('/splash');
  }
}
