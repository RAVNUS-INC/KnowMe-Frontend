import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import 'package:knowme_frontend/features/posts/models/post_tabs/basepost_model.dart';

/// 공모전 공고 모델
class ContestPost extends BasePost {
  // 분야, 대상, 주최기관, 혜택
  ContestPost({
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
    required String activityField, // 분야
    required int activityDuration,
    required String hostingOrganization, // 주최 기관
    required String onlineOrOffline,
    required String targetAudience, // 대상
    required String contestBenefits, // 혜택
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

  /// JSON으로부터 ContestPost 객체 생성
  factory ContestPost.fromJson(Map<String, dynamic> json) {
    return ContestPost(
      postId: json['post_id'] as int? ?? 0,
      category: json['category'] as String? ?? '공모전',
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      companyIntro: json['company_intro'] as String? ?? '',
      externalIntro: json['external_intro'] as String? ?? '',
      content: json['content'] as String? ?? '',
      image: json['image'] as String? ?? '',
      location: json['location'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      experience: json['experience'] as int? ?? 0,
      education: json['education'] as String? ?? '',
      activityField: json['activity_field'] as String? ?? '',
      activityDuration: json['activity_duration'] as int? ?? 0,
      hostingOrganization: json['hosting_organization'] as String? ?? '',
      onlineOrOffline: json['online_or_offline'] as String? ?? '',
      targetAudience: json['target_audience'] as String? ?? '',
      contestBenefits: json['contest_benefits'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }


  @override
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'category': category,
      'title': title,
      'company': company,
      'companyIntro': companyIntro,
      'externalIntro': externalIntro,
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  Contest toContest() {
    return Contest(
      id: postId.toString(),
      title: title,
      organization: hostingOrganization,
      imageUrl: getValidImageUrl(),
      dateRange: _formatDateRange(createdAt, activityDuration),
      location: location,
      field: activityField,
      additionalInfo: onlineOrOffline,
      target: targetAudience,
      benefit: contestBenefits,
    );
    /*@override
  Contest toContest() {
    return Contest(
      id: postId.toString(),
      title: title,
      benefit: contestBenefits.isNotEmpty ? contestBenefits : '혜택 정보 없음',
      target: targetAudience,
      organization: hostingOrganization, // employee에선 company였지만, 공모전에서는 hostingOrganization
      imageUrl: super.getValidImageUrl(),
      dateRange: _formatDateRange(createdAt, activityDuration),
      location: location,
      field: activityField,
      additionalInfo: onlineOrOffline,
    );
  } */
  }

  /// 날짜 표시 포맷팅 헬퍼 메서드
  String _formatDateRange(DateTime startDate, int durationMonths) {
    // 시작일
    String start = '${startDate.year}.${startDate.month.toString().padLeft(2, '0')}.${startDate.day.toString().padLeft(2, '0')}';
    
    // 종료일 (시작일 + 기간)
    DateTime endDate = DateTime(
      startDate.year,
      startDate.month + durationMonths,
      startDate.day,
    );
    String end = '${endDate.year}.${endDate.month.toString().padLeft(2, '0')}.${endDate.day.toString().padLeft(2, '0')}';
    
    return '$start ~ $end';
  }

  @override
  String toString() {
    return 'ContestPost(postId: $postId, title: $title, hostingOrganization: $hostingOrganization, targetAudience: $targetAudience, activityField: $activityField)';
  }
}
