import '../../core/utils/storage_utils.dart';
import 'package:logger/logger.dart';

/// 인증 관련 서비스 - JWT 토큰 관리
class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _userInfoKey = 'user_info';

  static final Logger _logger = Logger();

  /// JWT 토큰 저장
  static Future<bool> saveToken(String token) async {
    try {
      final result = await StorageUtils.setString(_tokenKey, token);
      if (result) {
        _logger.d('JWT 토큰 저장 완료');
      } else {
        _logger.e('JWT 토큰 저장 실패');
      }
      return result;
    } catch (e) {
      _logger.e('JWT 토큰 저장 오류: $e');
      return false;
    }
  }

  /// JWT 토큰 가져오기
  static Future<String?> getToken() async {
    try {
      final token = await StorageUtils.getString(_tokenKey);
      if (token != null) {
        _logger.d('JWT 토큰 로드 완료');
      } else {
        _logger.d('저장된 JWT 토큰 없음');
      }
      return token;
    } catch (e) {
      _logger.e('JWT 토큰 로드 오류: $e');
      return null;
    }
  }

  /// JWT 토큰 삭제
  static Future<bool> clearToken() async {
    try {
      final result = await StorageUtils.setString(_tokenKey, '');
      if (result) {
        _logger.d('JWT 토큰 삭제 완료');
      } else {
        _logger.e('JWT 토큰 삭제 실패');
      }
      return result;
    } catch (e) {
      _logger.e('JWT 토큰 삭제 오류: $e');
      return false;
    }
  }

  /// 사용자 정보 저장
  static Future<bool> saveUserInfo(Map<String, dynamic> userInfo) async {
    try {
      final result = await StorageUtils.saveSession(userInfo);
      if (result) {
        _logger.d('사용자 정보 저장 완료');
      }
      return result;
    } catch (e) {
      _logger.e('사용자 정보 저장 오류: $e');
      return false;
    }
  }

  /// 사용자 정보 가져오기
  static Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      return await StorageUtils.getSession();
    } catch (e) {
      _logger.e('사용자 정보 로드 오류: $e');
      return null;
    }
  }

  /// 로그인 상태 확인
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // 로그아웃 기능은 나중에 구현 예정

  /// Authorization 헤더용 토큰 형식 반환
  static Future<String?> getAuthHeaderToken() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      return 'Bearer $token';
    }
    return null;
  }
}