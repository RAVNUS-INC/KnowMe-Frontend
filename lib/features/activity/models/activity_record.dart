class Project {
  final String title, description, date;
  final String? summary;
  final List<String> tags;

  const Project({
    required this.title,
    required this.description,
    required this.tags,
    required this.date,
    this.summary,
  });
}
