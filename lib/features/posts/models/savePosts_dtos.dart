/// 저장된 공고 응답 DTO
class SavedPostResponseDto {
  final int id;
  final UserDto user;
  final SavedPostDto post;

  SavedPostResponseDto({
    required this.id,
    required this.user,
    required this.post,
  });

  factory SavedPostResponseDto.fromJson(Map<String, dynamic> json) {
    return SavedPostResponseDto(
      id: json['id'] as int,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      post: SavedPostDto.fromJson(json['post'] as Map<String, dynamic>),
    );
  }
}

/// 저장된 공고 내의 게시물 DTO
class SavedPostDto {
  final int postId;
  final String category;
  final String title;
  final String company;
  final String location;
  final String? employmentType;
  final String? startDate;
  final String? endDate;
  final String description;
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

  SavedPostDto({
    required this.postId,
    required this.category,
    required this.title,
    required this.company,
    required this.location,
    this.employmentType,
    this.startDate,
    this.endDate,
    required this.description,
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

  factory SavedPostDto.fromJson(Map<String, dynamic> json) {
    return SavedPostDto(
      postId: json['post_id'] as int,
      category: json['category'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      employmentType: json['employment_type'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      jobTitle: json['jobTitle'] as String?,
      experience: json['experience'] as int?,
      education: json['education'] as String?,
      activityField: json['activityField'] as String?,
      activityDuration: json['activityDuration'] as int?,
      hostingOrganization: json['hostingOrganization'] as String?,
      onlineOrOffline: json['onlineOrOffline'] as String?,
      targetAudience: json['targetAudience'] as String?,
      contestBenefits: json['contestBenefits'] as String?,
    );
  }
}

/// 사용자 DTO
class UserDto {
  final int id;
  final String? loginId;
  final String? name;
  final String? password;
  final String? role;
  final String? phone;
  final String? email;
  final int? grade;
  final String? provider;
  final String? providerId;
  final List<EducationDto>? educations;
  final List<ProjectDto>? projects;
  final List<ExperienceDto>? experiences;
  final List<UserSkillMapDto>? userSkillMaps;

  UserDto({
    required this.id,
    this.loginId,
    this.name,
    this.password,
    this.role,
    this.phone,
    this.email,
    this.grade,
    this.provider,
    this.providerId,
    this.educations,
    this.projects,
    this.experiences,
    this.userSkillMaps,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      loginId: json['loginId'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      grade: json['grade'] as int?,
      provider: json['provider'] as String?,
      providerId: json['providerId'] as String?,
      educations: json['educations'] != null
          ? (json['educations'] as List)
              .map((e) => EducationDto.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      projects: json['projects'] != null
          ? (json['projects'] as List)
              .map((e) => ProjectDto.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      experiences: json['experiences'] != null
          ? (json['experiences'] as List)
              .map((e) => ExperienceDto.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      userSkillMaps: json['userSkillMaps'] != null
          ? (json['userSkillMaps'] as List)
              .map((e) => UserSkillMapDto.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

/// 교육 DTO
class EducationDto {
  final int id;
  final String? grade;
  final String? school;
  final String? major;
  final String? user;

  EducationDto({
    required this.id,
    this.grade,
    this.school,
    this.major,
    this.user,
  });

  factory EducationDto.fromJson(Map<String, dynamic> json) {
    return EducationDto(
      id: json['id'] as int,
      grade: json['grade'] as String?,
      school: json['school'] as String?,
      major: json['major'] as String?,
      user: json['user'] as String?,
    );
  }
}

/// 프로젝트 DTO
class ProjectDto {
  final int id;
  final String? title;
  final String? description;
  final String? url;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? user;

  ProjectDto({
    required this.id,
    this.title,
    this.description,
    this.url,
    this.startDate,
    this.endDate,
    this.user,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      id: json['id'] as int,
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      user: json['user'] as String?,
    );
  }
}

/// 경력 DTO
class ExperienceDto {
  final int id;
  final String? companyName;
  final String? title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? user;

  ExperienceDto({
    required this.id,
    this.companyName,
    this.title,
    this.startDate,
    this.endDate,
    this.user,
  });

  factory ExperienceDto.fromJson(Map<String, dynamic> json) {
    return ExperienceDto(
      id: json['id'] as int,
      companyName: json['company_name'] as String?,
      title: json['title'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      user: json['user'] as String?,
    );
  }
}

/// 사용자 스킬 매핑 DTO
class UserSkillMapDto {
  final int id;
  final String? level;
  final String? user;
  final SkillTagDto? skillTag;

  UserSkillMapDto({
    required this.id,
    this.level,
    this.user,
    this.skillTag,
  });

  factory UserSkillMapDto.fromJson(Map<String, dynamic> json) {
    return UserSkillMapDto(
      id: json['id'] as int,
      level: json['level'] as String?,
      user: json['user'] as String?,
      skillTag: json['skillTag'] != null
          ? SkillTagDto.fromJson(json['skillTag'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// 스킬 태그 DTO
class SkillTagDto {
  final int id;
  final String? skillName;
  final List<String>? userSkillMap;

  SkillTagDto({
    required this.id,
    this.skillName,
    this.userSkillMap,
  });

  factory SkillTagDto.fromJson(Map<String, dynamic> json) {
    return SkillTagDto(
      id: json['id'] as int,
      skillName: json['skill_name'] as String?,
      userSkillMap: json['userSkillMap'] != null
          ? List<String>.from(json['userSkillMap'])
          : null,
    );
  }
}

/// 저장된 공고를 추가하기 위한 요청 DTO
class SavePostRequestDto {
  final int userId;
  final int postId;

  SavePostRequestDto({
    required this.userId,
    required this.postId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
    };
  }
}

/// 저장된 공고를 삭제하기 위한 요청 DTO
class DeleteSavedPostRequestDto {
  final int savedPostId;

  DeleteSavedPostRequestDto({
    required this.savedPostId,
  });
}
