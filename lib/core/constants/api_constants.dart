/// API 관련 상수 정의
class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://server.tunnel.jaram.net';
}

/// API 엔드포인트 상수
class ApiEndpoints {
  // 회원가입
  static const String userJoin = '/api/user/join';

  // 로그인
  static const String userLogin = '/api/user/login';

  // OAuth 소셜 로그인
  static const String oauthAuthorization = '/api/user/oauth2/authorization';

  /// OAuth 제공자별 로그인 URL 생성
  static String getOAuthUrl(String provider) {
    return '$oauthAuthorization/$provider';
  }
}