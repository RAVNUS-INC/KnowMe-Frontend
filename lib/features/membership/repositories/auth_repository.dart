import 'package:url_launcher/url_launcher.dart';
import '../../../shared/services/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/storage_utils.dart';
import '../models/login_dtos.dart';
import '../models/signup_dtos.dart';
import '../models/password_reset_dtos.dart';
import '../models/find_id_dtos.dart';  // ✅ 추가
import '../models/user_info_dtos.dart';  // ✅ 새로 추가
import 'package:logger/logger.dart';

/// 인증 관련 Repository
class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';  // ✅ 새로 추가: 사용자 ID 저장용 키
  static final Logger _logger = Logger();

  // ================== 로그인/회원가입 API 호출 ==================

  /// 로그인 API 호출
  Future<ApiResponse<LoginResponseDto>> login(LoginRequestDto request) async {
    return await _apiClient.post<LoginResponseDto>(
      ApiEndpoints.userLogin,
      body: request.toJson(),
      fromJson: (json) => LoginResponseDto.fromJson(json),
      requireAuth: false,
    );
  }

  /// 회원가입 API 호출
  Future<ApiResponse<SignupResponseDto>> signup(SignupRequestDto request) async {
    return await _apiClient.post<SignupResponseDto>(
      ApiEndpoints.userJoin,
      body: request.toJson(),
      fromJson: (json) => SignupResponseDto.fromJson(json),
      requireAuth: false,
    );
  }

  // ================== 새로 추가: 사용자 정보 조회 ==================

  /// 현재 로그인된 사용자 정보 조회 API 호출
  Future<ApiResponse<UserInfoResponseDto>> getCurrentUserInfo() async {
    _logger.d('현재 사용자 정보 조회 API 호출');

    try {
      final response = await _apiClient.get<UserInfoResponseDto>(
        ApiEndpoints.userMe,
        fromJson: (json) => UserInfoResponseDto.fromJson(json),
        requireAuth: true, // 인증이 필요한 API
      );

      _logger.d('사용자 정보 API 응답: ${response.data}');
      return response;

    } catch (e) {
      _logger.e('사용자 정보 조회 API 오류: $e');
      return ApiResponse.error(
        message: 'API 호출 중 오류 발생: $e',
        statusCode: 0,
      );
    }
  }

  // ================== 아이디 찾기 API 호출 (새로 추가) ==================

  /// 아이디 찾기 API 호출
  Future<ApiResponse<FindIdResponseDto>> findId(FindIdRequestDto request) async {
    _logger.d('아이디 찾기 API 호출: ${request.toJson()}');

    try {
      final response = await _apiClient.post<FindIdResponseDto>(
        ApiEndpoints.findId,
        body: request.toJson(),
        fromJson: (json) => FindIdResponseDto.fromJson(json),
        requireAuth: false,
      );

      _logger.d('아이디 찾기 API 응답: ${response.data}');
      return response;

    } catch (e) {
      _logger.e('아이디 찾기 API 오류: $e');
      return ApiResponse.error(
        message: 'API 호출 중 오류 발생: $e',
        statusCode: 0,
      );
    }
  }

  // ================== 비밀번호 재설정 ==================

  /// 비밀번호 재설정 API 호출 (PUT 방식) - 단순화
  Future<ApiResponse<Map<String, dynamic>>> resetPassword(PasswordResetRequestDto request) async {
    _logger.d('비밀번호 재설정 API 호출: ${request.toJson()}');

    try {
      // 단순한 Map으로 응답 받기 (DTO 파싱 문제 방지)
      final response = await _apiClient.put<Map<String, dynamic>>(
        ApiEndpoints.editPassword,
        body: request.toJson(),
        requireAuth: false,
      );

      _logger.d('API 응답 원본: ${response.data}');
      return response;

    } catch (e) {
      _logger.e('비밀번호 재설정 API 오류: $e');
      return ApiResponse.error(
        message: 'API 호출 중 오류 발생: $e',
        statusCode: 0,
      );
    }
  }

  // ================== 소셜 로그인 관련 (단순화) ==================

  /// 네이버 소셜 로그인 URL로 리디렉션
  Future<bool> loginWithNaver() async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiEndpoints.getOAuthUrl('naver')}';
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      _logger.e('네이버 소셜 로그인 오류: $e');
      return false;
    }
  }

  // ================== 토큰 관리 메서드 ==================

  Future<bool> saveToken(String token) async {
    try {
      return await StorageUtils.setString(_tokenKey, token);
    } catch (e) {
      _logger.e('JWT 토큰 저장 오류: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    try {
      return await StorageUtils.getString(_tokenKey);
    } catch (e) {
      _logger.e('JWT 토큰 로드 오류: $e');
      return null;
    }
  }

  Future<bool> clearToken() async {
    try {
      return await StorageUtils.setString(_tokenKey, '');
    } catch (e) {
      _logger.e('JWT 토큰 삭제 오류: $e');
      return false;
    }
  }

  Future<String?> getAuthHeaderToken() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      return 'Bearer $token';
    }
    return null;
  }

  // ================== 새로 추가: 사용자 ID 관리 ==================

  /// 사용자 ID 저장
  Future<bool> saveUserId(int userId) async {
    try {
      return await StorageUtils.setInt(_userIdKey, userId);
    } catch (e) {
      _logger.e('사용자 ID 저장 오류: $e');
      return false;
    }
  }

  /// 사용자 ID 조회
  Future<int?> getUserId() async {
    try {
      final userId = await StorageUtils.getInt(_userIdKey);
      return userId == 0 ? null : userId; // 0은 기본값이므로 null로 처리
    } catch (e) {
      _logger.e('사용자 ID 로드 오류: $e');
      return null;
    }
  }

  /// 사용자 ID 삭제
  Future<bool> clearUserId() async {
    try {
      return await StorageUtils.setInt(_userIdKey, 0);
    } catch (e) {
      _logger.e('사용자 ID 삭제 오류: $e');
      return false;
    }
  }

  // ================== 사용자 정보 관리 ==================

  Future<bool> saveUserInfo(Map<String, dynamic> userInfo) async {
    try {
      return await StorageUtils.saveSession(userInfo);
    } catch (e) {
      _logger.e('사용자 정보 저장 오류: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      return await StorageUtils.getSession();
    } catch (e) {
      _logger.e('사용자 정보 로드 오류: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ================== Remember Me 관리 ==================

  Future<bool> saveCredentials({required String loginId, required String password}) async {
    try {
      return await StorageUtils.saveCredentials(loginId: loginId, password: password);
    } catch (e) {
      _logger.e('로그인 정보 저장 오류: $e');
      return false;
    }
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    try {
      return await StorageUtils.getSavedCredentials();
    } catch (e) {
      _logger.e('로그인 정보 로드 오류: $e');
      return null;
    }
  }

  Future<bool> setRememberMe(bool remember) async {
    try {
      return await StorageUtils.setRememberMe(remember);
    } catch (e) {
      _logger.e('Remember Me 저장 오류: $e');
      return false;
    }
  }

  Future<bool> getRememberMe() async {
    try {
      return await StorageUtils.getRememberMe();
    } catch (e) {
      _logger.e('Remember Me 로드 오류: $e');
      return false;
    }
  }

  Future<bool> clearSavedCredentials() async {
    try {
      return await StorageUtils.clearSavedCredentials();
    } catch (e) {
      _logger.e('로그인 정보 삭제 오류: $e');
      return false;
    }
  }

  // ================== 새로 추가: 전체 로그아웃 처리 ==================

  /// 로그아웃 (토큰, 사용자 ID, 세션 정보 모두 삭제)
  Future<bool> logout() async {
    try {
      final results = await Future.wait([
        clearToken(),
        clearUserId(),
        StorageUtils.clearSession(),
      ]);

      final allSuccess = results.every((result) => result);

      if (allSuccess) {
        _logger.d('로그아웃 완료');
      } else {
        _logger.e('일부 로그아웃 처리 실패');
      }

      return allSuccess;
    } catch (e) {
      _logger.e('로그아웃 오류: $e');
      return false;
    }
  }
}