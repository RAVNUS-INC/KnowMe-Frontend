class Contest {
  final int id;
  final String title;
  final String organization;
  final String imageUrl;
  final String dateRange;
  final String location;
  final String field;
  final String benefit;
  final String target;
  final String? additionalInfo; // 추가 정보만 nullable

  Contest({
    required this.id,
    required this.title,
    required this.organization,
    required this.imageUrl, 
    required this.dateRange,
    required this.location,
    required this.field,
    required this.benefit,
    required this.target,
    this.additionalInfo,
  });
}
