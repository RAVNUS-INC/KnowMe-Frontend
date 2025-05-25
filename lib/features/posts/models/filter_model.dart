
/// 슬라이더 설정을 위한 모델 클래스
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

/// 필터 선택 값을 저장하는 모델 클래스
class FilterValues {
  final String? job;
  final String? location;
  final String? education;
  final String? period;
  final String? organization;
  final String? host;
  final String? target;
  final String? benefit;
  final String? onOffline;
  
  FilterValues({
    this.job,
    this.location,
    this.education,
    this.period,
    this.organization,
    this.host,
    this.target,
    this.benefit,
    this.onOffline,
  });
}
