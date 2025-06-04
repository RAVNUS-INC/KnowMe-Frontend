import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import 'package:knowme_frontend/features/posts/models/basepost_model.dart';

// 교육/강연 공고 모델
class EducationPost extends BasePost {
  EducationPost({
    required int postId,
    required String category,
    required String title,
    required String company,
    required String companyIntro,
    required String educationIntro,
    required String content,
    required String image,
    required String location, // 지역
    required String jobTitle,
    required int experience, 
    required String education,
    required String activityField, // 분야
    required int activityDuration, // 기간
    required String organizingInstitution, // 주관 기관
    required String onlineOrOffline, // 온/오프라인
    required String targetAudience,
    required String educationBenefits,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    postId: postId,
    category: category,
    title: title,
    company: company,
    companyIntro: companyIntro,
    externalIntro: educationIntro,
    content: content,
    image: image,
    location: location,
    jobTitle: jobTitle,
    experience: experience,
    education: education,
    activityField: activityField,
    activityDuration: activityDuration,
    hostingOrganization: organizingInstitution,
    onlineOrOffline: onlineOrOffline,
    targetAudience: targetAudience,
    contestBenefits: educationBenefits,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory EducationPost.fromJson(Map<String, dynamic> json) {
    return EducationPost(
      postId: json['post_id'] ?? 0,
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      companyIntro: json['company_intro'] ?? '',
      educationIntro: json['external_intro'] ?? '',  // ✅ JSON key 기준
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      experience: json['experience'] ?? 0,
      education: json['education'] ?? '',
      activityField: json['activityField'] ?? '',
      activityDuration: json['activityDuration'] ?? 0,
      organizingInstitution: json['hostingOrganization'] ?? '', // ✅ JSON 기준으로 수정
      onlineOrOffline: json['onlineOrOffline'] ?? '',
      targetAudience: json['targetAudience'] ?? '',
      educationBenefits: json['contestBenefits'] ?? '', // ✅ JSON 기준으로 수정
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
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
      'education_intro': externalIntro,
      'content': content,
      'image': image,
      'location': location,
      'jobTitle': jobTitle,
      'experience': experience,
      'education': education,
      'activityField': activityField,
      'activityDuration': activityDuration,
      'organizingInstitution': hostingOrganization,
      'onlineOrOffline': onlineOrOffline,
      'targetAudience': targetAudience,
      'educationBenefits': contestBenefits,
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
      organization: hostingOrganization, // 주관기관
      location: location, // 지역
      field: activityField, // 분야
      dateRange: _formatActivityDuration(activityDuration), // 기간
      additionalInfo: onlineOrOffline, // 온/오프라인
      type: ActivityType.course, // education 대신 course로 변경
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
    return 'EducationPost(postId: $postId, title: $title, organization: $hostingOrganization, field: $activityField, duration: $activityDuration, location: $location)';
  }
}
