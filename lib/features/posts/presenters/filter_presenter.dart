import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/models/filter_model.dart';

/// 필터 관련 비즈니스 로직을 담당하는 Presenter 클래스
class FilterPresenter extends GetxController {
  final PostController _postController = Get.find<PostController>();

  // 슬라이더 설정 가져오기
  SliderConfig getSliderConfig(int tabIndex) {
    switch (tabIndex) {
      case 0: // 채용
        return SliderConfig(
          min: 0,
          max: 20,
          divisions: 4,
          steps: [0, 5, 10, 15, 20],
          startLabel: '신입',
          endLabel: '20년',
        );
      case 1: // 인턴
      case 2: // 대외활동
        return SliderConfig(
          min: 1,
          max: 24,
          divisions: 4,
          steps: [1, 6, 12, 18, 24],
          startLabel: '1개월',
          endLabel: '2년',
          isMonth: true,
        );
      case 3: // 교육/강연
        return SliderConfig(
          min: 1,
          max: 180,
          divisions: 4,
          steps: [1, 30, 60, 120, 180],
          startLabel: '1일',
          endLabel: '6개월',
        );
      default:
        return SliderConfig(
          min: 0,
          max: 20,
          divisions: 4,
          steps: [0, 5, 10, 15, 20],
          startLabel: '신입',
          endLabel: '20년',
        );
    }
  }

  // 탭 제목 가져오기
  String getTabTitle(int tabIndex) {
    switch (tabIndex) {
      case 0: return '채용';
      case 1: return '인턴';
      case 2: return '대외활동';
      case 3: return '교육/강연';
      case 4: return '공모전';
      default: return '필터';
    }
  }

  // 현재 필터 값 가져오기
  FilterValues getFilterValues(int tabIndex) {
    switch (tabIndex) {
      case 0: // 채용
        return FilterValues(
          job: _postController.selectedJob.value,
          experience: _postController.selectedExperience.value, // 추가(경력)
          location: _postController.selectedLocation.value,
          education: _postController.selectedEducation.value,
        );
      case 1: // 인턴
        return FilterValues(
          job: _postController.selectedInternJob.value,
          location: _postController.selectedInternLocation.value,
          education: _postController.selectedInternEducation.value,
          period: _postController.selectedPeriod.value,
        );
      case 2: // 대외활동
        return FilterValues(
          job: _postController.selectedField.value,
          location: _postController.selectedActivityLocation.value,
          period: _postController.selectedActivityPeriod.value,
          host: _postController.selectedHost.value, // 추가(주최기관)
        );
      case 3: // 교육/강연
        return FilterValues(
          job: _postController.selectedEduField.value,
          onOffline: _postController.selectedOnOffline.value, // 추가(온/오프라인)
          location: _postController.selectedEduLocation.value,
          period: _postController.selectedEduPeriod.value,
        );
      case 4: // 공모전
      default:
        return FilterValues(
          job: _postController.selectedContestField.value,
          target: _postController.selectedTarget.value, // 추가(대상)
          organizer: _postController.selectedOrganizer.value, // 추가(주최기관)
          benefit: _postController.selectedBenefit.value, // 추가(혜택)
        );
    }
  }

  // 슬라이더 값 가져오기
  RangeValues getSliderValues(int tabIndex) {
    SliderConfig config = getSliderConfig(tabIndex);
    double min = config.min;
    double max = config.max;
    double stepSize = (max - min) / 4; // 4 divisions = 5 steps

    switch (tabIndex) {
      case 0: // 채용
        if (_postController.selectedExperience.value != null) {
          final exp = _postController.selectedExperience.value!;
          if (exp == '신입') {
            return const RangeValues(0, 0);
          } else if (exp == '5년 이하') {
            return const RangeValues(0, 5);
          } else if (exp == '5~10년') {
            return const RangeValues(5, 10);
          } else if (exp == '10~15년') {
            return const RangeValues(10, 15);
          } else if (exp == '15년 이상') {
            return RangeValues(15, max);
          }
        }
        break;
      case 1: // 인턴
        if (_postController.selectedPeriod.value != null) {
          final period = _postController.selectedPeriod.value!;
          if (period == '1개월 이하') {
            return const RangeValues(1, 1);
          } else if (period == '1~6개월') {
            return const RangeValues(1, 6);
          } else if (period == '6개월~1년') {
            return const RangeValues(6, 12);
          } else if (period == '1~1.5년') {
            return const RangeValues(12, 18);
          } else if (period == '1.5년 이상') {
            return RangeValues(18, max);
          }
        }
        break;
      case 2: // 대외활동
        if (_postController.selectedActivityPeriod.value != null) {
          final period = _postController.selectedActivityPeriod.value!;
          if (period == '1개월 이하') {
            return const RangeValues(1, 1);
          } else if (period == '1~6개월') {
            return const RangeValues(1, 6);
          } else if (period == '6개월~1년') {
            return const RangeValues(6, 12);
          } else if (period == '1~1.5년') {
            return const RangeValues(12, 18);
          } else if (period == '1.5년 이상') {
            return RangeValues(18, max);
          }
        }
        break;
      case 3: // 교육/강연
        if (_postController.selectedEduPeriod.value != null) {
          final period = _postController.selectedEduPeriod.value!;
          if (period == '1일') {
            return const RangeValues(1, 1);
          } else if (period == '1일~1개월') {
            return const RangeValues(1, 30);
          } else if (period == '1~2개월') {
            return const RangeValues(30, 60);
          } else if (period == '2~4개월') {
            return const RangeValues(60, 120);
          } else if (period == '4~6개월') {
            return RangeValues(120, max);
          }
        }
        break;
    }

    // 기본값: 최소값부터 1/4 지점까지
    return RangeValues(min, min + stepSize);
  }

