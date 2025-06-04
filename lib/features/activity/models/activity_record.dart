class ActivityResponse {
  final int userId;
  final List<Project> portfolios;

  const ActivityResponse({
    required this.userId,
    required this.portfolios,
  });
  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      userId: json['userId'] as int? ?? 0,
      portfolios: (json['portfolios'] as List?)
              ?.map((portfolio) => Project.fromJson(portfolio))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'portfolios': portfolios.map((portfolio) => portfolio.toJson()).toList(),
    };
  }
}

class Project {
  final int portfolioId;
  final String title;
  final String description;
  final String content;
  final String? visibility;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  const Project({
    required this.portfolioId,
    required this.title,
    required this.description,
    required this.content,
    this.visibility,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Project.fromJson(Map<String, dynamic> json) {
    // 서버에서 portfolioId, id, activityId 등 다양한 필드명을 시도
    int portfolioId = json['portfolioId'] as int? ??
        json['id'] as int? ??
        json['activityId'] as int? ??
        0;

    // portfolioId가 여전히 0이면 디버그 정보 출력
    if (portfolioId == 0) {
      print('Warning: portfolioId is 0. JSON keys: ${json.keys.toList()}');
      print('JSON data: $json');
    }

    return Project(
      portfolioId: portfolioId,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      visibility: json['visibility'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'portfolioId': portfolioId,
      'title': title,
      'description': description,
      'content': content,
      'visibility': visibility,
      'tags': tags,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ProjectDetail {
  final int id; // activityId
  final String title;
  final String description;
  final String content;
  final List<String> tags;
  final String? visibility;
  final String createdAt;
  final String updatedAt;

  const ProjectDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    this.visibility,
    required this.createdAt,
    required this.updatedAt,
  });
  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    return ProjectDetail(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      visibility: json['visibility'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'tags': tags,
      'visibility': visibility,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
