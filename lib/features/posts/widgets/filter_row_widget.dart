import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/views/post_bottom_sheet.dart';

class FilterRowWidget extends StatelessWidget {
  final TabController tabController;

  const FilterRowWidget({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    // View에서 컨트롤러를 직접 생성하지 않고 Get.find()로 가져옴
    final PostController postController = Get.find<PostController>();

    return Obx(() {
      // 클래스 메소드 호출 시 postController를 전달
      final List<Widget> filterButtons =
      _getFilterButtonsByTabIndex(postController);

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

                  // 정렬 옵션 버튼의 위치 계산을 위한 RenderBox 가져오기
                  final RenderBox button =
                  context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final buttonPosition =
                  button.localToGlobal(Offset.zero, ancestor: overlay);

                  // 팝업 메뉴 표시
                  showDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Stack(
                        children: [
                          Positioned(
                            top: buttonPosition.dy +
                                35, // FilterRowWidget 바로 아래 위치
                            right: 16, // 오른쪽 여백 16 유지
                            child: SizedBox(
                              width: 120, // 가로 길이 105로 고정
                              child: Dialog(
                                alignment: Alignment.topRight,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const SortOptionsMenu(),
                              ),
                            ),
                          ),
                        ],
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
  List<Widget> _getFilterButtonsByTabIndex(PostController postController) {
    List<Widget> filterButtons = [];
    final currentTabIndex = postController.selectedTabIndex.value;

    switch (currentTabIndex) {
      case 0: // 채용
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton(postController, '직무',
              postController.getFilterByType(currentTabIndex, '직무').value,
              defaultText: '직무'),
          _buildFilterButton(postController, '경력',
              postController.getFilterByType(currentTabIndex, '신입~5년').value,
              defaultText: '경력'),
          _buildFilterButton(postController, '지역',
              postController.getFilterByType(currentTabIndex, '지역').value,
              defaultText: '지역'),
          _buildMultiSelectFilterButton(
              postController, '학력', postController.multiSelectJobEducation,
              defaultText: '학력'),
        ];
        break;
      case 1: // 인턴
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton(postController, '직무',
              postController.getFilterByType(currentTabIndex, '직무').value,
              defaultText: '직무'),
          _buildFilterButton(postController, '기간',
              postController.getFilterByType(currentTabIndex, '기간').value,
              defaultText: '기간'),
          _buildFilterButton(postController, '지역',
              postController.getFilterByType(currentTabIndex, '지역').value,
              defaultText: '지역'),
          _buildMultiSelectFilterButton(
              postController, '학력', postController.multiSelectInternEducation,
              defaultText: '학력'),
        ];
        break;
      case 2: // 대외활동
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton(postController, '분야',
              postController.getFilterByType(currentTabIndex, '분야').value,
              defaultText: '분야'),
          _buildFilterButton(postController, '기간',
              postController.getFilterByType(currentTabIndex, '기간').value,
              defaultText: '기간'),
          _buildFilterButton(postController, '지역',
              postController.getFilterByType(currentTabIndex, '지역').value,
              defaultText: '지역'),
          _buildMultiSelectFilterButton(
              postController, '주최기관', postController.multiSelectHost,
              defaultText: '주최기관'),
        ];
        break;
      case 3: // 교육/강연
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton(postController, '분야',
              postController.getFilterByType(currentTabIndex, '분야').value,
              defaultText: '분야'),
          _buildFilterButton(postController, '기간',
              postController.getFilterByType(currentTabIndex, '기간').value,
              defaultText: '기간'),
          _buildFilterButton(postController, '지역',
              postController.getFilterByType(currentTabIndex, '지역').value,
              defaultText: '지역'),
          _buildMultiSelectFilterButton(
              postController, '온/오프라인', postController.multiSelectOnOffline,
              defaultText: '온/오프라인'),
        ];
        break;
      case 4: // 공모전
      default:
        filterButtons = [
          const SizedBox(height: 10),
          _buildFilterButton(postController, '분야',
              postController.getFilterByType(currentTabIndex, '분야').value,
              defaultText: '분야'),
          _buildMultiSelectFilterButton(
              postController, '대상', postController.multiSelectTarget,
              defaultText: '대상'),
          _buildMultiSelectFilterButton(
              postController, '주최기관', postController.multiSelectOrganizer,
              defaultText: '주최기관'),
          _buildMultiSelectFilterButton(
              postController, '혜택', postController.multiSelectBenefit,
              defaultText: '혜택'),
        ];
        break;
    }

    return filterButtons;
  }

  /// 일반 필터 버튼 위젯 생성 (단일 선택)
  Widget _buildFilterButton(
      PostController postController, String filterType, String? selectedValue,
      {required String defaultText}) {
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
              color: isSelected
                  ? const Color(0xFF89C1EF)
                  : const Color(0xFFDEE3E7),
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
  Widget _buildMultiSelectFilterButton(PostController postController,
      String filterType, RxList<String> selectedValues,
      {required String defaultText}) {
    // 선택된 값이 있는지 확인
    final bool isSelected = selectedValues.isNotEmpty;

    // 다중 선택의 경우, 선택된 항목 수를 표시 (예: "학력 (3)")
    String displayText =
    isSelected ? "$defaultText (${selectedValues.length})" : defaultText;

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
              color: isSelected
                  ? const Color(0xFF89C1EF)
                  : const Color(0xFFDEE3E7),
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
      width: 120, // 정확한 너비 지정 105
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
        width: 105, // Figma에서 지정한 너비
        height: 32, // 각 옵션의 높이
        padding: const EdgeInsets.all(6),
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
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
            const SizedBox(width: 5), // spacing: 4 대체
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF454C53),
                fontSize: 13, // Figma 디자인에 맞게 폰트 크기 조정
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}