  // 슬라이더 라벨 포맷
  String formatSliderLabel(double value, int tabIndex) {
    switch (tabIndex) {
      case 0: // 채용
        if (value == 0) return '신입';
        return '${value.round()}년';
      case 1: // 인턴
      case 2: // 대외활동
        if (value < 12) {
          return '${value.round()}개월';
        } else if (value == 12) {
          return '1년';
        } else if (value == 18) {
          return '18개월';
        } else if (value == 24) {
          return '2년';
        } else {
          // 중간값을 개월 단위로 표시 (소수점 제거)
          return '${value.round()}개월';
        }
      case 3: // 교육/강연
        if (value == 1) {
          return '1일';
        } else if (value == 30) {
          return '1개월';
        } else if (value == 60) {
          return '2개월';
        } else if (value == 120) {
          return '4개월';
        } else if (value == 180) {
          return '6개월';
        } else {
          // 중간값 처리 - 일 단위로 표시하거나 개월 단위로 표시
          if (value < 30) {
            return '${value.round()}일';
          } else {
            // 개월 수를 계산하고 정수로 표시
            int months = (value / 30).round();
            return '${months}개월';
          }
        }
      default:
        return '${value.round()}';
    }
  }

  // 슬라이더 값 조정
  RangeValues adjustSliderValues(RangeValues values, SliderConfig config, RangeValues currentValues) {
    double min = config.min;
    double max = config.max;
    double stepSize = (max - min) / 4; // 4 divisions = 5 steps

    // 움직임을 stepSize(max*1/4) 단위로 조정
    double adjustedStart = ((values.start - min) / stepSize).round() * stepSize + min;
    double adjustedEnd = ((values.end - min) / stepSize).round() * stepSize + min;

    // 시작과 끝이 같아지지 않도록 (최소 한 단위 이상 차이 유지)
    if (adjustedStart == adjustedEnd) {
      // 오른쪽(end) 썸을 이동한 경우
      if (values.end != currentValues.end) {
        // 오른쪽 값을 한 단계 올림 (max를 초과하지 않도록)
        adjustedEnd = (adjustedEnd + stepSize > max) ? max : adjustedEnd + stepSize;
      } else {
        // 왼쪽 값을 한 단계 내림 (min 미만이 되지 않도록)
        adjustedStart = (adjustedStart - stepSize < min) ? min : adjustedStart - stepSize;
      }
    }

    return RangeValues(adjustedStart, adjustedEnd);
  }

