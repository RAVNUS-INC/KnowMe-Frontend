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

  // 아이디 찾기 (새로 추가)
  static const String findId = '/api/user/findId';

  // OAuth 소셜 로그인
  static const String oauthAuthorization = '/api/user/oauth2/authorization';

  /// OAuth 제공자별 로그인 URL 생성
  static String getOAuthUrl(String provider) {
    return '$oauthAuthorization/$provider';
  }

  // 회원정보 조회
  static String getUserInfoUrl(String userId) => '/api/users/$userId';

  // 회원정보 수정
  static String getUserEditUrl(String userId) => '/api/users/edit/$userId';

  // 비밀번호 수정
  static const String editPassword = '/api/user/editPassword';

  /// ============== posts 관련 ===============
  // 채용 공고 관련
  static const String employeePosts = '/api/posts/employee'; // 인범오빠가 해줌

  // 인턴 공고 조회(페이징)
  static const String Internposts = '/api/posts/intern'; // 완

  // 대외활동 안내 조회(페이징)
  static const String Externalposts = '/api/posts/external';

  // 교육/강연 안내 조회(페이징)
  static const String Lectureposts = '/api/posts/lecture';

  // 공모전 안내 조회(페이징)
  static const String Contestposts = '/api/posts/contest';
  //

  /// ✅ 새로 추가: 모든 공고 상세 URL 생성 (채용, 인턴, 대외활동, 교육/강연, 공모전 통합)
  static String getPostDetailUrl(int postId) => '/api/posts/$postId';
}