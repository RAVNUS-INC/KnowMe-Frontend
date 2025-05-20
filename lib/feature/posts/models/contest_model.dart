class Contest {
  final String id;
  final String title;
  final String imageUrl;
  final String benefit;
  final String target;
  final String field;
  final String organizer;
  
  Contest({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.benefit,
    required this.target,
    required this.field,
    required this.organizer,
  });
  
  // JSON에서 객체로 변환
  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'] ?? 'https://placehold.co/164x164',
      benefit: json['benefit'] ?? '',
      target: json['target'] ?? '제한없음',
      field: json['field'] ?? '',
      organizer: json['organizer'] ?? '',
    );
  }
}

// 공모전 상세 정보를 위한 모델
class ContestDetail {
  final String id;
  final String title;
  final String imageUrl;
  final String companyName;
  final String description;
  final String field;
  final String target;
  final String benefit;
  final String organizer;
  final List<String> eligibility;
  final List<String> requirements;
  final List<String> preferredSkills;
  final List<String> workingConditions;
  final List<String> benefits;
  final String processDescription;
  final String applicationMethod;
  final String applicationDeadline;
  
  ContestDetail({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.companyName,
    required this.description,
    required this.field,
    required this.target,
    required this.benefit,
    required this.organizer,
    required this.eligibility,
    required this.requirements,
    required this.preferredSkills,
    required this.workingConditions,
    required this.benefits,
    required this.processDescription,
    required this.applicationMethod,
    required this.applicationDeadline,
  });
  
  // JSON에서 객체로 변환
  factory ContestDetail.fromJson(Map<String, dynamic> json) {
    return ContestDetail(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'] ?? 'https://placehold.co/164x164',
      companyName: json['company_name'] ?? '',
      description: json['description'] ?? '',
      field: json['field'] ?? '',
      target: json['target'] ?? '제한없음',
      benefit: json['benefit'] ?? '',
      organizer: json['organizer'] ?? '',
      eligibility: List<String>.from(json['eligibility'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      preferredSkills: List<String>.from(json['preferred_skills'] ?? []),
      workingConditions: List<String>.from(json['working_conditions'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      processDescription: json['process_description'] ?? '',
      applicationMethod: json['application_method'] ?? '',
      applicationDeadline: json['application_deadline'] ?? '',
    );
  }
}
