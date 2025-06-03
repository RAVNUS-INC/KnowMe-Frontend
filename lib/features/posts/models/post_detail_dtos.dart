/// 공고 상세 정보 DTO (모든 공고 타입 통합)
import 'dart:convert';
class PostDetailDto {
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

  // ✅ 새로 추가: 파싱된 컨텐츠 정보
  late final PostContentInfo? parsedContent;

  PostDetailDto({
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
  }) {
    // content JSON 파싱
    parsedContent = _parseContent(content);
  }

  factory PostDetailDto.fromJson(Map<String, dynamic> json) {
    return PostDetailDto(
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

  /// ✅ content JSON 파싱 메서드 - 단순하고 안전한 버전
  PostContentInfo? _parseContent(String contentJson) {
    if (contentJson.isEmpty) return null;

    try {
      print('=== JSON 파싱 시도 ===');
      print('JSON 길이: ${contentJson.length}');

      // 직접 jsonDecode 시도
      final decoded = jsonDecode(contentJson);

      if (decoded is Map<String, dynamic>) {
        print('JSON 파싱 성공! 키들: ${decoded.keys.toList()}');
        return PostContentInfo.fromJson(decoded);
      } else {
        print('JSON이 Map이 아님: ${decoded.runtimeType}');
        return null;
      }

    } catch (e) {
      print('JSON 파싱 실패: $e');
      print('문제가 된 JSON 일부: ${contentJson.substring(0, contentJson.length > 200 ? 200 : contentJson.length)}');

      // 파싱 실패해도 앱이 크래시되지 않도록 null 반환
      return null;
    }
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

  /// 경력을 문자열로 포맷하는 메서드
  String get formattedExperience {
    if (experience == 0) {
      return '신입';
    } else if (experience <= 3) {
      return '${experience}년 이하';
    } else if (experience <= 5) {
      return '3~5년';
    } else {
      return '${experience}년 이상';
    }
  }

  /// 활동 기간을 문자열로 포맷하는 메서드
  String get formattedActivityDuration {
    if (activityDuration == 0) {
      return '기간 미정';
    } else if (activityDuration <= 30) {
      return '${activityDuration}일';
    } else if (activityDuration <= 365) {
      final months = (activityDuration / 30).round();
      return '${months}개월';
    } else {
      final years = (activityDuration / 365).round();
      return '${years}년';
    }
  }

  /// 이미지 URL 검증
  String get validImageUrl {
    if (image.isNotEmpty &&
        (image.startsWith('http://') || image.startsWith('https://'))) {
      return image;
    }
    return 'assets/images/whitepage.svg';
  }

  /// 공고 타입에 따른 주요 정보 반환
  String get primaryInfo {
    switch (category.toLowerCase()) {
      case '채용':
      case 'job':
        return '$jobTitle • $formattedExperience';
      case '인턴':
      case 'internship':
        return '$jobTitle • $formattedActivityDuration';
      case '대외활동':
      case 'activity':
        return '$activityField • $hostingOrganization';
      case '교육':
      case '강연':
      case 'education':
        return '$activityField • $onlineOrOffline';
      case '공모전':
      case 'contest':
        return '$activityField • $contestBenefits';
      default:
        return '$activityField • $location';
    }
  }

  @override
  String toString() {
    return 'PostDetailDto(postId: $postId, title: $title, category: $category, company: $company)';
  }
}

/// ✅ 새로 추가: 파싱된 컨텐츠 정보 클래스 (서버 응답에 맞춰 수정)
class PostContentInfo {
  final List<RecruitmentPart>? recruitmentPart; // ✅ List로 변경
  final WorkConditions? workConditions;
  final String? benefits;
  final String? recruitmentProcess;
  final String? applicationMethod;
  final String? externalInfo;
  final String? externalTimeAndLocation;
  final String? externalProcess;

  PostContentInfo({
    this.recruitmentPart,
    this.workConditions,
    this.benefits,
    this.recruitmentProcess,
    this.applicationMethod,
    this.externalInfo,
    this.externalTimeAndLocation,
    this.externalProcess,
  });

  factory PostContentInfo.fromJson(Map<String, dynamic> json) {
    return PostContentInfo(
      recruitmentPart: json['recruitment_part'] != null
          ? (json['recruitment_part'] as List)
          .map((item) => RecruitmentPart.fromJson(item))
          .toList()
          : null,
      workConditions: json['work_conditions'] != null
          ? WorkConditions.fromJson(json['work_conditions'])
          : null,
      benefits: json['benefits'],
      recruitmentProcess: json['recruitment_process'],
      applicationMethod: json['application_method'],
      externalInfo: json['external_info'],
      externalTimeAndLocation: json['external_time_and_location'],
      externalProcess: json['external_process'],
    );
  }
}

/// 모집 부문 정보 (서버 응답에 맞춰 수정)
class RecruitmentPart {
  final String? role; // ✅ jobTitle → role로 변경
  final String? jobResponsibilities;
  final String? qualifications;
  final String? preferredSkills;

  RecruitmentPart({
    this.role,
    this.jobResponsibilities,
    this.qualifications,
    this.preferredSkills,
  });

  factory RecruitmentPart.fromJson(Map<String, dynamic> json) {
    return RecruitmentPart(
      role: json['role'], // ✅ role 필드 사용
      jobResponsibilities: json['job_responsibilities'],
      qualifications: json['qualifications'],
      preferredSkills: json['preferred_skills'],
    );
  }
}

/// 근무 조건 (서버 응답에 맞춰 수정)
class WorkConditions {
  final String? employmentType;
  final String? workType;
  final String? location;

  WorkConditions({
    this.employmentType,
    this.workType,
    this.location,
  });

  factory WorkConditions.fromJson(Map<String, dynamic> json) {
    return WorkConditions(
      employmentType: json['employment_type'],
      workType: json['work_type'],
      location: json['location'],
    );
  }
}