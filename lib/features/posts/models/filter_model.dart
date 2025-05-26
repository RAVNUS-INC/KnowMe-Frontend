class FilterValues {
  final String? job;
  final String? experience;
  final String? location;
  final String? education; // 단일 선택용
  final List<String>? educationList; // 다중 선택용
  final String? period;
  final List<String>? host; // 항상 List<String> 타입 사용
  final List<String>? target; // 항상 List<String> 타입 사용
  final List<String>? organizer; // 항상 List<String> 타입 사용
  final List<String>? benefit; // 항상 List<String> 타입 사용
  final List<String>? onOffline; // 항상 List<String> 타입 사용

  FilterValues({
    this.job,
    this.experience,
    this.location,
    this.education,
    this.educationList,
    this.period,
    this.host,
    this.target,
    this.organizer,
    this.benefit,
    this.onOffline,
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
