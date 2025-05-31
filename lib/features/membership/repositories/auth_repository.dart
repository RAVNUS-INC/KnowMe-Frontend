import '../../../shared/services/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/storage_utils.dart';
import '../models/login_dtos.dart';
import '../models/signup_dtos.dart';
import 'package:logger/logger.dart';

/// 인증 관련 Repository - 로그인, 회원가입, 토큰 관리 통합
class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  static const String _tokenKey = 'jwt_token';
  static final Logger _logger = Logger();

  // ================== API 호출 메서드 ==================

  /// 로그인 API 호출
  Future<ApiResponse<LoginResponseDto>> login(LoginRequestDto request) async {
    return await _apiClient.post<LoginResponseDto>(
      ApiEndpoints.userLogin,
      body: request.toJson(),
      fromJson: (json) => LoginResponseDto.fromJson(json),
    );
  }

  /// 회원가입 API 호출
  Future<ApiResponse<SignupResponseDto>> signup(SignupRequestDto request) async {
    return await _apiClient.post<SignupResponseDto>(
      ApiEndpoints.userJoin,
      body: request.toJson(),
      fromJson: (json) => SignupResponseDto.fromJson(json),
    );
  }

  // ================== 토큰 관리 메서드 ==================

  /// JWT 토큰 저장
  Future<bool> saveToken(String token) async {
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
  Future<String?> getToken() async {
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
  Future<bool> clearToken() async {
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

  /// Authorization 헤더용 토큰 형식 반환
  Future<String?> getAuthHeaderToken() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      return 'Bearer $token';
    }
    return null;
  }

  // ================== 사용자 정보 관리 메서드 ==================

  /// 사용자 정보 저장
  Future<bool> saveUserInfo(Map<String, dynamic> userInfo) async {
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
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      return await StorageUtils.getSession();
    } catch (e) {
      _logger.e('사용자 정보 로드 오류: $e');
      return null;
    }
  }

  /// 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ================== 로그인 정보 저장 관리 (Remember Me) ==================

  /// 로그인 정보 저장 (Remember Me용)
  Future<bool> saveCredentials({
    required String loginId,
    required String password,
  }) async {
    try {
      return await StorageUtils.saveCredentials(
        loginId: loginId,
        password: password,
      );
    } catch (e) {
      _logger.e('로그인 정보 저장 오류: $e');
      return false;
    }
  }

  /// 저장된 로그인 정보 로드
  Future<Map<String, String>?> getSavedCredentials() async {
    try {
      return await StorageUtils.getSavedCredentials();
    } catch (e) {
      _logger.e('로그인 정보 로드 오류: $e');
      return null;
    }
  }

  /// Remember Me 상태 설정
  Future<bool> setRememberMe(bool remember) async {
    try {
      return await StorageUtils.setRememberMe(remember);
    } catch (e) {
      _logger.e('Remember Me 저장 오류: $e');
      return false;
    }
  }

  /// Remember Me 상태 가져오기
  Future<bool> getRememberMe() async {
    try {
      return await StorageUtils.getRememberMe();
    } catch (e) {
      _logger.e('Remember Me 로드 오류: $e');
      return false;
    }
  }

  /// 저장된 로그인 정보 삭제
  Future<bool> clearSavedCredentials() async {
    try {
      return await StorageUtils.clearSavedCredentials();
    } catch (e) {
      _logger.e('로그인 정보 삭제 오류: $e');
      return false;
    }
  }

  // ================== 로그아웃 및 전체 정리 ==================

  /// 로그아웃 (모든 인증 관련 데이터 삭제)
  Future<bool> logout() async {
    try {
      final results = await Future.wait([
        clearToken(),
        StorageUtils.clearSession(),
        clearSavedCredentials(),
      ]);

      final allSuccess = results.every((result) => result);

      if (allSuccess) {
        _logger.d('로그아웃 완료 - 모든 데이터 삭제됨');
      } else {
        _logger.e('로그아웃 중 일부 데이터 삭제 실패');
      }

      return allSuccess;
    } catch (e) {
      _logger.e('로그아웃 오류: $e');
      return false;
    }
  }
}