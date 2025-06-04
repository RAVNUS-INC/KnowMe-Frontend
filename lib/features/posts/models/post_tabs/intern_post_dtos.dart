// import 'package:knowme_frontend/features/posts/models/contests_model.dart';
//
//
// // 인턴 공고 모델
// class InternPost {
//   final int postId;
//   final String category;
//   final String title;
//   final String company;
//   final String companyIntro;
//   final String externalIntro;
//   final String content;
//   final String image;
//   final String location;
//   final String jobTitle; // 직무,
//   final int experience; // 학력
//   final String education;
//   final String activityField;
//   final int activityDuration; // 기간, 경력
//   final String hostingOrganization;
//   final String onlineOrOffline;
//   final String targetAudience;
//   final String contestBenefits;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   InternPost({
//     required this.postId,
//     required this.category,
//     required this.title,
//     required this.company,
//     required this.companyIntro,
//     required this.externalIntro,
//     required this.content,
//     required this.image,
//     required this.location,
//     required this.jobTitle,
//     required this.experience,
//     required this.education,
//     required this.activityField,
//     required this.activityDuration,
//     required this.hostingOrganization,
//     required this.onlineOrOffline,
//     required this.targetAudience,
//     required this.contestBenefits,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory InternPost.fromJson(Map<String, dynamic> json) {
//     return InternPost(
//       postId: json['post_id'] ?? 0,
//       category: json['category'] ?? '',
//       title: json['title'] ?? '',
//       company: json['company'] ?? '',
//       companyIntro: json['company_intro'] ?? '',
//       externalIntro: json['external_intro'] ?? '',
//       content: json['content'] ?? '',
//       image: json['image'] ?? '',
//       location: json['location'] ?? '',
//       jobTitle: json['jobTitle'] ?? '',
//       experience: json['experience'] ?? 0,
//       education: json['education'] ?? '',
//       activityField: json['activityField'] ?? '',
//       activityDuration: json['activityDuration'] ?? 0,
//       hostingOrganization: json['hostingOrganization'] ?? '',
//       onlineOrOffline: json['onlineOrOffline'] ?? '',
//       targetAudience: json['targetAudience'] ?? '',
//       contestBenefits: json['contestBenefits'] ?? '',
//       createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
//       updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'post_id': postId,
//       'category': category,
//       'title': title,
//       'company': company,
//       'company_intro': companyIntro,
//       'external_intro': externalIntro,
//       'content': content,
//       'image': image,
//       'location': location, // 위치
//       'jobTitle': jobTitle, // 직무
//       'experience': experience, // 경력
//       'education': education, // 학력
//       'activityField': activityField, // 분야
//       'activityDuration': activityDuration, // 기간
//       'hostingOrganization': hostingOrganization, // 주최 기관
//       'onlineOrOffline': onlineOrOffline, // 온라인/오프라인 여부
//       'targetAudience': targetAudience, // 대상
//       'contestBenefits': contestBenefits, // 혜택
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//     };
//   }
//
//   // Contest 모델로 변환하는 메서드 (기존 UI와 호환성을 위해)
//   Contest toContest() {
//     return Contest(
//       id: postId.toString(),
//       title: title,
//       benefit: contestBenefits.isNotEmpty ? contestBenefits : '혜택 정보 없음',
//       target: targetAudience.isNotEmpty ? targetAudience : education,
//       imageUrl: _getValidImageUrl(),  // ✅ 새로운 메서드 사용
//       organization: company,
//       location: location,
//       field: jobTitle,
//       dateRange: _formatExperience(experience),
//       additionalInfo: content,
//       type: ActivityType.job,
//       company: company,
//     );
//   }
//
//   String _getValidImageUrl() {
//     // 이미지가 있고 HTTP URL인 경우에만 사용
//     if (image.isNotEmpty &&
//         (image.startsWith('http://') || image.startsWith('https://'))) {
//       return image;
//     }
//
//     // 없거나 유효하지 않으면 기본 이미지 사용
//     return 'assets/images/whitepage.svg';
//   }
//
//   // 기간을 문자열로 포맷하는 메서드
//   String _formatExperience(int exp) {
//
//     // 기간을 월 단위로 가정
//     if (exp == 1) {
//       return '1개월 이하';
//     } else if (exp >= 1 && exp < 6) {
//       return '1~6개월';
//     } else if (exp >= 6 && exp < 12) {
//       return '6개월~1년';
//     } else if (exp >= 12 && exp < 18) {
//       return '1~1.5년';
//     } else if (exp >= 18 && exp < 24) {
//       return '1.5~2년';
//     } else {
//       return '2년 이상';
//     }
//   }
//
//   @override
//   String toString() {
//     return 'InternPost(postId: $postId, title: $title, company: $company, jobTitle: $jobTitle, experience: $experience, location: $location)';
//   }
// }
import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import 'package:knowme_frontend/features/posts/models/post_tabs/basepost_model.dart';

// 인턴 공고 모델
class InternPost extends BasePost {
  InternPost({
    required int postId,
    required String category,
    required String title,
    required String company,
    required String companyIntro,
    required String externalIntro,
    required String content,
    required String image,
    required String location,
    required String jobTitle,
    required int experience,
    required String education,
    required String activityField,
    required int activityDuration,
    required String hostingOrganization,
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

  factory InternPost.fromJson(Map<String, dynamic> json) {
    return InternPost(
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
      organization: company,
      location: location,
      field: jobTitle,
      dateRange: _formatExperience(experience),
      additionalInfo: content,
      type: ActivityType.job,
      company: company,
    );
  }

  String _formatExperience(int exp) {
    if (exp == 1) return '1개월 이하';
    if (exp >= 1 && exp < 6) return '1~6개월';
    if (exp >= 6 && exp < 12) return '6개월~1년';
    if (exp >= 12 && exp < 18) return '1~1.5년';
    if (exp >= 18 && exp < 24) return '1.5~2년';
    return '2년 이상';
  }
}
