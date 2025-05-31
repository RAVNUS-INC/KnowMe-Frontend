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

/// 로그인 응답 DTO
class LoginResponseDto {
  final String result;  // status -> result로 변경
  final String message;
  final String? data; // JWT 토큰 (성공시에만)

  LoginResponseDto({
    required this.result,
    required this.message,
    this.data,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      result: json['result'] ?? '',
      message: json['message'] ?? '',
      data: json['data'], // 실패시에는 null일 수 있음
    );
  }

  /// 로그인 성공 여부 확인
  bool get isSuccess => result == 'success';

  /// JWT 토큰 반환 (성공시에만)
  String get token => data ?? '';
}