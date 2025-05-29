import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/models/filter_model.dart';

/// 필터 관련 비즈니스 로직을 담당하는 Controller 클래스
class FilterController extends GetxController {
  final PostController _postController = Get.find<PostController>();

  // View의 UI 상태를 위한 반응형 변수들
  final RxString selectedFilter = ''.obs;
  final Rx<RangeValues> currentRangeValues = const RangeValues(0, 5).obs;
  final RxString selectedJob = ''.obs;
  final RxString selectedLocation = ''.obs;
  final RxString selectedEducation = ''.obs;
  final RxString selectedPeriod = ''.obs;

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
          educationList: _postController.multiSelectJobEducation.toList(),
        );
      case 1: // 인턴
        return FilterValues(
          job: _postController.selectedInternJob.value,
          location: _postController.selectedInternLocation.value,
          education: _postController.selectedInternEducation.value,
          educationList: _postController.multiSelectInternEducation.toList(),
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

  // View에서 사용할 초기값을 설정하는 메소드
  void initializeFilterValues(int tabIndex) {
    final filterValues = getFilterValues(tabIndex);
    selectedJob.value = filterValues.job ?? '';
    selectedLocation.value = filterValues.location ?? '';
    selectedEducation.value = filterValues.education ?? '';
    selectedPeriod.value = filterValues.period ?? '';
    currentRangeValues.value = getSliderValues(tabIndex);
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
            return const RangeValues(15, 20);
          } else if (exp == '20년 이상') {
            return RangeValues(20, max);
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
            return const RangeValues(18, 24);
          } else if (period == '2년 이상') {
            return RangeValues(24, max);
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
            return const RangeValues(18, 24);
          } else if (period == '2년 이상') {
            return RangeValues(24, max);
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
            return const RangeValues(120, 180);
          } else if (period == '6개월 이상') {
            return RangeValues(180, max);
          }
        }
        break;
    }

    // 기본값: 최소값부터 1/4 지점까지
    return RangeValues(min, min + stepSize);
  }

  // 슬라이더 라벨 포맷 - 통합된 메서드 (외부 및 내부 참조용)
  String formatSliderLabel(double value, int tabIndex) {
    SliderConfig config = getSliderConfig(tabIndex);
    
    switch (tabIndex) {
      case 0: // 채용
        if (value == 0) {
          return '신입';
        } else if (value == 20) {
          return '20년 이상';
        } else {
          return '${value.toInt()}년';
        }
      case 1: // 인턴
      case 2: // 대외활동
        if (value == 1) return '1개월';
        if (value == 6) return '6개월';
        if (value == 12) return '1년';
        if (value == 18) return '1.5년';
        if (value == 24) return '2년';
        
        final List<double> steps = [1, 6, 12, 18, 24];
        final List<String> labels = ['1개월', '6개월', '1년', '1.5년', '2년'];
        
        return _findClosestLabel(value, steps, labels);
        
      case 3: // 교육/강연
        double range = config.max - config.min;
        double stepSize = range / 4;
        
        if (value <= config.min + stepSize * 0.5) {
          return '1일';
        } else if (value <= config.min + stepSize * 1.5) {
          return '1개월';
        } else if (value <= config.min + stepSize * 2.5) {
          return '2개월';
        } else if (value <= config.min + stepSize * 3.5) {
          return '4개월';
        } else {
          return '6개월';
        }
        
      default:
        return '${value.round()}';
    }
  }

  // 필터 초기화 메서드
  void resetFilters(int tabIndex) {
    selectedJob.value = '';
    selectedLocation.value = '';
    selectedEducation.value = '';
    selectedPeriod.value = '';
    
    final config = getSliderConfig(tabIndex);
    currentRangeValues.value = RangeValues(config.min, config.min + (config.max - config.min) / 4);
    
    resetFiltersForTab(tabIndex);
  }

  // 탭별 필터 초기화 메서드
  void resetFiltersForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _postController.selectedJob.value = null;
        _postController.selectedExperience.value = null;
        _postController.selectedLocation.value = null;
        _postController.selectedEducation.value = null;
        _postController.multiSelectJobEducation.clear();
        break;
      case 1:
        _postController.selectedInternJob.value = null;
        _postController.selectedPeriod.value = null;
        _postController.selectedInternLocation.value = null;
        _postController.selectedInternEducation.value = null;
        _postController.multiSelectInternEducation.clear();
        break;
      case 2:
        _postController.selectedField.value = null;
        _postController.selectedActivityPeriod.value = null;
        _postController.selectedActivityLocation.value = null;
        _postController.selectedHost.value = null;
        _postController.multiSelectHost.clear();
        break;
      case 3:
        _postController.selectedEduField.value = null;
        _postController.selectedEduPeriod.value = null;
        _postController.selectedEduLocation.value = null;
        _postController.selectedOnOffline.value = null;
        _postController.multiSelectOnOffline.clear();
        break;
      case 4:
        _postController.selectedContestField.value = null;
        _postController.selectedTarget.value = null;
        _postController.selectedOrganizer.value = null;
        _postController.selectedBenefit.value = null;
        _postController.multiSelectTarget.clear();
        _postController.multiSelectOrganizer.clear();
        _postController.multiSelectBenefit.clear();
        break;
    }

    _postController.loadContests();
  }

  // 필터 적용 메서드 - 통합된 필터 적용 로직
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
    bool isReset = job == null && location == null && education == null && period == null;

    if (isReset) {
      resetFiltersForTab(tabIndex);
      return;
    }

    switch (tabIndex) {
      case 0:
        if (job != null) {
          _postController.selectedJob.value = job;
        }

        applyRangeFilter(tabIndex, rangeValues);

        if (location != null) {
          _postController.selectedLocation.value = location;
        }

        if (education != null) {
          _postController.selectedEducation.value = education;
        }
        break;

      case 1:
        if (job != null) {
          _postController.selectedInternJob.value = job;
        }

        applyRangeFilter(tabIndex, rangeValues);

        if (location != null) {
          _postController.selectedInternLocation.value = location;
        }

        if (education != null) {
          _postController.selectedInternEducation.value = education;
        }
        break;

      case 2:
        if (job != null) {
          _postController.selectedField.value = job;
        }

        applyRangeFilter(tabIndex, rangeValues);

        if (location != null) {
          _postController.selectedActivityLocation.value = location;
        }
        break;

      case 3:
        if (job != null) {
          _postController.selectedEduField.value = job;
        }

        applyRangeFilter(tabIndex, rangeValues);

        if (location != null) {
          _postController.selectedEduLocation.value = location;
        }
        break;

      case 4:
      default:
        if (job != null) {
          _postController.selectedContestField.value = job;
        }
        break;
    }

    _postController.loadContests();
  }

  // 슬라이더 필터링 적용 - 통합된 메서드
  void applyRangeSliderFilter(int tabIndex, RangeValues values) {
    applyRangeFilter(tabIndex, values);
    _postController.loadContests();
  }

  // 모든 슬라이더 필터(경력, 기간)를 처리하는 통합된 메서드
  void applyRangeFilter(int tabIndex, RangeValues values) {
    String filterValue;
    SliderConfig config = getSliderConfig(tabIndex);
    
    switch (tabIndex) {
      case 0: // 채용 (경력)
        if (values.start == 0 && values.end == 0) {
          filterValue = '신입';
        } else if (values.start == 20 && values.end == 20) {
          filterValue = '20년 이상';
        } else if (values.start == values.end) {
          filterValue = formatSliderLabel(values.start, tabIndex);
        } else {
          filterValue = '${formatSliderLabel(values.start, tabIndex)}~${formatSliderLabel(values.end, tabIndex)}';
        }
        _postController.selectedExperience.value = filterValue;
        break;
        
      case 1: // 인턴
      case 2: // 대외활동
        if (values.start == 1 && values.end == 1) {
          filterValue = '1개월 이하';
        } else if (values.start == 24 && values.end == 24) {
          filterValue = '2년 이상';
        } else if (values.start == values.end) {
          filterValue = formatSliderLabel(values.start, tabIndex);
        } else {
          filterValue = '${formatSliderLabel(values.start, tabIndex)}~${formatSliderLabel(values.end, tabIndex)}';
        }
        
        if (tabIndex == 1) {
          _postController.selectedPeriod.value = filterValue;
        } else {
          _postController.selectedActivityPeriod.value = filterValue;
        }
        break;
        
      case 3: // 교육/강연
        if (values.start == 1 && values.end == 1) {
          filterValue = '1일';
        } else if (values.start == 180 && values.end == 180) {
          filterValue = '6개월 이상';
        } else if (values.start == values.end) {
          filterValue = formatSliderLabel(values.start, tabIndex);
        } else {
          filterValue = '${formatSliderLabel(values.start, tabIndex)}~${formatSliderLabel(values.end, tabIndex)}';
        }
        _postController.selectedEduPeriod.value = filterValue;
        break;
        
      default:
        // 기존 로직을 유지하는 대체 로직
        if (values.start == values.end) {
          if (values.start == config.min) {
            filterValue = '${formatSliderLabel(values.start, tabIndex)} 이하';
          } else if (values.start == config.max) {
            filterValue = '${formatSliderLabel(values.start, tabIndex)} 이상';
          } else {
            filterValue = formatSliderLabel(values.start, tabIndex);
          }
        } else if (values.start == config.min) {
          filterValue = '${formatSliderLabel(values.end, tabIndex)} 이하';
        } else if (values.end == config.max) {
          filterValue = '${formatSliderLabel(values.start, tabIndex)} 이상';
        } else {
          filterValue = '${formatSliderLabel(values.start, tabIndex)}~${formatSliderLabel(values.end, tabIndex)}';
        }
        break;
    }
    
    currentRangeValues.value = values;
  }

  // 선택한 필터 값 업데이트
  void updateFilterValue(int tabIndex, String title, String value) {
    switch (tabIndex) {
      case 0: 
        updateJobFilter(title, value);
        break;
      case 1: 
        updateInternFilter(title, value);
        break;
      case 2: 
        updateActivityFilter(title, value);
        break;
      case 3: 
        updateEducationFilter(title, value);
        break;
      case 4: 
        updateContestFilter(title, value);
        break;
    }
    
    _postController.loadContests();
  }
  
  // 채용 탭 필터 업데이트
  void updateJobFilter(String title, String value) {
    switch (title) {
      case '직무':
        _postController.selectedJob.value = value;
        selectedJob.value = value;
        break;
      case '경력':
        _postController.selectedExperience.value = value;
        selectedPeriod.value = value;
        break;
      case '지역':
        _postController.selectedLocation.value = value;
        selectedLocation.value = value;
        break;
      case '학력':
        _postController.selectedEducation.value = value;
        selectedEducation.value = value;
        break;
    }
  }
  
  // 인턴 탭 필터 업데이트
  void updateInternFilter(String title, String value) {
    switch (title) {
      case '직무':
        _postController.selectedInternJob.value = value;
        selectedJob.value = value;
        break;
      case '지역':
        _postController.selectedInternLocation.value = value;
        selectedLocation.value = value;
        break; 
      case '기간':
        _postController.selectedPeriod.value = value;
        selectedPeriod.value = value;
        break;
      case '학력':
        _postController.selectedInternEducation.value = value;
        selectedEducation.value = value;
        break;
    }
  }
  
  // 대외활동 탭 필터 업데이트
  void updateActivityFilter(String title, String value) {
    switch (title) {
      case '분야':
        _postController.selectedField.value = value;
        selectedJob.value = value;
        break;
      case '지역':
        _postController.selectedActivityLocation.value = value;
        selectedLocation.value = value;
        break;
      case '기간':
        _postController.selectedActivityPeriod.value = value;
        selectedPeriod.value = value;
        break;
      case '주최기관':
        _postController.selectedHost.value = value;
        break;
    }
  }
  
  // 교육/강연 탭 필터 업데이트
  void updateEducationFilter(String title, String value) {
    switch (title) {
      case '분야':
        _postController.selectedEduField.value = value;
        selectedJob.value = value;
        break;
      case '지역':
        _postController.selectedEduLocation.value = value;
        selectedLocation.value = value;
        break;
      case '기간':
        _postController.selectedEduPeriod.value = value;
        selectedPeriod.value = value;
        break;
      case '온/오프라인':
        _postController.selectedOnOffline.value = value;
        break;
    }
  }
  
  // 공모전 탭 필터 업데이트
  void updateContestFilter(String title, String value) {
    switch (title) {
      case '분야':
        _postController.selectedContestField.value = value;
        selectedJob.value = value;
        break;
      case '대상':
        _postController.selectedTarget.value = value;
        break;
      case '주최기관':
        _postController.selectedOrganizer.value = value;
        break;
      case '혜택':
        _postController.selectedBenefit.value = value;
        break;
    }
  }

  // 멀티 셀렉트 필터 값 업데이트
  void updateMultiSelectValue(int tabIndex, String filterType, String option, bool isSelected) {
    switch (filterType) {
      case '학력':
        if (tabIndex == 0) { 
          if (isSelected) {
            _postController.multiSelectJobEducation.remove(option);
          } else {
            _postController.multiSelectJobEducation.add(option);
          }
        } else if (tabIndex == 1) { 
          if (isSelected) {
            _postController.multiSelectInternEducation.remove(option);
          } else {
            _postController.multiSelectInternEducation.add(option);
          }
        }
        break;
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
    }
    
    _postController.loadContests();
  }

  // 옵션이 선택되었는지 확인
  bool isOptionSelected(int tabIndex, String filterType, String option) {
    switch (filterType) {
      case '학력':
        if (tabIndex == 0) { 
          return _postController.multiSelectJobEducation.contains(option);
        } else if (tabIndex == 1) { 
          return _postController.multiSelectInternEducation.contains(option);
        }
        return false;
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
      default:
        return false;
    }
  }

  // 가장 가까운 라벨 찾기 (중복 코드 제거)
  String _findClosestLabel(double value, List<double> steps, List<String> labels) {
    double minDiff = double.infinity;
    int closestIndex = 0;
    
    for (int i = 0; i < steps.length; i++) {
      double diff = (value - steps[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestIndex = i;
      }
    }
    
    return labels[closestIndex];
  }
}
