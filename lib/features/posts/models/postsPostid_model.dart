import 'package:knowme_frontend/features/posts/models/postsPostid_dtos.dart';
import 'package:knowme_frontend/features/posts/models/savePosts_dtos.dart';

/// 게시물 모델 클래스
class PostModel {
  // 게시물 CRUD 모델에만 있는 거
  final int? post_id; // 게시물 ID
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

  /*
  * job -> jobTitle,
    experience-> experience
      educationList -> activityField,
      period -> activityDuration,
      host,organizer -> hostingOrganization,
      target -> targetAudience,
      benefit -> contestBenefits,
      onOffline -> onlineOrOffline
      * */
  // 저장된 공고 관련 필드
  final UserModel? savedByUser;

  PostModel({
    // 게시물 CRUD 모델에만 있는 거
    this.post_id,
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
    
    // 저장된 공고 관련 필드
    this.savedByUser,
  });

  // DTO에서 모델로 변환
  factory PostModel.fromDto(PostResponseDto dto) {
    return PostModel(
      // 게시물 CRUD 모델에만 있는 거
      post_id: dto.postId,
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
      post_id: json['post_id'],
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

  // 저장된 공고 DTO에서 모델로 변환
  factory PostModel.fromSavedPostDto(SavedPostResponseDto dto) {
    return PostModel(
      post_id: dto.post.postId,
      category: dto.post.category,
      title: dto.post.title,
      company: dto.post.company,
      location: dto.post.location,
      employmentType: dto.post.employmentType,
      description: dto.post.description,
      
      // 날짜 필드 직접 문자열로 저장
      startDate: dto.post.startDate,
      endDate: dto.post.endDate,
      
      // DateTime 변환
      createdAt: dto.post.createdAt,
      updatedAt: dto.post.updatedAt,
      
      jobTitle: dto.post.jobTitle,
      experience: dto.post.experience,
      education: dto.post.education,
      activityField: dto.post.activityField,
      activityDuration: dto.post.activityDuration,
      hostingOrganization: dto.post.hostingOrganization,
      onlineOrOffline: dto.post.onlineOrOffline,
      targetAudience: dto.post.targetAudience,
      contestBenefits: dto.post.contestBenefits,
      
      // 저장된 공고이므로 true로 설정
      isSaved: true,
      
      // 저장한 사용자 정보
      savedByUser: UserModel.fromUserDto(dto.user),
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
    UserModel? savedByUser,
  }) {
    return PostModel(
      post_id: post_id,
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
      savedByUser: savedByUser ?? this.savedByUser,
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

/// 사용자 모델
class UserModel {
  final int? id;
  final String? loginId;
  final String? name;
  final String? role;
  final String? phone;
  final String? email;
  final int? grade;
  final String? provider;
  final String? providerId;
  final List<EducationModel>? educations;
  final List<ProjectModel>? projects;
  final List<ExperienceModel>? experiences;
  final List<UserSkillMapModel>? userSkillMaps;

  UserModel({
    this.id,
    this.loginId,
    this.name,
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

  factory UserModel.fromUserDto(UserDto dto) {
    return UserModel(
      id: dto.id,
      loginId: dto.loginId,
      name: dto.name,
      role: dto.role,
      phone: dto.phone,
      email: dto.email,
      grade: dto.grade,
      provider: dto.provider,
      providerId: dto.providerId,
      educations: dto.educations?.map((e) => EducationModel.fromEducationDto(e)).toList(),
      projects: dto.projects?.map((p) => ProjectModel.fromProjectDto(p)).toList(),
      experiences: dto.experiences?.map((e) => ExperienceModel.fromExperienceDto(e)).toList(),
      userSkillMaps: dto.userSkillMaps?.map((s) => UserSkillMapModel.fromUserSkillMapDto(s)).toList(),
    );
  }
}

/// 교육 모델
class EducationModel {
  final int? id;
  final String? grade;
  final String? school;
  final String? major;

  EducationModel({
    this.id,
    this.grade,
    this.school,
    this.major,
  });

  factory EducationModel.fromEducationDto(EducationDto dto) {
    return EducationModel(
      id: dto.id,
      grade: dto.grade,
      school: dto.school,
      major: dto.major,
    );
  }
}

/// 프로젝트 모델
class ProjectModel {
  final int? id;
  final String? title;
  final String? description;
  final String? url;
  final DateTime? startDate;
  final DateTime? endDate;

  ProjectModel({
    this.id,
    this.title,
    this.description,
    this.url,
    this.startDate,
    this.endDate,
  });

  factory ProjectModel.fromProjectDto(ProjectDto dto) {
    return ProjectModel(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      url: dto.url,
      startDate: dto.startDate,
      endDate: dto.endDate,
    );
  }
}

/// 경력 모델
class ExperienceModel {
  final int? id;
  final String? companyName;
  final String? title;
  final DateTime? startDate;
  final DateTime? endDate;

  ExperienceModel({
    this.id,
    this.companyName,
    this.title,
    this.startDate,
    this.endDate,
  });

  factory ExperienceModel.fromExperienceDto(ExperienceDto dto) {
    return ExperienceModel(
      id: dto.id,
      companyName: dto.companyName,
      title: dto.title,
      startDate: dto.startDate,
      endDate: dto.endDate,
    );
  }
}

/// 사용자 스킬 매핑 모델
class UserSkillMapModel {
  final int? id;
  final String? level;
  final SkillTagModel? skillTag;

  UserSkillMapModel({
    this.id,
    this.level,
    this.skillTag,
  });

  factory UserSkillMapModel.fromUserSkillMapDto(UserSkillMapDto dto) {
    return UserSkillMapModel(
      id: dto.id,
      level: dto.level,
      skillTag: dto.skillTag != null ? SkillTagModel.fromSkillTagDto(dto.skillTag!) : null,
    );
  }
}

/// 스킬 태그 모델
class SkillTagModel {
  final int? id;
  final String? skillName;

  SkillTagModel({
    this.id,
    this.skillName,
  });

  factory SkillTagModel.fromSkillTagDto(SkillTagDto dto) {
    return SkillTagModel(
      id: dto.id,
      skillName: dto.skillName,
    );
  }
}
