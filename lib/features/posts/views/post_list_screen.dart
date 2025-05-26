import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/models/contest_model.dart';
// import 'package:knowme_frontend/features/posts/views/post_detail_screen.dart';
import 'package:knowme_frontend/features/posts/widgets/post_grid.dart';
import 'package:knowme_frontend/features/posts/views/post_bottom_sheet.dart'; // FilterDialog 참조를 위해 새로운 import 추가

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> with SingleTickerProviderStateMixin {
  final List<String> tabTitles = ['채용', '인턴', '대외활동', '교육/강연', '공모전'];
  late TabController _tabController;
  final PageController _pageController = PageController();

  // GetX Controller 인스턴스화
  final PostController _postController = Get.put(PostController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabTitles.length,
      vsync: this,
      initialIndex: _postController.currentTabIndex.value,
    );

    // TabBar와 PageView 연결
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        // GetX Controller에 현재 탭 인덱스 업데이트
        _postController.changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEFF0),
      appBar: const CustomPostListAppBar(),
      body: Column(
        children: [
          // 상단 고정 영역
          _buildTabBar(),
          _buildFilterRow(),

          // 스크롤 가능한 콘텐츠 영역
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                _tabController.animateTo(index);
                // GetX Controller에 현재 탭 인덱스 업데이트
                _postController.changeTab(index);
              },
              itemCount: tabTitles.length,
              itemBuilder: (context, index) {
                // GetX를 사용하여 상태 변화 감지 및 UI 업데이트
                return Obx(() {
                  List<Contest> filteredContests = _postController.getFilteredContentsByTabIndex(index);
                  return PostGrid(contests: filteredContests);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 53,
      decoration: const BoxDecoration(color: Colors.white), // 배경색을 하얀색으로 변경
      child: TabBar(
        controller: _tabController,
        isScrollable: false, // 스크롤 불가능하게 설정하여 항상 균등 배치
        indicatorColor: const Color(0xFF0068E5),
        indicatorWeight: 3,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.fill, // 화면 너비를 고르게 분할
        labelColor: const Color(0xFF232323),
        unselectedLabelColor: const Color(0xFFB7C4D4),
        labelStyle: const TextStyle(
          fontSize: 19, // 글자 크기 19포인트로 변경
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.64,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 19, // 글자 크기 19포인트로 변경
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.64,
        ),
        tabs: tabTitles.map((title) => Tab(
          child: SizedBox(
            width: double.infinity, // 탭의 너비를 최대로 설정
            child: Text(
              title,
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildFilterRow() {
    // 현재 활성화된 탭 인덱스에 따라 필터 버튼 생성
    List<Widget> filterButtons = [];

    return Obx(() {
      switch (_postController.currentTabIndex.value) {
        case 0: // 채용
          filterButtons = [
            const SizedBox(height: 10),
            _buildFilterButton('직무', _postController.selectedJob.value),
            _buildFilterButton('신입~5년', _postController.selectedExperience.value),
            _buildFilterButton('서울 전체', _postController.selectedLocation.value),
            _buildFilterButton('학력', _postController.selectedEducation.value),
          ];
          break;
        case 1: // 인턴
          filterButtons = [
            const SizedBox(height: 10),
            _buildFilterButton('직무', _postController.selectedInternJob.value),
            _buildFilterButton('경력', _postController.selectedPeriod.value),
            _buildFilterButton('지역', _postController.selectedInternLocation.value),
            _buildFilterButton('학력', _postController.selectedInternEducation.value),
          ];
          break;
        case 2: // 대외활동
          filterButtons = [
            const SizedBox(height: 10),
            _buildFilterButton('분야', _postController.selectedField.value),
            _buildFilterButton('기간', _postController.selectedActivityPeriod.value),
            _buildFilterButton('지역', _postController.selectedActivityLocation.value),
            _buildFilterButton('주최기관', _postController.selectedHost.value),
          ];
          break;
        case 3: // 교육/강연
          filterButtons = [
            const SizedBox(height: 10),
            _buildFilterButton('분야', _postController.selectedEduField.value),
            _buildFilterButton('기간', _postController.selectedEduPeriod.value),
            _buildFilterButton('지역', _postController.selectedEduLocation.value),
            _buildFilterButton('온/오프라인', _postController.selectedOnOffline.value),
          ];
          break;
        case 4: // 공모전
        default:
          filterButtons = [
            const SizedBox(height: 10),
            _buildFilterButton('분야', _postController.selectedContestField.value),
            _buildFilterButton('대상', _postController.selectedTarget.value),
            _buildFilterButton('주최기관', _postController.selectedOrganizer.value),
            _buildFilterButton('혜택', _postController.selectedBenefit.value),
          ];
          break;
      }

      return Container(
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
                  _postController.resetFilters();

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
                        child: Container(
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
                      ),
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
              )  ),
          ],
        ),
      );
    });
  }

  // 수정된 _buildFilterButton - 이제 controller를 통해 값 업데이트 및 바텀 시트 사용
  Widget _buildFilterButton(String text, String? selectedValue) {
    final bool isSelected = selectedValue != null;

    return GestureDetector(
      onTap: () async {
        // 바텀 시트 표시 (알림 대화상자 대신)
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true, // 전체 화면 크기 허용
          backgroundColor: Colors.transparent, // 배경 투명하게
          builder: (context) => FilterBottomSheet(
            title: text,
            selectedValue: selectedValue,
            tabIndex: _tabController.index,
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
          text,
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

  Widget _buildSortOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 105, // Figma width: 105.dp
        height: 32, // Figma height: 32.dp
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), // Figma padding
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
            const SizedBox(width: 4), // Figma spacedBy(4.dp)
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF454C53),
                fontSize: 14, // 14 포인트
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

class CustomPostListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomPostListAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      titleSpacing: 16, // 로고와 왼쪽 여백 사이 간격 조정
      title: Image.asset(
        'assets/logos/logor가로@2x.png',
        height: 30,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: const VisualDensity(horizontal: -3.0, vertical: -3.0),
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  'assets/icons/Search.svg',
                  width: 25,
                ),
                onPressed: () {},
              ),
              IconButton(
                visualDensity: const VisualDensity(horizontal: -3.0, vertical: -3.0),
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  'assets/icons/bell.svg',
                  width: 25,
                ),
                onPressed: () {},
              ),
              IconButton(
                visualDensity: const VisualDensity(horizontal: -3.0, vertical: -3.0),
                padding: const EdgeInsets.only(left: -3.5, right: 5),
                icon: SvgPicture.asset(
                  'assets/icons/user.svg',
                  width: 25,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

