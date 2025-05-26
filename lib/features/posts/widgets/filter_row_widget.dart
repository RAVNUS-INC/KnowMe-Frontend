import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/views/post_bottom_sheet.dart';

/// 필터 버튼을 표시하는 위젯
class FilterRowWidget extends StatelessWidget {
  final PostController postController;
  final TabController tabController;

  const FilterRowWidget({
    super.key,
    required this.postController,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Widget> filterButtons = _getFilterButtonsByTabIndex();

      return SizedBox(
        height: 50, // filter button row
        child: Row(
          children: [
            const SizedBox(width: 16), // 왼쪽 여백
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 필요한 만큼만 차지
                      children: filterButtons.map((button) {
                        final index = filterButtons.indexOf(button);
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            button,
                            if (index < filterButtons.length - 1)
                              const SizedBox(width: 8),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 16), // 오른쪽 여백
              child: GestureDetector(
                onTap: () {
                  // 현재 탭의 모든 필터 초기화
                  postController.resetFilters();

                  // 팝업 메뉴 표시
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        alignment: Alignment.topRight,
                        insetPadding: const EdgeInsets.only(top: 140, right: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const SortOptionsMenu(),
                      );
                    },
                  );
                },
                child: Container(
                  height: 33,
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFFDEE3E7),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/array.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 현재 선택된 탭 인덱스에 따라 필터 버튼 목록 반환
  List<Widget> _getFilterButtonsByTabIndex() {
    List<Widget> filterButtons = [];
    
    switch (postController.selectedTabIndex.value) {
      case 0: // 채용
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton('직무', postController.selectedJob.value, defaultText: '직무'),
          _buildFilterButton('경력', postController.selectedExperience.value, defaultText: '경력'),
          _buildFilterButton('지역', postController.selectedLocation.value, defaultText: '지역'),
          _buildMultiSelectFilterButton('학력', postController.multiSelectJobEducation, defaultText: '학력'),
        ];
        break;
      case 1: // 인턴
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton('직무', postController.selectedInternJob.value, defaultText: '직무'),
          _buildFilterButton('기간', postController.selectedPeriod.value, defaultText: '기간'),
          _buildFilterButton('지역', postController.selectedInternLocation.value, defaultText: '지역'),
          _buildMultiSelectFilterButton('학력', postController.multiSelectInternEducation, defaultText: '학력'),
        ];
        break;
      case 2: // 대외활동
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton('분야', postController.selectedField.value, defaultText: '분야'),
          _buildFilterButton('기간', postController.selectedActivityPeriod.value, defaultText: '기간'),
          _buildFilterButton('지역', postController.selectedActivityLocation.value, defaultText: '지역'),
          _buildMultiSelectFilterButton('주최기관', postController.multiSelectHost, defaultText: '주최기관'),
        ];
        break;
      case 3: // 교육/강연
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton('분야', postController.selectedEduField.value, defaultText: '분야'),
          _buildFilterButton('기간', postController.selectedEduPeriod.value, defaultText: '기간'),
          _buildFilterButton('지역', postController.selectedEduLocation.value, defaultText: '지역'),
          _buildMultiSelectFilterButton('온/오프라인', postController.multiSelectOnOffline, defaultText: '온/오프라인'),
        ];
        break;
      case 4: // 공모전
      default:
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton('분야', postController.selectedContestField.value, defaultText: '분야'),
          _buildMultiSelectFilterButton('대상', postController.multiSelectTarget, defaultText: '대상'),
          _buildMultiSelectFilterButton('주최기관', postController.multiSelectOrganizer, defaultText: '주최기관'),
          _buildMultiSelectFilterButton('혜택', postController.multiSelectBenefit, defaultText: '혜택'),
        ];
        break;
    }
    
    return filterButtons;
  }

  /// 일반 필터 버튼 위젯 생성 (단일 선택)
  Widget _buildFilterButton(String filterType, String? selectedValue, {required String defaultText}) {
    final bool isSelected = selectedValue != null;
    
    // 선택된 값이 있으면 그 값을 표시하고, 없으면 기본 텍스트를 표시
    final displayText = isSelected ? selectedValue : defaultText;

    return GestureDetector(
      onTap: () async {
        // 바텀 시트 표시
        await showModalBottomSheet<void>(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => FilterBottomSheet(
            title: filterType, // 필터 유형 전달
            selectedValue: selectedValue,
            tabIndex: tabController.index,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF89C1EF) : const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? const Color(0xFF89C1EF) : const Color(0xFFDEE3E7),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          displayText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF454C53),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.56,
          ),
        ),
      ),
    );
  }

  /// 다중 선택 필터 버튼 위젯 생성
  Widget _buildMultiSelectFilterButton(String filterType, RxList<String> selectedValues, {required String defaultText}) {
    // 선택된 값이 있는지 확인
    final bool isSelected = selectedValues.isNotEmpty;
    
    // 다중 선택의 경우, 선택된 항목 수를 표시 (예: "학력 (3)")
    String displayText = isSelected ? "$defaultText (${selectedValues.length})" : defaultText;
    
    // 선택된 값이 하나인 경우, 해당 값을 직접 표시
    if (selectedValues.length == 1) {
      displayText = selectedValues.first;
    }

    return GestureDetector(
      onTap: () async {
        // 바텀 시트 표시 (다중 선택 필터)
        await showModalBottomSheet<void>(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => FilterBottomSheet(
            title: filterType,
            tabIndex: tabController.index,
            selectedValue: null, // 다중 선택은 별도의 상태로 관리
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF89C1EF) : const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? const Color(0xFF89C1EF) : const Color(0xFFDEE3E7),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          displayText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF454C53),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.56,
          ),
        ),
      ),
    );
  }
}

/// 정렬 옵션 메뉴 위젯
class SortOptionsMenu extends StatelessWidget {
  const SortOptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSortOption(
            icon: 'assets/icons/Group.svg',
            title: '추천순',
            onTap: () {
              Navigator.pop(context);
              // 인기순으로 정렬 로직 구현
            },
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          _buildSortOption(
            icon: 'assets/icons/recent.svg',
            title: '최신 등록순',
            onTap: () {
              Navigator.pop(context);
              // 최신순으로 정렬 로직 구현
            },
          ),
        ],
      ),
    );
  }

  /// 정렬 옵션 아이템 위젯 생성
  Widget _buildSortOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 105,
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFF454C53),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF454C53),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
