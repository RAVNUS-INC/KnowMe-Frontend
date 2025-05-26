class Contest {
  final int id;
  final String title;
  final String organization;
  final String imageUrl;
  final String dateRange;
  final String location;
  final String field;
  final String? additionalInfo;
  final String? target;
  final String? benefit;

  Contest({
    required this.id,
    required this.title,
    required this.organization,
    required this.imageUrl,
    required this.dateRange,
    required this.location,
    required this.field,
    this.additionalInfo,
    this.target,
    this.benefit,
  });
}
