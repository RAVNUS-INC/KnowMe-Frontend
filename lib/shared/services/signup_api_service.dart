import 'api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../features/membership/models/signup_dtos.dart';

/// 회원가입 API 서비스
class SignupApiService {
  final ApiClient _apiClient = ApiClient();

  /// 회원가입
  Future<ApiResponse<SignupResponseDto>> signup(SignupRequestDto request) async {
    return await _apiClient.post<SignupResponseDto>(
      ApiEndpoints.userJoin,
      body: request.toJson(),
      fromJson: (json) => SignupResponseDto.fromJson(json),
    );
  }
}