  // 탭별 필터 초기화 메서드
  void resetFiltersForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // 채용
        _postController.selectedJob.value = null;
        _postController.selectedExperience.value = null;
        _postController.selectedLocation.value = null;
        _postController.selectedEducation.value = null;
        break;
      case 1: // 인턴
        _postController.selectedInternJob.value = null;
        _postController.selectedPeriod.value = null;
        _postController.selectedInternLocation.value = null;
        _postController.selectedInternEducation.value = null;
        break;
      case 2: // 대외활동
        _postController.selectedField.value = null;
        _postController.selectedActivityPeriod.value = null;
        _postController.selectedActivityLocation.value = null;
        _postController.selectedHost.value = null;
        break;
      case 3: // 교육/강연
        _postController.selectedEduField.value = null;
        _postController.selectedEduPeriod.value = null;
        _postController.selectedEduLocation.value = null;
        _postController.selectedOnOffline.value = null;
        break;
      case 4: // 공모전
        _postController.selectedContestField.value = null;
        _postController.selectedTarget.value = null;
        _postController.selectedOrganizer.value = null;
        _postController.selectedBenefit.value = null;
        break;
    }
  }

  // 필터 적용 메서드
  void applyFilters({
    required int tabIndex,
    required RangeValues rangeValues,
    String? job,
    String? location,
    String? education,
    String? period,
    // 추가 필터들 (원래 없었음)
    String? organization,
    String? host,
    String? target,
    String? benefit,
    String? onOffline,
    String? experience,
  }) {
    // 만약 모든 필터가 null이면 필터가 초기화된 상태로 간주
    bool isReset = job == null && location == null && education == null && period == null;

    if (isReset) {
      // 모든 필터가 초기화된 상태면 Controller의 값들도 모두 초기화
      resetFiltersForTab(tabIndex);
      return;
    }

    // 그렇지 않으면 기존 로직대로 진행
    switch (tabIndex) {
      case 0: // 채용
      // 직무 필터 적용
        if (job != null) {
          _postController.selectedJob.value = job;
        }

        // 경력 필터 적용 - 슬라이더 값에 따라 경력 범위 문자열로 변환
        String? experienceValue;
        if (rangeValues.start == 0 && rangeValues.end == 0) {
          experienceValue = '신입';
        } else if (rangeValues.start == 0 && rangeValues.end <= 5) {
          experienceValue = '5년 이하';
        } else if (rangeValues.start >= 5 && rangeValues.end <= 10) {
          experienceValue = '5~10년';
        } else if (rangeValues.start >= 10 && rangeValues.end <= 15) {
          experienceValue = '10~15년';
        } else if (rangeValues.start >= 15) {
          experienceValue = '15년 이상';
        }
        _postController.selectedExperience.value = experienceValue;

        // 지역 필터 적용
        if (location != null) {
          _postController.selectedLocation.value = location;
        }

        // 학력 필터 적용
        if (education != null) {
          _postController.selectedEducation.value = education;
        }
        break;

      case 1: // 인턴
      // 직무 필터 적용
        if (job != null) {
          _postController.selectedInternJob.value = job;
        }

        // 기간 필터 적용 - 레인지 슬라이더 값을 사용
        String? periodValue;
        if (rangeValues.end <= 1) {
          periodValue = '1개월 이하';
        } else if (rangeValues.end <= 6) {
          periodValue = '1~6개월';
        } else if (rangeValues.end <= 12) {
          periodValue = '6개월~1년';
        } else if (rangeValues.end <= 18) {
          periodValue = '1~1.5년';
        } else {
          periodValue = '1.5년 이상';
        }
        _postController.selectedPeriod.value = periodValue;

        // 지역 필터 적용
        if (location != null) {
          _postController.selectedInternLocation.value = location;
        }

        // 학력 필터 적용
        if (education != null) {
          _postController.selectedInternEducation.value = education;
        }
        break;

      case 2: // 대외활동
      // 분야 필터 적용
        if (job != null) {
          _postController.selectedField.value = job;
        }

        // 기간 필터 적용 - 인턴과 동일한 슬라이더 값 사용
        String? activityPeriodValue;
        if (rangeValues.end <= 1) {
          activityPeriodValue = '1개월 이하';
        } else if (rangeValues.end <= 6) {
          activityPeriodValue = '1~6개월';
        } else if (rangeValues.end <= 12) {
          activityPeriodValue = '6개월~1년';
        } else if (rangeValues.end <= 18) {
          activityPeriodValue = '1~1.5년';
        } else {
          activityPeriodValue = '1.5년 이상';
        }
        _postController.selectedActivityPeriod.value = activityPeriodValue;

        // 지역 필터 적용
        if (location != null) {
          _postController.selectedActivityLocation.value = location;
        }
        break;

      case 3: // 교육/강연
      // 분야 필터 적용
        if (job != null) {
          _postController.selectedEduField.value = job;
        }

        // 기간 필터 적용
        String? eduPeriodValue;
        if (rangeValues.end <= 1) {
          eduPeriodValue = '1일';
        } else if (rangeValues.end <= 30) {
          eduPeriodValue = '1일~1개월';
        } else if (rangeValues.end <= 60) {
          eduPeriodValue = '1~2개월';
        } else if (rangeValues.end <= 120) {
          eduPeriodValue = '2~4개월';
        } else {
          eduPeriodValue = '4~6개월';
        }
        _postController.selectedEduPeriod.value = eduPeriodValue;

        // 지역 필터 적용
        if (location != null) {
          _postController.selectedEduLocation.value = location;
        }
        break;

      case 4: // 공모전
      default:
      // 분야 필터 적용
        if (job != null) {
          _postController.selectedContestField.value = job;
        }
        break;
    }
  }

  // 멀티 셀렉트 필터 값 업데이트
  void updateMultiSelectValue(int tabIndex, String filterType, String option, bool isSelected) {
    switch (filterType) {
      case '대상':
        _postController.selectedTarget.value = isSelected ? null : option;
        break;
      case '주최기관':
        if (tabIndex == 4) {
          _postController.selectedOrganizer.value = isSelected ? null : option;
        } else {
          _postController.selectedHost.value = isSelected ? null : option;
        }
        break;
      case '혜택':
        _postController.selectedBenefit.value = isSelected ? null : option;
        break;
    }
  }

  // 온/오프라인 값 업데이트
  void updateOnOfflineValue(String value) {
    _postController.selectedOnOffline.value = value;
  }

  // Get selected values from controller
  String? getSelectedHost() => _postController.selectedHost.value;
  String? getSelectedTarget() => _postController.selectedTarget.value;
  String? getSelectedOrganizer() => _postController.selectedOrganizer.value;
  String? getSelectedBenefit() => _postController.selectedBenefit.value;
  String? getSelectedOnOffline() => _postController.selectedOnOffline.value;

  // 옵션 리스트 반환 메서드들
  List<String> getJobOptions(int tabIndex) {
    if (tabIndex == 0 || tabIndex == 1) { // 채용, 인턴
      return ['개발', '마케팅', '디자인', '기획', '영업', '경영/인사', '회계/재무', '연구/설계', '기타'];
    }
    return [];
  }

  List<String> getFieldOptions(int tabIndex) {
    if (tabIndex == 2) { // 대외활동
      return ['IT', '디자인', '마케팅', '경영', '공학', '스타트업', '미디어', '환경', '교육', '기타'];
    } else if (tabIndex == 3) { // 교육/강연
      return ['IT/개발', '디자인', '마케팅', '경영', '금융', '어학', '취업준비', '자격증', '취미', '기타'];
    } else if (tabIndex == 4) { // 공모전
      return ['IT', '디자인', '마케팅', '경영', '공학', '기타'];
    }
    return [];
  }

  List<String> getLocationOptions(int tabIndex) {
    if (tabIndex == 0) { // 채용
      return ['서울 전체', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
    } else if (tabIndex == 1) { // 인턴
      return ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
    } else if (tabIndex == 2) { // 대외활동
      return ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주', '온라인'];
    } else if (tabIndex == 3) { // 교육/강연
      return ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
    }
    return [];
  }

  List<String> getOrganizerOptions(int tabIndex) {
    if (tabIndex == 2) { // 대외활동
      return ['기업', '정부/공공기관', '학교', '협회', '민간단체', '기타'];
    } else if (tabIndex == 4) { // 공모전
      return ['기업', '정부/공공기관', '학교', '협회', '기타'];
    }
    return [];
  }

  List<String> getOnOfflineOptions() {
    return ['온라인', '오프라인', '혼합'];
  }

  List<String> getTargetOptions() {
    return ['대학생', '일반인', '청소년', '제한없음'];
  }

  List<String> getBenefitOptions() {
    return ['상금', '입사 가산점', '취업 연계', '해외연수', '기타'];
  }

  List<String> getEducationOptions() {
    return ['학력 전체', '고졸', '초대졸', '대졸', '석사/박사', '학력무관'];
  }

  // 다이얼로그에 표시할 옵션 가져오기
  List<String> getOptionsForDialog(int tabIndex, String title) {
    switch (tabIndex) {
      case 0: // 채용
        if (title == '직무') {
          return getJobOptions(0);
        } else if (title == '신입~5년') {
          return ['신입', '1년 이하', '1~3년', '3~5년', '5년 이상'];
        } else if (title == '서울 전체' || title == '지역') {
          return getLocationOptions(0);
        } else if (title == '학력') {
          return getEducationOptions();
        }
        break;

      case 1: // 인턴
        if (title == '직무') {
          return getJobOptions(1);
        } else if (title == '기간') {
          return ['1개월 이하', '1~3개월', '3~6개월', '6개월 이상'];
        } else if (title == '지역') {
          return getLocationOptions(1);
        } else if (title == '학력') {
          return getEducationOptions();
        }
        break;

      case 2: // 대외활동
        if (title == '분야') {
          return getFieldOptions(2);
        } else if (title == '기관') {
          return ['대학교', '기업', '정부기관', '비영리단체', '연구소', '기타'];
        } else if (title == '지역') {
          return getLocationOptions(2);
        } else if (title == '주최기관') {
          return getOrganizerOptions(2);
        }
        break;

      case 3: // 교육/강연
        if (title == '분야') {
          return getFieldOptions(3);
        } else if (title == '기간') {
          return ['1회성', '1개월 이하', '1~3개월', '3~6개월', '6개월 이상'];
        } else if (title == '지역') {
          return getLocationOptions(3);
        } else if (title == '온/오프라인') {
          return getOnOfflineOptions();
        }
        break;

      case 4: // 공모전
      default:
        if (title == '분야') {
          return getFieldOptions(4);
        } else if (title == '대상') {
          return getTargetOptions();
        } else if (title == '주최기관') {
          return getOrganizerOptions(4);
        } else if (title == '혜택') {
          return getBenefitOptions();
        }
        break;
    }
    return [];
  }
}
