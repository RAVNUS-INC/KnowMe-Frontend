// 로그인 관련 DTO 정의

/// 로그인 요청 DTO
class LoginRequestDto {
  final String loginId;  // 서버에서 실제로 요구하는 필드명
  final String password;

  LoginRequestDto({
    required this.loginId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,  // 서버 DTO에 맞춰 loginId 사용
      'password': password,
    };
  }
}

/// 로그인 응답 DTO (✅ 서버 응답 형식에 맞춰 수정)
class LoginResponseDto {
  final String result;   // "login access"
  final String message;  // "Authentication successful"
  final String? access;  // JWT 토큰

  LoginResponseDto({
    required this.result,
    required this.message,
    this.access,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      result: json['result'] ?? '',
      message: json['message'] ?? '',
      access: json['access'], // 'data' 대신 'access' 사용
    );
  }

  /// ✅ 수정: 로그인 성공 여부 확인
  bool get isSuccess {
    // 1. result가 "login access"이면 성공
    // 2. 또는 access 토큰이 있으면 성공
    return result == 'login access' ||
        (access != null && access!.isNotEmpty);
  }

  /// ✅ 수정: JWT 토큰 반환 (success와 관계없이 access 필드 사용)
  String get token => access ?? '';
}