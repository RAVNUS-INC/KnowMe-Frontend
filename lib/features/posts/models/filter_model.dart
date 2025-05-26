// 슬라이더 설정을 위한 모델
class SliderConfig {
  final double min;
  final double max;
  final int divisions;
  final List<double> steps;
  final String startLabel;
  final String endLabel;
  final bool isMonth; // 개월 단위 여부

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

// 필터 값들을 담는 모델
class FilterValues {
  final String? job; // 직무 또는 분야
  final String? experience; // 경력 (채용)
  final String? location; // 지역
  final String? education; // 학력
  final String? period; // 기간 (인턴, 대외활동, 교육/강연)
  final String? host; // 주최기관 (대외활동)
  final String? onOffline; // 온/오프라인 (교육/강연)
  final String? target; // 대상 (공모전)
  final String? organizer; // 주최기관 (공모전)
  final String? benefit; // 혜택 (공모전)

  FilterValues({
    this.job,
    this.experience,
    this.location,
    this.education,
    this.period,
    this.host,
    this.onOffline,
    this.target,
    this.organizer,
    this.benefit,
  });
}
