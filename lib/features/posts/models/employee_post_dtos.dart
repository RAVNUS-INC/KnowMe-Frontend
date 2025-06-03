import 'package:knowme_frontend/features/posts/models/contests_model.dart';

// 채용 공고 모델
class EmployeePost {
  final int postId;
  final String category;
  final String title;
  final String company;
  final String companyIntro;
  final String externalIntro;
  final String content;
  final String image;
  final String location;
  final String jobTitle;
  final int experience;
  final String education;
  final String activityField;
  final int activityDuration;
  final String hostingOrganization;
  final String onlineOrOffline;
  final String targetAudience;
  final String contestBenefits;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmployeePost({
    required this.postId,
    required this.category,
    required this.title,
    required this.company,
    required this.companyIntro,
    required this.externalIntro,
    required this.content,
    required this.image,
    required this.location,
    required this.jobTitle,
    required this.experience,
    required this.education,
    required this.activityField,
    required this.activityDuration,
    required this.hostingOrganization,
    required this.onlineOrOffline,
    required this.targetAudience,
    required this.contestBenefits,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeePost.fromJson(Map<String, dynamic> json) {
    return EmployeePost(
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

  // Contest 모델로 변환하는 메서드 (기존 UI와 호환성을 위해)
  Contest toContest() {
    return Contest(
      id: postId.toString(),
      title: title,
      benefit: contestBenefits.isNotEmpty ? contestBenefits : '혜택 정보 없음',
      target: targetAudience.isNotEmpty ? targetAudience : education,
      imageUrl: _getValidImageUrl(),  // ✅ 새로운 메서드 사용
      organization: company,
      location: location,
      field: jobTitle,
      dateRange: _formatExperience(experience),
      additionalInfo: content,
      type: ActivityType.job,
      company: company,
    );
  }

  String _getValidImageUrl() {
    // 이미지가 있고 HTTP URL인 경우에만 사용
    if (image.isNotEmpty &&
        (image.startsWith('http://') || image.startsWith('https://'))) {
      return image;
    }

    // 없거나 유효하지 않으면 기본 이미지 사용
    return 'assets/images/whitepage.svg';
  }

  // 경력을 문자열로 포맷하는 메서드
  String _formatExperience(int exp) {
    if (exp == 0) {
      return '신입';
    } else if (exp <= 3) {
      return '${exp}년 이하';
    } else if (exp <= 5) {
      return '3~5년';
    } else {
      return '${exp}년 이상';
    }
  }

  @override
  String toString() {
    return 'EmployeePost(postId: $postId, title: $title, company: $company, jobTitle: $jobTitle, experience: $experience, location: $location)';
  }
}