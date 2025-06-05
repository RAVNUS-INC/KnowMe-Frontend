/// 활동 저장 요청 DTO
class SavePostRequest {
  final int postId; // 저장할 포스트 ID

  SavePostRequest({
    required this.postId,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
    };
  }

  @override
  String toString() => 'SavePostRequest(postId: $postId)';
}


/// 저장된 활동 응답 DTO
class SavePostResponse {
  final int id; // 저장한 활동 ID
  final int userId;
  final PostDto post;


  SavePostResponse({
    required this.id,
    required this.userId,
    required this.post,

  });

  factory SavePostResponse.fromJson(Map<String, dynamic> json) {
    try {
      // 필수 필드부터 안전하게 가져옵니다
      int id = json['id'] ?? 0;
      int userId = 0;

      // user 객체가 있으면 userId를 추출
      if (json['user'] != null && json['user'] is Map<String, dynamic>) {
        userId = json['user']['id'] ?? 0;
      } else {
        userId = json['userId'] ?? 0;
      }

      // post 객체가 복잡하거나 없는 경우를 대비
      PostDto postDetail;
      if (json['post'] != null && json['post'] is Map<String, dynamic>) {
        postDetail = PostDto.fromJson(json['post']);
      } else {
        // empty() 메서드 대신 기본 생성자 직접 호출
        postDetail = PostDto(postId: 0);
      }

      return SavePostResponse(
        id: id,
        userId: userId,
        post: postDetail,
      );
    } catch (e) {
      // 예외 발생 시 기본 객체 반환
      return SavePostResponse(
        id: 0,
        userId: 0,
        // empty() 메서드 대신 기본 생성자 직접 호출
        post: PostDto(postId: 1),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'post': post.toJson(),
    };
  }

  @override
  String toString() {
    return 'SavedPostDTO(id: $id, userId: $userId, post: $post)';
  }
}
class PostDto {
  final int postId;

  PostDto({
    required this.postId,
  });
  
  // empty 팩토리 메서드 추가
  factory PostDto.empty() {
    return PostDto(
      postId: 1,
    );
  }

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      postId: json['post_id'] ?? json['id'] ?? json['postId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
    };
  }

  @override
  String toString() {
    return 'PostDto(postId: $postId,)';
  }
}
