class FilterValues {
  final String? jobTitle;
  final String? experience;
  final String? location;
  final String? education;
  final List<String>? activityField;
  final String? activityDuration;
  final List<String>? hostingOrganization;
  final List<String>? targetAudience;
  final List<String>? contestBenefits;
  final List<String>? onlineOrOffline;

  FilterValues({
    this.jobTitle,
    this.experience,
    this.location,
    this.education,
    this.activityField,
    this.activityDuration,
    this.hostingOrganization,
    this.targetAudience,
    this.contestBenefits,
    this.onlineOrOffline,
  });
}

class SliderConfig {
  final double min;
  final double max;
  final int divisions;
  final List<double> steps;
  final String startLabel;
  final String endLabel;
  final bool isMonth;

  SliderConfig({
    required this.min,
    required this.max,
    required this.divisions,
    required this.steps,
    required this.startLabel,
    required this.endLabel,
    this.isMonth = false,
  });
}
