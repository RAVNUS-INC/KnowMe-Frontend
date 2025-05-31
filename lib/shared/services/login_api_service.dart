import '../../../shared/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../features/membership/models/login_dtos.dart';

/// 로그인 API 서비스
class LoginApiService {
  final ApiClient _apiClient = ApiClient();

  /// 로그인
  Future<ApiResponse<LoginResponseDto>> login(LoginRequestDto request) async {
    return await _apiClient.post<LoginResponseDto>(
      ApiEndpoints.userLogin,
      body: request.toJson(),
      fromJson: (json) => LoginResponseDto.fromJson(json),
    );
  }
}