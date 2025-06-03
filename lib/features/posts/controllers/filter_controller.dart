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
      case 0:
        return '채용';
      case 1:
        return '인턴';
      case 2:
        return '대외활동';
      case 3:
        return '교육/강연';
      case 4:
        return '공모전';
      default:
        return '필터';
    }
  }

  // 현재 필터 값 가져오기
  FilterValues getFilterValues(int tabIndex) {
    switch (tabIndex) {
      case 0: // 채용
        return FilterValues(
          job: _postController.getFilterByType(tabIndex, '직무').value,
          experience: _postController.getFilterByType(tabIndex, '신입~5년').value,
          location: _postController.getFilterByType(tabIndex, '지역').value,
          education: _postController.getFilterByType(tabIndex, '학력').value,
          educationList: _postController.multiSelectJobEducation.toList(),
        );
      case 1: // 인턴
        return FilterValues(
          job: _postController.getFilterByType(tabIndex, '직무').value,
          location: _postController.getFilterByType(tabIndex, '지역').value,
          education: _postController.getFilterByType(tabIndex, '학력').value,
          educationList: _postController.multiSelectInternEducation.toList(),
          period: _postController.getFilterByType(tabIndex, '기간').value,
        );
      case 2: // 대외활동
        return FilterValues(
          job: _postController.getFilterByType(tabIndex, '분야').value,
          location: _postController.getFilterByType(tabIndex, '지역').value,
          period: _postController.getFilterByType(tabIndex, '기간').value,
          host: _postController.multiSelectHost.toList(),
        );
      case 3: // 교육/강연
        return FilterValues(
          job: _postController.getFilterByType(tabIndex, '분야').value,
          onOffline: _postController.multiSelectOnOffline.toList(),
          location: _postController.getFilterByType(tabIndex, '지역').value,
          period: _postController.getFilterByType(tabIndex, '기간').value,
        );
      case 4: // 공모전
      default:
        return FilterValues(
          job: _postController.getFilterByType(tabIndex, '분야').value,
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
        final expValue =
            _postController.getFilterByType(tabIndex, '신입~5년').value;
        if (expValue != null) {
          if (expValue == '신입') {
            return const RangeValues(0, 0);
          } else if (expValue == '5년 이하') {
            return const RangeValues(0, 5);
          } else if (expValue == '5~10년') {
            return const RangeValues(5, 10);
          } else if (expValue == '10~15년') {
            return const RangeValues(10, 15);
          } else if (expValue == '15년 이상') {
            return const RangeValues(15, 20);
          } else if (expValue == '20년 이상') {
            return RangeValues(20, max);
          }
        }
        break;
      case 1: // 인턴
        final periodValue =
            _postController.getFilterByType(tabIndex, '기간').value;
        if (periodValue != null) {
          if (periodValue == '1개월 이하') {
            return const RangeValues(1, 1);
          } else if (periodValue == '1~6개월') {
            return const RangeValues(1, 6);
          } else if (periodValue == '6개월~1년') {
            return const RangeValues(6, 12);
          } else if (periodValue == '1~1.5년') {
            return const RangeValues(12, 18);
          } else if (periodValue == '1.5년 이상') {
            return const RangeValues(18, 24);
          } else if (periodValue == '2년 이상') {
            return RangeValues(24, max);
          }
        }
        break;
      case 2: // 대외활동
        final periodValue =
            _postController.getFilterByType(tabIndex, '기간').value;
        if (periodValue != null) {
          if (periodValue == '1개월 이하') {
            return const RangeValues(1, 1);
          } else if (periodValue == '1~6개월') {
            return const RangeValues(1, 6);
          } else if (periodValue == '6개월~1년') {
            return const RangeValues(6, 12);
          } else if (periodValue == '1~1.5년') {
            return const RangeValues(12, 18);
          } else if (periodValue == '1.5년 이상') {
            return const RangeValues(18, 24);
          } else if (periodValue == '2년 이상') {
            return RangeValues(24, max);
          }
        }
        break;
      case 3: // 교육/강연
        final periodValue =
            _postController.getFilterByType(tabIndex, '기간').value;
        if (periodValue != null) {
          if (periodValue == '1일') {
            return const RangeValues(1, 1);
          } else if (periodValue == '1일~1개월') {
            return const RangeValues(1, 30);
          } else if (periodValue == '1~2개월') {
            return const RangeValues(30, 60);
          } else if (periodValue == '2~4개월') {
            return const RangeValues(60, 120);
          } else if (periodValue == '4~6개월') {
            return const RangeValues(120, 180);
          } else if (periodValue == '6개월 이상') {
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
    currentRangeValues.value =
        RangeValues(config.min, config.min + (config.max - config.min) / 4);

    resetFiltersForTab(tabIndex);
  }

  // 모든 필터 초기화
  void resetAllFilters() {
    // 모든 필터 초기화
    _postController.resetFilters();

    // 데이터 새로 로드
    _postController.loadPosts();
  }

  // 탭별 필터 초기화 메서드
  void resetFiltersForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _postController.getFilterByType(tabIndex, '직무').value = null;
        _postController.getFilterByType(tabIndex, '신입~5년').value = null;
        _postController.getFilterByType(tabIndex, '지역').value = null;
        _postController.getFilterByType(tabIndex, '학력').value = null;
        _postController.multiSelectJobEducation.clear();
        break;
      case 1:
        _postController.getFilterByType(tabIndex, '직무').value = null;
        _postController.getFilterByType(tabIndex, '기간').value = null;
        _postController.getFilterByType(tabIndex, '지역').value = null;
        _postController.getFilterByType(tabIndex, '학력').value = null;
        _postController.multiSelectInternEducation.clear();
        break;
      case 2:
        _postController.getFilterByType(tabIndex, '분야').value = null;
        _postController.getFilterByType(tabIndex, '기간').value = null;
        _postController.getFilterByType(tabIndex, '지역').value = null;
        _postController.getFilterByType(tabIndex, '주최기관').value = null;
        _postController.multiSelectHost.clear();
        break;
      case 3:
        _postController.getFilterByType(tabIndex, '분야').value = null;
        _postController.getFilterByType(tabIndex, '기간').value = null;
        _postController.getFilterByType(tabIndex, '지역').value = null;
        _postController.getFilterByType(tabIndex, '온/오프라인').value = null;
        _postController.multiSelectOnOffline.clear();
        break;
      case 4:
        _postController.getFilterByType(tabIndex, '분야').value = null;
        _postController.getFilterByType(tabIndex, '대상').value = null;
        _postController.getFilterByType(tabIndex, '주최기관').value = null;
        _postController.getFilterByType(tabIndex, '혜택').value = null;
        _postController.multiSelectTarget.clear();
        _postController.multiSelectOrganizer.clear();
        _postController.multiSelectBenefit.clear();
        break;
    }

    _postController.loadPosts();
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
    bool isReset =
        job == null && location == null && education == null && period == null;

    if (isReset) {
      resetFiltersForTab(tabIndex);
      return;
    }

    switch (tabIndex) {
      case 0:
        if (job != null) {
          _postController.getFilterByType(tabIndex, '직무').value = job;
        }

        applyRangeFilter(tabIndex, rangeValues);

        if (location != null) {
          _postController.getFilterByType(tabIndex, '지역').value = location;
        }

        if (education != null) {
          _postController.getFilterByType(tabIndex, '학력').value = education;
        }
        break;

      case 1:
        if (job != null) {
          _postController.getFilterByType(tabIndex, '직무').value = job;
        }

        applyRangeFilter(tabIndex, rangeValues);

        if (location != null) {
          _postController.getFilterByType(tabIndex, '지역').value = location;
        }

        if (education != null) {
          _postController.getFilterByType(tabIndex, '학력').value = education;
        }
        break;

      case 2:
        if (job != null) {
          _postController.getFilterByType(tabIndex, '분야').value = job;
        }

        applyRangeFilter(tabIndex, rangeValues);

        if (location != null) {
          _postController.getFilterByType(tabIndex, '지역').value = location;
        }
        break;

      case 3:
        if (job != null) {
          _postController.getFilterByType(tabIndex, '분야').value = job;
        }

        applyRangeFilter(tabIndex, rangeValues);

        if (location != null) {
          _postController.getFilterByType(tabIndex, '지역').value = location;
        }
        break;

      case 4:
      default:
        if (job != null) {
          _postController.getFilterByType(tabIndex, '분야').value = job;
        }
        break;
    }

    _postController.loadPosts();
  }

  // 슬라이더 필터링 적용 - 통합된 메서드
  void applyRangeSliderFilter(int tabIndex, RangeValues values) {
    applyRangeFilter(tabIndex, values);
    _postController.loadPosts();
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
          filterValue =
              '${formatSliderLabel(values.start, tabIndex)}~${formatSliderLabel(values.end, tabIndex)}';
        }
        _postController.getFilterByType(tabIndex, '신입~5년').value = filterValue;
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
          filterValue =
              '${formatSliderLabel(values.start, tabIndex)}~${formatSliderLabel(values.end, tabIndex)}';
        }

        if (tabIndex == 1) {
          _postController.getFilterByType(tabIndex, '기간').value = filterValue;
        } else {
          _postController.getFilterByType(tabIndex, '기간').value = filterValue;
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
          filterValue =
              '${formatSliderLabel(values.start, tabIndex)}~${formatSliderLabel(values.end, tabIndex)}';
        }
        _postController.getFilterByType(tabIndex, '기간').value = filterValue;
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
          filterValue =
              '${formatSliderLabel(values.start, tabIndex)}~${formatSliderLabel(values.end, tabIndex)}';
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

    _postController.loadPosts();
  }

  // 선택된 필터 업데이트
  void selectFilter(String type, String value) {
    // 선택된 필터 업데이트
    _postController.updateFilter(type, value);

    // 데이터 새로 로드
    _postController.loadPosts();
  }

  // 필터 클리어
  void clearFilter(String type) {
    // 필터 클리어
    _postController.updateFilter(type, null);

    // 데이터 새로 로드
    _postController.loadPosts();
  }

  // 채용 탭 필터 업데이트
  void updateJobFilter(String title, String value) {
    switch (title) {
      case '직무':
        _postController.getFilterByType(0, '직무').value = value;
        selectedJob.value = value;
        break;
      case '경력':
        _postController.getFilterByType(0, '신입~5년').value = value;
        selectedPeriod.value = value;
        break;
      case '지역':
        _postController.getFilterByType(0, '지역').value = value;
        selectedLocation.value = value;
        break;
      case '학력':
        _postController.getFilterByType(0, '학력').value = value;
        selectedEducation.value = value;
        break;
    }
  }

  // 인턴 탭 필터 업데이트
  void updateInternFilter(String title, String value) {
    switch (title) {
      case '직무':
        _postController.getFilterByType(1, '직무').value = value;
        selectedJob.value = value;
        break;
      case '지역':
        _postController.getFilterByType(1, '지역').value = value;
        selectedLocation.value = value;
        break;
      case '기간':
        _postController.getFilterByType(1, '기간').value = value;
        selectedPeriod.value = value;
        break;
      case '학력':
        _postController.getFilterByType(1, '학력').value = value;
        selectedEducation.value = value;
        break;
    }
  }

  // 대외활동 탭 필터 업데이트
  void updateActivityFilter(String title, String value) {
    switch (title) {
      case '분야':
        _postController.getFilterByType(2, '분야').value = value;
        selectedJob.value = value;
        break;
      case '지역':
        _postController.getFilterByType(2, '지역').value = value;
        selectedLocation.value = value;
        break;
      case '기간':
        _postController.getFilterByType(2, '기간').value = value;
        selectedPeriod.value = value;
        break;
      case '주최기관':
        _postController.getFilterByType(2, '주최기관').value = value;
        break;
    }
  }

  // 교육/강연 탭 필터 업데이트
  void updateEducationFilter(String title, String value) {
    switch (title) {
      case '분야':
        _postController.getFilterByType(3, '분야').value = value;
        selectedJob.value = value;
        break;
      case '지역':
        _postController.getFilterByType(3, '지역').value = value;
        selectedLocation.value = value;
        break;
      case '기간':
        _postController.getFilterByType(3, '기간').value = value;
        selectedPeriod.value = value;
        break;
      case '온/오프라인':
        _postController.getFilterByType(3, '온/오프라인').value = value;
        break;
    }
  }

  // 공모전 탭 필터 업데이트
  void updateContestFilter(String title, String value) {
    switch (title) {
      case '분야':
        _postController.getFilterByType(4, '분야').value = value;
        selectedJob.value = value;
        break;
      case '대상':
        _postController.getFilterByType(4, '대상').value = value;
        break;
      case '주최기관':
        _postController.getFilterByType(4, '주최기관').value = value;
        break;
      case '혜택':
        _postController.getFilterByType(4, '혜택').value = value;
        break;
    }
  }

  // 멀티 셀렉트 필터 값 업데이트
  void updateMultiSelectValue(
      int tabIndex, String filterType, String option, bool isSelected) {
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

    _postController.loadPosts();
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
  String _findClosestLabel(
      double value, List<double> steps, List<String> labels) {
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

  // 필터 적용 메서드
  void applyFilter() {
    Get.back(); // 필터 다이얼로그 닫기

    // PostController의 loadPosts 메서드 호출
    _postController.loadPosts();
  }

  // 교육 필터 적용
  void applyJobEducationFilters() {
    // 교육 필터 적용 로직
    // ...

    // 데이터 새로 로드
    _postController.loadPosts();
  }
}
