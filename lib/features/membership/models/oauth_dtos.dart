// OAuth 소셜 로그인 관련 DTO 정의

/// OAuth 로그인 응답 DTO
class OAuthResponseDto {
  final String status;
  final String message;
  final String? data;

  OAuthResponseDto({
    required this.status,
    required this.message,
    this.data,
  });

  factory OAuthResponseDto.fromJson(Map<String, dynamic> json) {
    return OAuthResponseDto(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  /// OAuth 로그인 성공 여부 확인
  bool get isSuccess => status == '100 CONTINUE';
}

/// OAuth 제공자 열거형
enum OAuthProvider {
  naver('naver'),
  google('google'),
  kakao('kakao');

  const OAuthProvider(this.value);
  final String value;
}