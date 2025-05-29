import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart';
import 'package:knowme_frontend/features/posts/services/filter_options_service.dart';

import '../widgets/filter_apply_button.dart';
import '../widgets/filter_dropdown.dart';
import '../widgets/filter_header.dart';
import '../widgets/filter_slider.dart';
import '../widgets/filter_tag_selector.dart';

/// 필터 바텀시트 위젯 - 순수 View 역할
class FilterBottomSheet extends StatefulWidget {
  final String title; // 필터 제목
  final String? selectedValue; // 선택된 필터 값 (optional)
  final int tabIndex; // 현재 탭 인덱스 (0~4)

  const FilterBottomSheet({
    super.key,
    required this.title,
    this.selectedValue,
    required this.tabIndex,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Controller 및 Service 참조
  late final FilterController _filterController;
  late final FilterOptionsService _optionsService;
  
  @override
  void initState() {
    super.initState();
    _filterController = Get.find<FilterController>();
    _optionsService = Get.find<FilterOptionsService>();
    
    // 컨트롤러에 초기화 요청
    _filterController.initializeFilterValues(widget.tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sheetHeight = screenHeight * 3 / 4; // 바텀시트 높이 75%

    return SingleChildScrollView(
      child: Container(
        width: screenWidth,
        height: sheetHeight,
        clipBehavior: Clip.antiAlias,
        decoration: const ShapeDecoration(
          color: Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
        ),
        child: Stack(
          children: [
            // 필터 위젯 영역
            Positioned(
              left: 0,
              top: 90,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Obx(() {
                  // 반응형으로 필터 위젯 업데이트
                  return Column(children: _buildFilterWidgets());
                }),
              ),
            ),
            // 적용 버튼
            FilterApplyButton(onApply: () {
              // 값을 실제로 필터에 적용하고 바텀시트 닫기
              _filterController.applyFilters(
                tabIndex: widget.tabIndex,
                job: _filterController.selectedJob.value.isEmpty ? null : _filterController.selectedJob.value,
                location: _filterController.selectedLocation.value.isEmpty ? null : _filterController.selectedLocation.value,
                education: _filterController.selectedEducation.value.isEmpty ? null : _filterController.selectedEducation.value,
                period: _filterController.selectedPeriod.value.isEmpty ? null : _filterController.selectedPeriod.value,
                rangeValues: _filterController.currentRangeValues.value,
              );
              Navigator.pop(context);
            }),
            // 상단 헤더 (제목, 리셋 버튼, 닫기 버튼 포함)
            FilterHeader(
              title: _filterController.getTabTitle(widget.tabIndex),
              onReset: () => _filterController.resetFilters(widget.tabIndex),
              onClose: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // 탭 인덱스별 필터 위젯들 구성 - 팩토리 패턴 적용
  List<Widget> _buildFilterWidgets() {
    switch (widget.tabIndex) {
      case 0:
        return _buildJobFilterWidgets();
      case 1:
        return _buildInternFilterWidgets();
      case 2:
        return _buildActivityFilterWidgets();
      case 3:
        return _buildEducationFilterWidgets();
      case 4:
      default:
        return _buildContestFilterWidgets();
    }
  }
  
  // 드롭다운 옵션 선택 시 처리 - 이제 단순히 controller에 위임만 수행
  Future<String?> _selectValue(String title, List<String> options) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$title 선택'),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  // Controller에만 이벤트 전달
                  _filterController.updateFilterValue(widget.tabIndex, title, option);
                  Navigator.pop(context, option);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소')
          )
        ],
      ),
    );
    
    return selected;
  }
  
  // 채용 탭 필터 위젯 - UI 구성만 담당
  List<Widget> _buildJobFilterWidgets() {
    return [
      const SizedBox(height: 10),
      FilterDropdown(
        title: '직무',
        options: _optionsService.getJobOptions(0),
        selectedValue: _filterController.selectedJob.value.isEmpty ? null : _filterController.selectedJob.value,
        onTap: () => _selectValue('직무', _optionsService.getJobOptions(0)),
      ),
      _buildRangeSliderWithValueListener(0, '경력'),
      FilterDropdown(
        title: '지역',
        options: _optionsService.getLocationOptions(0),
        selectedValue: _filterController.selectedLocation.value.isEmpty ? null : _filterController.selectedLocation.value,
        onTap: () => _selectValue('지역', _optionsService.getLocationOptions(0)),
      ),
      FilterTagSelector(
        title: '학력',
        options: _optionsService.getEducationOptions(),
        selected: null,
        tabIndex: 0,
        controller: _filterController,
      ),
    ];
  }
  
  // 인턴 탭 필터 위젯
  List<Widget> _buildInternFilterWidgets() {
    return [
      const SizedBox(height: 10),
      FilterDropdown(
        title: '직무',
        options: _optionsService.getJobOptions(1),
        selectedValue: _filterController.selectedJob.value.isEmpty ? null : _filterController.selectedJob.value,
        onTap: () => _selectValue('직무', _optionsService.getJobOptions(1)),
      ),
      _buildRangeSliderWithValueListener(1, '기간'),
      FilterDropdown(
        title: '지역',
        options: _optionsService.getLocationOptions(1),
        selectedValue: _filterController.selectedLocation.value.isEmpty ? null : _filterController.selectedLocation.value,
        onTap: () => _selectValue('지역', _optionsService.getLocationOptions(1)),
      ),
      FilterTagSelector(
        title: '학력',
        options: _optionsService.getEducationOptions(),
        selected: null,
        tabIndex: 1,
        controller: _filterController,
      ),
    ];
  }
  
  // 대외활동 탭 필터 위젯
  List<Widget> _buildActivityFilterWidgets() {
    return [
      const SizedBox(height: 10),
      FilterDropdown(
        title: '분야',
        options: _optionsService.getFieldOptions(2),
        selectedValue: _filterController.selectedJob.value.isEmpty ? null : _filterController.selectedJob.value,
        onTap: () => _selectValue('분야', _optionsService.getFieldOptions(2)),
      ),
      _buildRangeSliderWithValueListener(2, '기간'),
      FilterDropdown(
        title: '지역',
        options: _optionsService.getLocationOptions(2),
        selectedValue: _filterController.selectedLocation.value.isEmpty ? null : _filterController.selectedLocation.value,
        onTap: () => _selectValue('지역', _optionsService.getLocationOptions(2)),
      ),
      FilterTagSelector(
        title: '주최기관',
        options: _optionsService.getOrganizerOptions(2),
        selected: null,
        tabIndex: 2,
        controller: _filterController,
      ),
    ];
  }
  
  // 교육/강연 탭 필터 위젯
  List<Widget> _buildEducationFilterWidgets() {
    return [
      const SizedBox(height: 10),
      FilterDropdown(
        title: '분야',
        options: _optionsService.getFieldOptions(3),
        selectedValue: _filterController.selectedJob.value.isEmpty ? null : _filterController.selectedJob.value,
        onTap: () => _selectValue('분야', _optionsService.getFieldOptions(3)),
      ),
      _buildRangeSliderWithValueListener(3, '기간'),
      FilterDropdown(
        title: '지역',
        options: _optionsService.getLocationOptions(3),
        selectedValue: _filterController.selectedLocation.value.isEmpty ? null : _filterController.selectedLocation.value,
        onTap: () => _selectValue('지역', _optionsService.getLocationOptions(3)),
      ),
      FilterTagSelector(
        title: '온/오프라인',
        options: _optionsService.getOnOfflineOptions(),
        selected: null,
        tabIndex: 3,
        controller: _filterController,
      ),
    ];
  }
  
  // 공모전 탭 필터 위젯
  List<Widget> _buildContestFilterWidgets() {
    return [
      const SizedBox(height: 10),
      FilterDropdown(
        title: '분야',
        options: _optionsService.getFieldOptions(4),
        selectedValue: _filterController.selectedJob.value.isEmpty ? null : _filterController.selectedJob.value,
        onTap: () => _selectValue('분야', _optionsService.getFieldOptions(4)),
      ),
      FilterTagSelector(
        title: '대상',
        options: _optionsService.getTargetOptions(),
        selected: null,
        tabIndex: 4, 
        controller: _filterController,
      ),
      FilterTagSelector(
        title: '주최기관',
        options: _optionsService.getOrganizerOptions(4),
        selected: null,
        tabIndex: 4,
        controller: _filterController,
      ),
      FilterTagSelector(
        title: '혜택',
        options: _optionsService.getBenefitOptions(),
        selected: null,
        tabIndex: 4,
        controller: _filterController,
      ),
    ];
  }
  
  // 레인지 슬라이더 위젯 생성 - 단순 UI 구성만 담당
  Widget _buildRangeSliderWithValueListener(int tabIndex, String title) {
    return Obx(() {
      return FilterRangeSlider(
        title: title,
        tabIndex: tabIndex,
        currentRangeValues: _filterController.currentRangeValues.value,
        onChanged: (values) {
          // 슬라이더 값 변경 시 컨트롤러에 위임
          _filterController.applyRangeSliderFilter(tabIndex, values);
        },
        controller: _filterController,
      );
    });
  }
}
