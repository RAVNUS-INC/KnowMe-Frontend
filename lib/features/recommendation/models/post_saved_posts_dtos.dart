import 'package:flutter/foundation.dart';

/// 활동 저장 요청 DTO
class SavePostRequest {
  final int postId; // 저장할 포스트 ID
  final String userId;

  SavePostRequest({
    required this.userId,
    required this.postId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
    };
  }

  @override
  String toString() => 'SavePostRequest(userId: $userId, postId: $postId)';
}

/// 저장된 활동 응답 DTO
class SavedPostDTO {
  final int id; // 저장한 활동 ID
  final int userId;
  final SavedPostDetailDTO post;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedPostDTO({
    required this.id,
    required this.userId,
    required this.post,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavedPostDTO.fromJson(Map<String, dynamic> json) {
    return SavedPostDTO(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      post: SavedPostDetailDTO.fromJson(json['post'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'post': post.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SavedPostDTO(id: $id, userId: $userId, post: $post, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// 저장된 포스트의 상세 정보 DTO
class SavedPostDetailDTO {
  final int postId;
  final String category;
  final String title;
  final String company;
  final String companyIntro;
  final String externalIntro;
  final String content;
  final String image;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? jobTitle;
  final int experience;
  final String education;
  final String activityField;
  final int activityDuration;
  final String hostingOrganization;
  final String onlineOrOffline;
  final String targetAudience;
  final String contestBenefits;

  SavedPostDetailDTO({
    required this.postId,
    required this.category,
    required this.title,
    required this.company,
    required this.companyIntro,
    required this.externalIntro,
    required this.content,
    required this.image,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    this.jobTitle,
    required this.experience,
    required this.education,
    required this.activityField,
    required this.activityDuration,
    required this.hostingOrganization,
    required this.onlineOrOffline,
    required this.targetAudience,
    required this.contestBenefits,
  });

  factory SavedPostDetailDTO.fromJson(Map<String, dynamic> json) {
    return SavedPostDetailDTO(
      postId: json['post_id'] ?? 0,
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      companyIntro: json['company_intro'] ?? '',
      externalIntro: json['external_intro'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      jobTitle: json['jobTitle'],
      experience: json['experience'] ?? 0,
      education: json['education'] ?? '',
      activityField: json['activityField'] ?? '',
      activityDuration: json['activityDuration'] ?? 0,
      hostingOrganization: json['hostingOrganization'] ?? '',
      onlineOrOffline: json['onlineOrOffline'] ?? '',
      targetAudience: json['targetAudience'] ?? '',
      contestBenefits: json['contestBenefits'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'category': category,
      'title': title,
      'company': company,
      'company_intro': companyIntro,
      'external_intro': externalIntro,
      'content': content,
      'image': image,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'jobTitle': jobTitle,
      'experience': experience,
      'education': education,
      'activityField': activityField,
      'activityDuration': activityDuration,
      'hostingOrganization': hostingOrganization,
      'onlineOrOffline': onlineOrOffline,
      'targetAudience': targetAudience,
      'contestBenefits': contestBenefits,
    };
  }

  @override
  String toString() {
    return 'SavedPostDetailDTO(postId: $postId, title: $title, company: $company)';
  }
}
