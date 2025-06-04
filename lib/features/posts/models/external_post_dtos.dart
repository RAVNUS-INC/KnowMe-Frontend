import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import 'package:knowme_frontend/features/posts/models/basepost_model.dart';

// 대외활동 공고 모델
class ExternalPost extends BasePost {
  ExternalPost({
    required int postId,
    required String category,
    required String title,
    required String company,
    required String companyIntro,
    required String externalIntro,
    required String content,
    required String image,
    required String location, // 지역
    required String jobTitle,
    required int experience, // 경력
    required String education,
    required String activityField, // 분야
    required int activityDuration, // 기간
    required String hostingOrganization, // 주최 기관
    required String onlineOrOffline,
    required String targetAudience,
    required String contestBenefits,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    postId: postId,
    category: category,
    title: title,
    company: company,
    companyIntro: companyIntro,
    externalIntro: externalIntro,
    content: content,
    image: image,
    location: location,
    jobTitle: jobTitle,
    experience: experience,
    education: education,
    activityField: activityField,
    activityDuration: activityDuration,
    hostingOrganization: hostingOrganization,
    onlineOrOffline: onlineOrOffline,
    targetAudience: targetAudience,
    contestBenefits: contestBenefits,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ExternalPost.fromJson(Map<String, dynamic> json) {
    return ExternalPost(
      postId: json['post_id'] ?? 0,
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      companyIntro: json['company_intro'] ?? '',
      externalIntro: json['external_intro'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      experience: json['experience'] ?? 0,
      education: json['education'] ?? '',
      activityField: json['activityField'] ?? '',
      activityDuration: json['activityDuration'] ?? 0,
      hostingOrganization: json['hostingOrganization'] ?? '',
      onlineOrOffline: json['onlineOrOffline'] ?? '',
      targetAudience: json['targetAudience'] ?? '',
      contestBenefits: json['contestBenefits'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  @override
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
      'jobTitle': jobTitle,
      'experience': experience,
      'education': education,
      'activityField': activityField,
      'activityDuration': activityDuration,
      'hostingOrganization': hostingOrganization,
      'onlineOrOffline': onlineOrOffline,
      'targetAudience': targetAudience,
      'contestBenefits': contestBenefits,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  Contest toContest() {
    return Contest(
      id: postId.toString(),
      title: title,
      benefit: contestBenefits.isNotEmpty ? contestBenefits : '혜택 정보 없음',
      target: targetAudience.isNotEmpty ? targetAudience : education,
      imageUrl: super.getValidImageUrl(),
      organization: hostingOrganization, // 주최기관
      location: location, // 지역
      field: activityField, // 분야
      dateRange: _formatActivityDuration(activityDuration), // 기간
      additionalInfo: content,
      type: ActivityType.activity,
      company: company,
    );
  }

  String _formatActivityDuration(int duration) {
    if (duration <= 1) return '1개월';
    if (duration <= 3) return '3개월';
    if (duration <= 6) return '6개월';
    if (duration <= 12) return '12개월';
    return '$duration개월';
  }

  @override
  String toString() {
    return 'ExternalPost(postId: $postId, title: $title, organization: $hostingOrganization, field: $activityField, duration: $activityDuration, location: $location)';
  }
}
