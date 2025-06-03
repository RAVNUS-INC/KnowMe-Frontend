/// post API 관련 상수 정의
class PostApiConstants {
  // Base URL
  static const String baseUrl = 'http://server.tunnel.jaram.net';

  // 추천 관련 엔드포인트
  static const String savedPosts = '/api/users/me/bookmarks';
  static const String recommendedPosts = '/api/recommendations/posts';
  static const String bookmarkPost = '/api/posts/bookmark';
  static const String unbookmarkPost = '/api/posts/unbookmark';
}

// 서현 - 활동 조회, 활동 기입하기
// 지민 - 검색어로 공고 조회   여기다가 입력해서 쓰면 될 듯 (다 posts 부분이라)

/// post API 엔드포인트 상수
/// =============== 게시물 관련 API 엔드포인트 ==================
class PostApiEndpoints {
  // 게시물 CRUD
  static const String postsPostid = '/api/posts/{postid}';

  // 전체 공고 조회
  static const String postsAll = '/api/posts/';

  /// =============== 게시물 조회 관련 ==================
  // 채용 공고 조회(페이징)
  static const String postsEmployee = '/api/posts/employee';

  // 인턴 공고 조회(페이징)
  static const String postsIntern = '/api/posts/intern';

  // 대외활동 안내 조회(페이징)
  static const String postsExternal = '/api/posts/external';

  // 교육/강연 안내 조회(페이징)
  static const String postsLecture = '/api/posts/lecture';

  // 공모전 안내 조회(페이징)
  static const String postsContest = '/api/posts/contest';

  /// =============== 저장 쪽 ==================
  // 저장하고 싶은 공고 저장
  static const String savedPostSave = '/api/savedpost/{user_id}/{post_id}';

  // 저장하고 싶은 공고 조회
  static const String savedPostInquiry = '/api/savedpost/user/{user_id}';

  // 저장하고 싶은 공고 삭제
  static const String savedPostDelete = '/api/savedpost/{savedpost_id}';

  // 저장된 게시물 관련 엔드포인트
  static const String savedPosts = '/api/saved-posts';
  static const String recommendedPosts = '/api/recommended-posts';
}
