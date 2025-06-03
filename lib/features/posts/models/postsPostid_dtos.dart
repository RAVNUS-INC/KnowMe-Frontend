/// 게시물 API 응답 DTO
class PostResponseDto {
  final int postId;
  final String category;
  final String title;
  final String company;
  final String location;
  final String? employmentType;
  final ApplicationPeriodDto? applicationPeriod;
  final String description;
  final List<String>? requirements;
  final List<String>? benefits;
  final List<AttachmentDto>? attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? jobTitle;
  final int? experience;
  final String? education;
  final String? activityField;
  final int? activityDuration;
  final String? hostingOrganization;
  final String? onlineOrOffline;
  final String? targetAudience;
  final String? contestBenefits;

  PostResponseDto({
    required this.postId,
    required this.category,
    required this.title,
    required this.company,
    required this.location,
    this.employmentType,
    this.applicationPeriod,
    required this.description,
    this.requirements,
    this.benefits,
    this.attachments,
    required this.createdAt,
    required this.updatedAt,
    this.jobTitle,
    this.experience,
    this.education,
    this.activityField,
    this.activityDuration,
    this.hostingOrganization,
    this.onlineOrOffline,
    this.targetAudience,
    this.contestBenefits,
  });

  factory PostResponseDto.fromJson(Map<String, dynamic> json) {
    return PostResponseDto(
      postId: json['post_id'],
      category: json['category'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      employmentType: json['employment_type'],
      applicationPeriod: json['applicationPeriod'] != null 
          ? ApplicationPeriodDto.fromJson(json['applicationPeriod'])
          : null,
      description: json['description'],
      requirements: json['requirements'] != null 
          ? List<String>.from(json['requirements'])
          : null,
      benefits: json['benefits'] != null 
          ? List<String>.from(json['benefits'])
          : null,
      attachments: json['attachments'] != null 
          ? (json['attachments'] as List)
              .map((item) => AttachmentDto.fromJson(item))
              .toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
}

/// 게시물 생성/수정 요청 DTO
class PostRequestDto {
  final String category;
  final String title;
  final String company;
  final String location;
  final String? employmentType;
  final ApplicationPeriodDto? applicationPeriod;
  final String description;
  final List<String>? requirements;
  final List<String>? benefits;
  final List<AttachmentDto>? attachments;
  final String? jobTitle;
  final int? experience;
  final String? education;
  final String? activityField;
  final int? activityDuration;
  final String? hostingOrganization;
  final String? onlineOrOffline;
  final String? targetAudience;
  final String? contestBenefits;

  PostRequestDto({
    required this.category,
    required this.title,
    required this.company,
    required this.location,
    this.employmentType,
    this.applicationPeriod,
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
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['title'] = title;
    data['company'] = company;
    data['location'] = location;
    
    if (employmentType != null) data['employment_type'] = employmentType;
    if (applicationPeriod != null) data['applicationPeriod'] = applicationPeriod!.toJson();
    
    data['description'] = description;
    
    if (requirements != null) data['requirements'] = requirements;
    if (benefits != null) data['benefits'] = benefits;
    if (attachments != null) {
      data['attachments'] = attachments!.map((attachment) => attachment.toJson()).toList();
    }
    
    if (jobTitle != null) data['jobTitle'] = jobTitle;
    if (experience != null) data['experience'] = experience;
    if (education != null) data['education'] = education;
    if (activityField != null) data['activityField'] = activityField;
    if (activityDuration != null) data['activityDuration'] = activityDuration;
    if (hostingOrganization != null) data['hostingOrganization'] = hostingOrganization;
    if (onlineOrOffline != null) data['onlineOrOffline'] = onlineOrOffline;
    if (targetAudience != null) data['targetAudience'] = targetAudience;
    if (contestBenefits != null) data['contestBenefits'] = contestBenefits;
    
    return data;
  }
}

/// 지원 기간 DTO
class ApplicationPeriodDto {
  final String startDate;
  final String endDate;

  ApplicationPeriodDto({
    required this.startDate,
    required this.endDate,
  });

  factory ApplicationPeriodDto.fromJson(Map<String, dynamic> json) {
    return ApplicationPeriodDto(
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

/// 첨부파일 DTO
class AttachmentDto {
  final String fileName;
  final String url;

  AttachmentDto({
    required this.fileName,
    required this.url,
  });

  factory AttachmentDto.fromJson(Map<String, dynamic> json) {
    return AttachmentDto(
      fileName: json['fileName'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'url': url,
    };
  }
}
