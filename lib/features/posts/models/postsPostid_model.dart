import 'package:knowme_frontend/features/posts/models/postsPostid_dtos.dart';

/// 게시물 모델 클래스
class PostModel {
  // 게시물 CRUD 모델에만 있는 거
  final int? id;
  final ApplicationPeriod? applicationPeriod;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // 전체 공고 조회에만 있는 거 ////////추가
  final String? startDate;
  final String? endDate;
  
  // 게시물 model에서 공통으로 있는 거
  final String category;
  final String title;
  final String company;
  final String location;
  final String? employmentType;
  final String description;
  final List<String>? requirements;
  final List<String>? benefits;
  final List<Attachment>? attachments;
  final String? jobTitle;
  final int? experience;
  final String? education;
  final String? activityField;
  final int? activityDuration;
  final String? hostingOrganization;
  final String? onlineOrOffline;
  final String? targetAudience;
  final String? contestBenefits;
  
  bool isSaved;

  PostModel({
    // 게시물 CRUD 모델에만 있는 거
    this.id,
    this.applicationPeriod,
    this.createdAt,
    this.updatedAt,
    
    // 전체 공고 조회에만 있는 거
    this.startDate,
    this.endDate,
    
    // 게시물 model에서 공통으로 있는 거
    required this.category,
    required this.title,
    required this.company,
    required this.location,
    this.employmentType,
    required this.description,
    this.requirements,
    this.benefits,
    this.attachments,
    this.jobTitle,
    this.experience,
    this.education,
    this.activityField,
    this.activityDuration,
    this.hostingOrganization,
    this.onlineOrOffline,
    this.targetAudience,
    this.contestBenefits,
    this.isSaved = false,
  });

  // DTO에서 모델로 변환
  factory PostModel.fromDto(PostResponseDto dto) {
    return PostModel(
      // 게시물 CRUD 모델에만 있는 거
      id: dto.postId,
      applicationPeriod: dto.applicationPeriod != null
          ? ApplicationPeriod(
              startDate: DateTime.parse(dto.applicationPeriod!.startDate),
              endDate: DateTime.parse(dto.applicationPeriod!.endDate),
            )
          : null,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      
      // 게시물 model에서 공통으로 있는 거
      category: dto.category,
      title: dto.title,
      company: dto.company,
      location: dto.location,
      employmentType: dto.employmentType,
      description: dto.description,
      requirements: dto.requirements,
      benefits: dto.benefits,
      attachments: dto.attachments?.map((e) => Attachment(
        fileName: e.fileName, 
        url: e.url
      )).toList(),
      jobTitle: dto.jobTitle,
      experience: dto.experience,
      education: dto.education,
      activityField: dto.activityField,
      activityDuration: dto.activityDuration,
      hostingOrganization: dto.hostingOrganization,
      onlineOrOffline: dto.onlineOrOffline,
      targetAudience: dto.targetAudience,
      contestBenefits: dto.contestBenefits,
      
      // 전체 공고 조회에만 있는 거
      startDate: dto.applicationPeriod?.startDate,
      endDate: dto.applicationPeriod?.endDate,
    );
  }

  // API 응답 JSON에서 직접 모델 생성 (전체 공고 조회용)
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['post_id'],
      category: json['category'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      employmentType: json['employment_type'],
      description: json['description'],
      
      // nullable 처리
      requirements: json['requirements'] != null 
          ? List<String>.from(json['requirements'])
          : null,
      benefits: json['benefits'] != null 
          ? List<String>.from(json['benefits'])
          : null,
      attachments: json['attachments'] != null 
          ? (json['attachments'] as List)
              .map((item) => Attachment(
                  fileName: item['fileName'],
                  url: item['url'],
                ))
              .toList()
          : null,
      
      // DateTime으로 변환
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'])
          : null,
          
      // 애플리케이션 기간 처리
      applicationPeriod: json['applicationPeriod'] != null
          ? ApplicationPeriod(
              startDate: DateTime.parse(json['applicationPeriod']['start_date']),
              endDate: DateTime.parse(json['applicationPeriod']['end_date']),
            )
          : null,
      
      // 날짜 문자열 직접 저장 (전체 공고 조회용)
      startDate: json['applicationPeriod']?['start_date'],
      endDate: json['applicationPeriod']?['end_date'],
      
      jobTitle: json['jobTitle'],
      experience: json['experience'],
      education: json['education'],
      activityField: json['activityField'],
      activityDuration: json['activityDuration'],
      hostingOrganization: json['hostingOrganization'],
      onlineOrOffline: json['onlineOrOffline'],
      targetAudience: json['targetAudience'],
      contestBenefits: json['contestBenefits'],
    );
  }

  // 모델에서 요청 DTO로 변환
  PostRequestDto toRequestDto() {
    return PostRequestDto(
      category: category,
      title: title,
      company: company,
      location: location,
      employmentType: employmentType,
      applicationPeriod: applicationPeriod != null 
          ? ApplicationPeriodDto(
              startDate: applicationPeriod!.startDate.toIso8601String().split('T')[0],
              endDate: applicationPeriod!.endDate.toIso8601String().split('T')[0],
            )
          : null,
      description: description,
      requirements: requirements,
      benefits: benefits,
      attachments: attachments?.map((e) => AttachmentDto(
        fileName: e.fileName, 
        url: e.url
      )).toList(),
      jobTitle: jobTitle,
      experience: experience,
      education: education,
      activityField: activityField,
      activityDuration: activityDuration,
      hostingOrganization: hostingOrganization,
      onlineOrOffline: onlineOrOffline,
      targetAudience: targetAudience,
      contestBenefits: contestBenefits,
    );
  }

  // 복제 메서드
  PostModel copyWith({
    bool? isSaved,
    String? startDate,
    String? endDate,
  }) {
    return PostModel(
      id: id,
      category: category,
      title: title,
      company: company,
      location: location,
      employmentType: employmentType,
      applicationPeriod: applicationPeriod,
      description: description,
      requirements: requirements,
      benefits: benefits,
      attachments: attachments,
      createdAt: createdAt,
      updatedAt: updatedAt,
      jobTitle: jobTitle,
      experience: experience,
      education: education,
      activityField: activityField,
      activityDuration: activityDuration,
      hostingOrganization: hostingOrganization,
      onlineOrOffline: onlineOrOffline,
      targetAudience: targetAudience,
      contestBenefits: contestBenefits,
      isSaved: isSaved ?? this.isSaved,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

/// 지원 기간 모델
class ApplicationPeriod {
  final DateTime startDate;
  final DateTime endDate;

  ApplicationPeriod({
    required this.startDate,
    required this.endDate,
  });
}

/// 첨부파일 모델
class Attachment {
  final String fileName;
  final String url;

  Attachment({
    required this.fileName,
    required this.url,
  });
}
