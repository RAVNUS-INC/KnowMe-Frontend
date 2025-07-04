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

  // ✅ 새로 추가: 현재 로그인된 사용자 정보 조회
  static const String userMe = '/api/user/me';

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
  static const String employeePosts = '/api/posts/employee';

  // 인턴 공고 조회(페이징)
  static const String internPosts = '/api/posts/intern';

  // 대외활동 안내 조회(페이징)
  static const String externalPosts = '/api/posts/external';

  // 교육/강연 안내 조회(페이징)
  static const String lecturePosts = '/api/posts/lecture';

  // 공모전 안내 조회(페이징)
  static const String contestPosts = '/api/posts/contest';

  /// 저장 기능
  // Posts 저장하기
  static const String postSavedPosts = '/api/savedpost/{user_id}/{post_id}';
  // Posts 저장된 목록 조회
  static const String getSavedPosts = '/api/savedpost/user/{user_id}';
  // Posts 저장된 목록 삭제
  static const String deleteSavedPosts = '/api/savedpost/{savedpost_id}';

  /// ✅ 새로 추가: 모든 공고 상세 URL 생성 (채용, 인턴, 대외활동, 교육/강연, 공모전 통합)
  static String getPostDetailUrl(int postId) => '/api/posts/$postId';
}