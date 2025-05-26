// Flutter UI, GetX 상태관리 패키지, 프레젠터 및 위젯 불러오기
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/presenters/filter_presenter.dart';

import '../widgets/filter_apply_button.dart'; // 필터 적용 버튼
import '../widgets/filter_dropdown.dart'; // 드롭다운 위젯
import '../widgets/filter_header.dart'; // 필터 헤더 위젯
import '../widgets/filter_slider.dart'; // 슬라이더 위젯
import '../widgets/filter_tag_selector.dart'; // 필터 태그 선택 위젯

// 필터 바텀시트 StatefulWidget
class FilterBottomSheet extends StatefulWidget {
  final String title; // 필터 제목
  final String? selectedValue; // 선택된 필터 값 (optional)
  final int tabIndex; // 현재 탭 인덱스 (0~4)

  const FilterBottomSheet({
    Key? key,
    required this.title,
    this.selectedValue,
    required this.tabIndex,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterPresenter _presenter; // Presenter 인스턴스
  RangeValues _currentRangeValues = const RangeValues(0, 5); // 슬라이더 초기값

  String? _selectedEducation; // 선택된 학력
  String? _selectedJob; // 선택된 직무
  String? _selectedLocation; // 선택된 지역
  String? _selectedPeriod; // 선택된 기간
  // 단일 선택 필터 - 바텀시트에서는 사용하지 않고 presenter가 직접 관리하도록 함
  String? _selectedOnOffline;
  String? _selectedHost;
  String? _selectedTarget;
  String? _selectedBenefit;

  @override
  void initState() {
    super.initState();
    _presenter = Get.find<FilterPresenter>(); // Presenter 인스턴스를 DI로 주입
    _initializeValues(); // 초기 필터값 설정
  }

  // 초기 필터 상태를 Presenter로부터 불러와 설정
  void _initializeValues() {
    final filterValues = _presenter.getFilterValues(widget.tabIndex);
    setState(() {
      _selectedJob = filterValues.job;
      _selectedLocation = filterValues.location;
      _selectedEducation = filterValues.education; // 단일 선택 교육은 그대로 유지
      _selectedPeriod = filterValues.period;
      
      // 다중 선택 필터는 presenter에 이미 저장된 상태로 유지됨

      _currentRangeValues =
          _presenter.getSliderValues(widget.tabIndex); // 슬라이더 값 설정
    });
  }

  // 필터 초기화
  void _resetFilters() {
    setState(() {
      _selectedJob = null;
      _selectedLocation = null;
      _selectedEducation = null;
      _selectedPeriod = null;
      
      // 슬라이더 초기값 설정
      final config = _presenter.getSliderConfig(widget.tabIndex);
      _currentRangeValues =
          RangeValues(config.min, config.min + (config.max - config.min) / 4);
    });
    _presenter.resetFiltersForTab(widget.tabIndex); // Presenter에 필터 초기화 알림
  }

  // 현재 선택된 필터 값 적용
  void _applyFilters() {
    _presenter.applyFilters(
      tabIndex: widget.tabIndex,
      job: _selectedJob, // 선택된 직무, 경력, 분야
      location: _selectedLocation, // 선택된 지역
      education: _selectedEducation, // 학력
      period: _selectedPeriod, // 선택된 기간, 경력
      rangeValues: _currentRangeValues, // 슬라이더 값
      // 다중 선택 필터들은 presenter가 직접 관리하므로 전달하지 않음
    );
  }

  // 드롭다운 또는 다이얼로그 방식의 선택창 띄우기
  Future<String?> _selectValue(String title, List<String> options) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text('$title 선택'),
            content: SingleChildScrollView(
              child: Column(
                children: options.map((option) {
                  return ListTile(
                    title: Text(option),
                    onTap: () => Navigator.pop(context, option),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context),
                  child: const Text('취소'))
            ],
          ),
    );

    // 선택값 반영
    if (selected != null) {
      setState(() {
        if (title == '직무' || title == '분야') {
          _selectedJob = selected;
        } else if (title == '지역') {
          _selectedLocation = selected;
        } else if (title == '기간') {
          _selectedPeriod = selected;
        } else if (title == '학력') {
          _selectedEducation = selected;
        }
      });
    }
    return selected;
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
                child: Column(children: _buildFilterWidgets()),
              ),
            ),
            // 적용 버튼
            FilterApplyButton(onApply: () {
              _applyFilters();
              Navigator.pop(context);
            }),
            // 상단 헤더 (제목, 리셋 버튼, 닫기 버튼 포함)
            FilterHeader(
              title: _presenter.getTabTitle(widget.tabIndex),
              onReset: _resetFilters,
              onClose: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // 탭 인덱스별 필터 위젯들 구성
  List<Widget> _buildFilterWidgets() {
    switch (widget.tabIndex) {
      case 0:
        return [
          const SizedBox(height: 10),
          FilterDropdown(
            title: '직무',
            options: _presenter.getJobOptions(0),
            selectedValue: _selectedJob,
            onTap: () => _selectValue('직무', _presenter.getJobOptions(0)),
          ),
          FilterRangeSlider(
            title: '경력',
            tabIndex: 0,
            currentRangeValues: _currentRangeValues,
            onChanged: (val) => setState(() => _currentRangeValues = val),
            presenter: _presenter,
          ),
          FilterDropdown(
            title: '지역',
            options: _presenter.getLocationOptions(0),
            selectedValue: _selectedLocation,
            onTap: () => _selectValue('지역', _presenter.getLocationOptions(0)),
          ),
          // 학력 필터를 다중 선택 필터로 변경
          FilterTagSelector(
            title: '학력',
            options: _presenter.getEducationOptions(),
            selected: null,
            tabIndex: 0,
            presenter: _presenter,
          ),
        ];
      case 1:
        return [
          const SizedBox(height: 10),
          FilterDropdown(
            title: '직무',
            options: _presenter.getJobOptions(1),
            selectedValue: _selectedJob,
            onTap: () => _selectValue('직무', _presenter.getJobOptions(1)),
          ),
          FilterRangeSlider(
            title: '경력',
            tabIndex: 1,
            currentRangeValues: _currentRangeValues,
            onChanged: (val) => setState(() => _currentRangeValues = val),
            presenter: _presenter,
          ),
          FilterDropdown(
            title: '지역',
            options: _presenter.getLocationOptions(1),
            selectedValue: _selectedLocation,
            onTap: () => _selectValue('지역', _presenter.getLocationOptions(1)),
          ),
          // 학력 필터를 다중 선택 필터로 변경
          FilterTagSelector(
            title: '학력',
            options: _presenter.getEducationOptions(),
            selected: null,
            tabIndex: 1,
            presenter: _presenter,
          ),
        ];
      case 2:
        return [
          const SizedBox(height: 10),
          FilterDropdown(
            title: '분야',
            options: _presenter.getFieldOptions(2),
            selectedValue: _selectedJob,
            onTap: () => _selectValue('분야', _presenter.getFieldOptions(2)),
          ),
          FilterRangeSlider(
            title: '기간',
            tabIndex: 2,
            currentRangeValues: _currentRangeValues,
            onChanged: (val) => setState(() => _currentRangeValues = val),
            presenter: _presenter,
          ),
          FilterDropdown(
            title: '지역',
            options: _presenter.getLocationOptions(2),
            selectedValue: _selectedLocation,
            onTap: () => _selectValue('지역', _presenter.getLocationOptions(2)),
          ),
          // 다중 선택 필터 - 프레젠터를 직접 사용
          FilterTagSelector(
            title: '주최기관',
            options: _presenter.getOrganizerOptions(2),
            selected: null, // 더이상 단일 값을 사용하지 않음
            tabIndex: 2,
            presenter: _presenter,
          ),
        ];
      case 3:
        return [
          const SizedBox(height: 10),
          FilterDropdown(
            title: '분야',
            options: _presenter.getFieldOptions(3),
            selectedValue: _selectedJob,
            onTap: () => _selectValue('분야', _presenter.getFieldOptions(3)),
          ),
          FilterRangeSlider(
            title: '기간',
            tabIndex: 3,
            currentRangeValues: _currentRangeValues,
            onChanged: (val) => setState(() => _currentRangeValues = val),
            presenter: _presenter,
          ),
          FilterDropdown(
            title: '지역',
            options: _presenter.getLocationOptions(3),
            selectedValue: _selectedLocation,
            onTap: () => _selectValue('지역', _presenter.getLocationOptions(3)),
          ),
          // 다중 선택 필터 - 프레젠터를 직접 사용
          FilterTagSelector(
            title: '온/오프라인',
            options: _presenter.getOnOfflineOptions(),
            selected: null, // 더이상 단일 값을 사용하지 않음
            tabIndex: 3,
            presenter: _presenter,
          ),
        ];
      default:
        return [
          const SizedBox(height: 10),
          FilterDropdown(
            title: '분야',
            options: _presenter.getFieldOptions(4),
            selectedValue: _selectedJob,
            onTap: () => _selectValue('분야', _presenter.getFieldOptions(4)),
          ),
          // 다중 선택 필터 - 프레젠터를 직접 사용
          FilterTagSelector(
            title: '대상',
            options: _presenter.getTargetOptions(),
            selected: null, // 더이상 단일 값을 사용하지 않음
            tabIndex: 4, 
            presenter: _presenter,
          ),
          FilterTagSelector(
            title: '주최기관',
            options: _presenter.getOrganizerOptions(4),
            selected: null, // 더이상 단일 값을 사용하지 않음
            tabIndex: 4,
            presenter: _presenter,
          ),
          FilterTagSelector(
            title: '혜택',
            options: _presenter.getBenefitOptions(),
            selected: null, // 더이상 단일 값을 사용하지 않음
            tabIndex: 4,
            presenter: _presenter,
          ),
        ];
    }
  }
}
