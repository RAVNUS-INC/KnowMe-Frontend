import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/models/filter_model.dart';

/// 필터 관련 비즈니스 로직을 담당하는 Controller 클래스
class FilterController extends GetxController {
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
          experience: _postController.selectedExperience.value,
          location: _postController.selectedLocation.value,
          education: _postController.selectedEducation.value,
          educationList: _postController.multiSelectEducation.toList(),
        );
      case 1: // 인턴
        return FilterValues(
          job: _postController.selectedInternJob.value,
          location: _postController.selectedInternLocation.value,
          education: _postController.selectedInternEducation.value,
          educationList: _postController.multiSelectEducation.toList(),
          period: _postController.selectedPeriod.value,
        );
      case 2: // 대외활동
        return FilterValues(
          job: _postController.selectedField.value,
          location: _postController.selectedActivityLocation.value,
          period: _postController.selectedActivityPeriod.value,
          host: _postController.multiSelectHost.toList(),
        );
      case 3: // 교육/강연
        return FilterValues(
          job: _postController.selectedEduField.value,
          onOffline: _postController.multiSelectOnOffline.toList(),
          location: _postController.selectedEduLocation.value,
          period: _postController.selectedEduPeriod.value,
        );
      case 4: // 공모전
      default:
        return FilterValues(
          job: _postController.selectedContestField.value,
          target: _postController.multiSelectTarget.toList(),
          organizer: _postController.multiSelectOrganizer.toList(),
          benefit: _postController.multiSelectBenefit.toList(),
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
        _postController.multiSelectEducation.clear(); // 학력 다중 선택 초기화
        break;
      case 1: // 인턴
        _postController.selectedInternJob.value = null;
        _postController.selectedPeriod.value = null;
        _postController.selectedInternLocation.value = null;
        _postController.selectedInternEducation.value = null;
        _postController.multiSelectEducation.clear(); // 학력 다중 선택 초기화
        break;
      case 2: // 대외활동
        _postController.selectedField.value = null;
        _postController.selectedActivityPeriod.value = null;
        _postController.selectedActivityLocation.value = null;
        _postController.selectedHost.value = null;
        _postController.multiSelectHost.clear();
        break;
      case 3: // 교육/강연
        _postController.selectedEduField.value = null;
        _postController.selectedEduPeriod.value = null;
        _postController.selectedEduLocation.value = null;
        _postController.selectedOnOffline.value = null;
        _postController.multiSelectOnOffline.clear();
        break;
      case 4: // 공모전
        _postController.selectedContestField.value = null;
        _postController.selectedTarget.value = null;
        _postController.selectedOrganizer.value = null;
        _postController.selectedBenefit.value = null;
        _postController.multiSelectTarget.clear();
        _postController.multiSelectOrganizer.clear();
        _postController.multiSelectBenefit.clear();
        break;
    }
    
    // 필터 초기화 후 데이터 갱신
    _postController.loadContests();
  }

  // 필터 적용 메서드
  void applyFilters({
    required int tabIndex,
    required RangeValues rangeValues,
    String? job,
    String? location,
    String? education,
    String? period,
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
        if (job != null) {
          _postController.selectedContestField.value = job;
        }
        break;
    }
    
    // 필터 적용 후 데이터 갱신
    _postController.loadContests();
  }

  // 멀티 셀렉트 필터 값 업데이트
  void updateMultiSelectValue(int tabIndex, String filterType, String option, bool isSelected) {
    switch (filterType) {
      case '대상':
        if (isSelected) {
          _postController.multiSelectTarget.remove(option);
        } else {
          _postController.multiSelectTarget.add(option);
        }
        break;
      case '주최기관':
        if (tabIndex == 4) {
          if (isSelected) {
            _postController.multiSelectOrganizer.remove(option);
          } else {
            _postController.multiSelectOrganizer.add(option);
          }
        } else {
          if (isSelected) {
            _postController.multiSelectHost.remove(option);
          } else {
            _postController.multiSelectHost.add(option);
          }
        }
        break;
      case '혜택':
        if (isSelected) {
          _postController.multiSelectBenefit.remove(option);
        } else {
          _postController.multiSelectBenefit.add(option);
        }
        break;
      case '온/오프라인':
        if (isSelected) {
          _postController.multiSelectOnOffline.remove(option);
        } else {
          _postController.multiSelectOnOffline.add(option);
        }
        break;
      case '학력':
        if (isSelected) {
          _postController.multiSelectEducation.remove(option);
        } else {
          _postController.multiSelectEducation.add(option);
        }
        break;
    }
    
    // 필터 변경 시 즉시 리스트 업데이트
    _postController.loadContests();
  }

  // 옵션이 선택되었는지 확인
  bool isOptionSelected(int tabIndex, String filterType, String option) {
    switch (filterType) {
      case '대상':
        return _postController.multiSelectTarget.contains(option);
      case '주최기관':
        if (tabIndex == 4) {
          return _postController.multiSelectOrganizer.contains(option);
        } else {
          return _postController.multiSelectHost.contains(option);
        }
      case '혜택':
        return _postController.multiSelectBenefit.contains(option);
      case '온/오프라인':
        return _postController.multiSelectOnOffline.contains(option);
      case '학력':
        return _postController.multiSelectEducation.contains(option);
      default:
        return false;
    }
  }
}
