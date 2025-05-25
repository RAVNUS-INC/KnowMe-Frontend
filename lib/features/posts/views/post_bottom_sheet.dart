import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knowme_frontend/features/posts/presenters/filter_presenter.dart';
import 'package:knowme_frontend/features/posts/models/filter_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final String title;
  final String? selectedValue;
  final int tabIndex;

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
  // Presenter 인스턴스
  late FilterPresenter _presenter;
  
  // 슬라이더 값
  RangeValues _currentRangeValues = const RangeValues(0, 5);

  // 선택된 학력 옵션
  String? _selectedEducation;

  // 선택된 직무/분야
  String? _selectedJob;

  // 선택된 지역
  String? _selectedLocation;

  // 선택된 기간
  String? _selectedPeriod;

  @override
  void initState() {
    super.initState();
    // Presenter 초기화
    _presenter = Get.find<FilterPresenter>();
    
    // 현재 값 초기화
    _initializeValues();
  }

  void _initializeValues() {
    // Presenter에서 현재 탭에 대한 값들을 가져옴
    final filterValues = _presenter.getFilterValues(widget.tabIndex);
    
    setState(() {
      _selectedJob = filterValues.job;
      _selectedLocation = filterValues.location;
      _selectedEducation = filterValues.education;
      _selectedPeriod = filterValues.period;
      
      // 슬라이더 값 설정
      _currentRangeValues = _presenter.getSliderValues(widget.tabIndex);
    });
  }
  
  // 필터 옵션 초기화 함수
  void _resetFilters() {
    setState(() {
      _selectedJob = null;
      _selectedLocation = null;
      _selectedEducation = null;
      _selectedPeriod = null;
      
      // 슬라이더 값 초기화
      SliderConfig config = _presenter.getSliderConfig(widget.tabIndex);
      _currentRangeValues = RangeValues(config.min, config.min + (config.max - config.min) / 4);
    });
    
    // Presenter에도 초기화 상태를 알려주기
    _presenter.resetFiltersForTab(widget.tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 바텀시트 높이를 화면 높이의 5/7로 설정
    final sheetHeight = screenHeight * 3/4;
    
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
            // 필터 콘텐츠 영역 (스크롤 가능)
            Positioned(
              left: 0,
              top: 51,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  width: screenWidth,
                  padding: const EdgeInsets.only(bottom: 80), // 적용 버튼을 위한 여백
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 필터 본문 영역
                      Container(
                        width: screenWidth,
                        padding: const EdgeInsets.only(top: 16, bottom: 32),
                        decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 헤더 부분 (탭 이름)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _presenter.getTabTitle(widget.tabIndex),
                                        style: const TextStyle(
                                          color: Color(0xFF0068E5),
                                          fontSize: 18,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.72,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // 리프레시 아이콘 추가
                                    GestureDetector(
                                      onTap: _resetFilters,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: SvgPicture.asset(
                                          'assets/icons/refresh.svg',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const Divider(height: 1, thickness: 1, color: Color(0xFFDEE3E7)),
                            const SizedBox(height: 16),

                            // 각 탭별 필터 옵션
                            ..._buildFilterOptions(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 적용 버튼 (고정 위치) - 분리된 메서드 호출
            _buildApplyButton(),

            // 상단 헤더 영역 (고정 위치)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                width: screenWidth,
                padding: const EdgeInsets.all(16),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Color(0xCCF5F5F5)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 취소(X) 아이콘으로 변경
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            'assets/icons/cancel.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 각 탭에 맞는 필터 옵션 위젯 리스트 생성
  List<Widget> _buildFilterOptions() {
    switch (widget.tabIndex) {
      case 0: // 채용
        return [
          _buildDropdownFilter('직무', _presenter.getJobOptions(0), _selectedJob),
          _buildRangeSliderFilter('경력', '신입', '20년'),
          _buildDropdownFilter('지역', _presenter.getLocationOptions(0), _selectedLocation),
          _buildEducationFilter('학력'),
        ];
      case 1: // 인턴
        return [
          _buildDropdownFilter('직무', _presenter.getJobOptions(1), _selectedJob),
          _buildRangeSliderFilter('기간', '1개월', '2년'),
          _buildDropdownFilter('지역', _presenter.getLocationOptions(1), _selectedLocation),
          _buildEducationFilter('학력'),
        ];
      case 2: // 대외활동
        return [
          _buildDropdownFilter('분야', _presenter.getFieldOptions(2), _selectedJob),
          _buildRangeSliderFilter('기간', '1개월', '2년'),
          _buildDropdownFilter('지역', _presenter.getLocationOptions(2), _selectedLocation),
          _buildMultiSelectFilter('주최기관', _presenter.getOrganizerOptions(2), _presenter.getSelectedHost()),
        ];
      case 3: // 교육/강연
        return [
          _buildDropdownFilter('분야', _presenter.getFieldOptions(3), _selectedJob),
          _buildRangeSliderFilter('기간', '1일', '6개월'),
          _buildDropdownFilter('지역', _presenter.getLocationOptions(3), _selectedLocation),
          _buildDropdownFilter('온/오프라인', _presenter.getOnOfflineOptions(), _presenter.getSelectedOnOffline()),
        ];
      case 4: // 공모전
      default:
        return [
          _buildDropdownFilter('분야', _presenter.getFieldOptions(4), _selectedJob),
          _buildMultiSelectFilter('대상', _presenter.getTargetOptions(), _presenter.getSelectedTarget()),
          _buildMultiSelectFilter('주최기관', _presenter.getOrganizerOptions(4), _presenter.getSelectedOrganizer()),
          _buildMultiSelectFilter('혜택', _presenter.getBenefitOptions(), _presenter.getSelectedBenefit()),
        ];
    }
  }

  // 드롭다운 필터 위젯 생성
  Widget _buildDropdownFilter(String title, List<String> options, String? selectedValue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 344,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF454C53),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.56,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final result = await _showOptionsDialog(context, title, options, selectedValue);
              if (result != null) {
                setState(() {
                  if (title == '직무' || title == '분야') {
                    _selectedJob = result;
                  } else if (title == '지역') {
                    _selectedLocation = result;
                  } else if (title == '기간') {
                    _selectedPeriod = result;
                  } else if (title == '온/오프라인') {
                    _presenter.updateOnOfflineValue(result);
                  }
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: ShapeDecoration(
                color: const Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: selectedValue != null ? const Color(0xFF232323) : const Color(0xFFB7C4D4),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            selectedValue ?? '전체',
                            style: TextStyle(
                              color: selectedValue != null ? const Color(0xFF232323) : const Color(0xFFB7C4D4),
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.48,
                            ),
                          ),
                          Transform.rotate(
                            angle: -1.57, // -90도
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 14,
                              color: Color(0xFFB7C4D4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 범위 슬라이더 필터 위젯 생성
  Widget _buildRangeSliderFilter(String title, String startLabel, String endLabel) {
    // Presenter에서 슬라이더 설정 가져오기
    SliderConfig config = _presenter.getSliderConfig(widget.tabIndex);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 344,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF454C53),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.56,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 343,
            height: 48,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 36,
                  child: Container(
                    width: 343,
                    height: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          config.startLabel,
                          style: TextStyle(
                            color: const Color(0xFF0068E5),
                            fontSize: 10,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.40,
                          ),
                        ),
                        Text(
                          config.endLabel,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF0068E5),
                            fontSize: 10,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor: const Color(0xFF0068E5),
                    inactiveTrackColor: const Color(0xFFDEE3E7),
                    thumbColor: Colors.white,
                    overlayColor: const Color(0x290068E5),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 6),
                    rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                    rangeTickMarkShape: const RoundRangeSliderTickMarkShape(),
                    // 라벨 텍스트 및 배경 스타일 수정 - 직사각형 모양, 크기 축소
                    valueIndicatorColor: const Color(0xFF0068E5), // 라벨 배경색 파란색
                    valueIndicatorShape: const RectangularSliderValueIndicatorShape(), // 직사각형 모양으로 변경
                    valueIndicatorTextStyle: const TextStyle(
                      color: Colors.white, // 라벨 내 텍스트 색상
                      fontSize: 12, // 텍스트 크기 감소
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400, // 폰트 두께 감소
                    ),
                  ),
                  child: RangeSlider(
                    values: _currentRangeValues,
                    min: config.min,
                    max: config.max,
                    divisions: config.divisions,
                    labels: RangeLabels(
                      _presenter.formatSliderLabel(_currentRangeValues.start, widget.tabIndex),
                      _presenter.formatSliderLabel(_currentRangeValues.end, widget.tabIndex),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = _presenter.adjustSliderValues(values, config, _currentRangeValues);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 학력 필터 위젯 생성
  Widget _buildEducationFilter(String title) {
    final options = _presenter.getEducationOptions();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 344,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF454C53),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.56,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 8,
            children: options.map((option) {
              final bool isSelected = option == _selectedEducation;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEducation = isSelected ? null : option;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: ShapeDecoration(
                    color: isSelected ? const Color(0xFF0068E5) : const Color(0xFFDEE3E7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFF5F5F5) : const Color(0xFF454C53),
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.48,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 다중 선택 필터 위젯 생성
  Widget _buildMultiSelectFilter(String title, List<String> options, String? selectedValue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 344,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF454C53),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.56,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 8,
              children: options.map((option) {
                final bool isSelected = option == selectedValue;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Presenter를 통해 값 업데이트
                      _presenter.updateMultiSelectValue(widget.tabIndex, title, option, isSelected);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: ShapeDecoration(
                      color: isSelected ? const Color(0xFF0068E5) : const Color(0xFFDEE3E7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          option == '전체' && isSelected ? '전체' : option,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFF5F5F5) : const Color(0xFF454C53),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.48,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 옵션 다이얼로그 표시
  Future<String?> _showOptionsDialog(
      BuildContext context,
      String title,
      List<String> options,
      String? selectedValue
      ) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$title 선택'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final bool isSelected = option == selectedValue;

              return ListTile(
                title: Text(option),
                selected: isSelected,
                trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF0068E5)) : null,
                onTap: () {
                  // 이미 선택된 옵션을 다시 클릭하면 선택 해제됨
                  Navigator.of(context).pop(isSelected ? null : option);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('취소'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // 필터 적용 메서드
  void _applyFilters() {
    // Presenter에 현재 선택한 값들 전달
    _presenter.applyFilters(
      tabIndex: widget.tabIndex,
      job: _selectedJob,
      location: _selectedLocation,
      education: _selectedEducation,
      period: _selectedPeriod,
      rangeValues: _currentRangeValues,
    );
  }

  // 적용 버튼 (고정 위치)
  Positioned _buildApplyButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20, // 하단에서 20픽셀 위에 위치
      child: Center(
        child: GestureDetector(
          onTap: () {
            // 현재 UI에 선택된 필터값을 적용
            _applyFilters();
            Navigator.pop(context);
          },
          child: Container(
            width: 300,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: ShapeDecoration(
              color: const Color(0xFF0068E5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              shadows: const [
                BoxShadow(
                  color: Color(0x33184173),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 260,
                  child: Text(
                    '적용',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontSize: 18,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.72,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// FilterDialog 클래스 유지
class FilterDialog extends StatelessWidget {
  final String title;
  final String? selectedValue;
  final int tabIndex;

  const FilterDialog({
    Key? key,
    required this.title,
    this.selectedValue,
    required this.tabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterPresenter presenter = Get.find<FilterPresenter>();
    List<String> options = presenter.getOptionsForDialog(tabIndex, title);

    return AlertDialog(
      title: Text('$title 선택'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final bool isSelected = option == selectedValue;

            return ListTile(
              title: Text(option),
              selected: isSelected,
              trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF0068E5)) : null,
              onTap: () {
                // 이미 선택된 옵션을 다시 클릭하면 선택 해제됨
                Navigator.of(context).pop(isSelected ? null : option);
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('취소'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
