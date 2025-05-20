import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knowme_frontend/feature/posts/controllers/PostController.dart';
import 'package:knowme_frontend/feature/posts/models/contest_model.dart';
import 'package:knowme_frontend/feature/posts/views/PostDetailScreen.dart';
import 'package:knowme_frontend/feature/posts/widgets/PostGrid.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> with SingleTickerProviderStateMixin {
  final List<String> tabTitles = ['채용', '인턴', '대외활동', '교육/강연', '공모전'];
  late TabController _tabController;
  final PageController _pageController = PageController();

  // 각 탭별 필터 상태 관리
  // 채용 필터
  String? selectedJob;
  String? selectedExperience;
  String? selectedLocation;
  String? selectedEducation;

  // 인턴 필터
  String? selectedInternJob;
  String? selectedPeriod;
  String? selectedInternLocation;
  String? selectedInternEducation;

  // 대외활동 필터
  String? selectedField;
  String? selectedOrganization;
  String? selectedActivityLocation;
  String? selectedHost;

  // 교육/강연 필터
  String? selectedEduField;
  String? selectedEduPeriod;
  String? selectedEduLocation;
  String? selectedOnOffline;

  // 공모전 필터
  String? selectedContestField;
  String? selectedTarget;
  String? selectedOrganizer;
  String? selectedBenefit;

  final PostsController _postsController = PostsController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this, initialIndex: 4); // 공모전 탭 초기 선택

    // TabBar와 PageView 연결
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
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
                setState(() {
                  _tabController.animateTo(index);
                });
              },
              itemCount: tabTitles.length,
              itemBuilder: (context, index) {
                // Controller를 통해 필터링된 포스트 목록 가져오기
                List<Contest> filteredContests = _postsController.getFilteredContentsByTabIndex(
                  index,
                  // 채용 필터
                  selectedJob: selectedJob,
                  selectedExperience: selectedExperience,
                  selectedLocation: selectedLocation,
                  selectedEducation: selectedEducation,
                  // 인턴 필터
                  selectedInternJob: selectedInternJob,
                  selectedPeriod: selectedPeriod,
                  selectedInternLocation: selectedInternLocation,
                  selectedInternEducation: selectedInternEducation,
                  // 대외활동 필터
                  selectedField: selectedField,
                  selectedOrganization: selectedOrganization,
                  selectedActivityLocation: selectedActivityLocation,
                  selectedHost: selectedHost,
                  // 교육/강연 필터
                  selectedEduField: selectedEduField,
                  selectedEduPeriod: selectedEduPeriod,
                  selectedEduLocation: selectedEduLocation,
                  selectedOnOffline: selectedOnOffline,
                  // 공모전 필터
                  selectedContestField: selectedContestField,
                  selectedTarget: selectedTarget,
                  selectedOrganizer: selectedOrganizer,
                  selectedBenefit: selectedBenefit,
                );

                return PostGrid(contests: filteredContests);
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

    switch (_tabController.index) {
      case 0: // 채용
        filterButtons = [
          _buildFilterButton('직무', selectedJob, (value) {
            setState(() => selectedJob = value);
          }),
          _buildFilterButton('신입~5년', selectedExperience, (value) {
            setState(() => selectedExperience = value);
          }),
          _buildFilterButton('서울 전체', selectedLocation, (value) {
            setState(() => selectedLocation = value);
          }),
          _buildFilterButton('학력', selectedEducation, (value) {
            setState(() => selectedEducation = value);
          }),
        ];
        break;

      case 1: // 인턴
        filterButtons = [
          _buildFilterButton('직무', selectedInternJob, (value) {
            setState(() => selectedInternJob = value);
          }),
          _buildFilterButton('기간', selectedPeriod, (value) {
            setState(() => selectedPeriod = value);
          }),
          _buildFilterButton('지역', selectedInternLocation, (value) {
            setState(() => selectedInternLocation = value);
          }),
          _buildFilterButton('학력', selectedInternEducation, (value) {
            setState(() => selectedInternEducation = value);
          }),
        ];
        break;

      case 2: // 대외활동
        filterButtons = [
          _buildFilterButton('분야', selectedField, (value) {
            setState(() => selectedField = value);
          }),
          _buildFilterButton('기관', selectedOrganization, (value) {
            setState(() => selectedOrganization = value);
          }),
          _buildFilterButton('지역', selectedActivityLocation, (value) {
            setState(() => selectedActivityLocation = value);
          }),
          _buildFilterButton('주최기관', selectedHost, (value) {
            setState(() => selectedHost = value);
          }),
        ];
        break;

      case 3: // 교육/강연
        filterButtons = [
          _buildFilterButton('분야', selectedEduField, (value) {
            setState(() => selectedEduField = value);
          }),
          _buildFilterButton('기간', selectedEduPeriod, (value) {
            setState(() => selectedEduPeriod = value);
          }),
          _buildFilterButton('지역', selectedEduLocation, (value) {
            setState(() => selectedEduLocation = value);
          }),
          _buildFilterButton('온/오프라인', selectedOnOffline, (value) {
            setState(() => selectedOnOffline = value);
          }),
        ];
        break;

      case 4: // 공모전
      default:
        filterButtons = [
          _buildFilterButton('분야', selectedContestField, (value) {
            setState(() => selectedContestField = value);
          }),
          _buildFilterButton('대상', selectedTarget, (value) {
            setState(() => selectedTarget = value);
          }),
          _buildFilterButton('주최기관', selectedOrganizer, (value) {
            setState(() => selectedOrganizer = value);
          }),
          _buildFilterButton('혜택', selectedBenefit, (value) {
            setState(() => selectedBenefit = value);
          }),
        ];
        break;
    }

    return Container(
      height: 50, // filter button row
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filterButtons.map((button) {
                  final index = filterButtons.indexOf(button);
                  return Row(
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

          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // 현재 탭에 따라 필터 초기화
              setState(() {
                switch (_tabController.index) {
                  case 0: // 채용
                    selectedJob = null;
                    selectedExperience = null;
                    selectedLocation = null;
                    selectedEducation = null;
                    break;
                  case 1: // 인턴
                    selectedInternJob = null;
                    selectedPeriod = null;
                    selectedInternLocation = null;
                    selectedInternEducation = null;
                    break;
                  case 2: // 대외활동
                    selectedField = null;
                    selectedOrganization = null;
                    selectedActivityLocation = null;
                    selectedHost = null;
                    break;
                  case 3: // 교육/강연
                    selectedEduField = null;
                    selectedEduPeriod = null;
                    selectedEduLocation = null;
                    selectedOnOffline = null;
                    break;
                  case 4: // 공모전
                    selectedContestField = null;
                    selectedTarget = null;
                    selectedOrganizer = null;
                    selectedBenefit = null;
                    break;
                }
              });
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
                      width: 50,
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
          ),
        ],
      ),
    );
  }

  // 정렬 옵션 아이템 위젯
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
              color: const Color(0xFF454C53),
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

  Widget _buildFilterButton(String text, String? selectedValue, Function(String?) onTap) {
    final bool isSelected = selectedValue != null;

    return GestureDetector(
      onTap: () async {
        // 필터 선택 다이얼로그 표시
        final result = await showDialog<String>(
          context: context,
          builder: (context) => FilterDialog(
            title: text,
            selectedValue: selectedValue,
            tabIndex: _tabController.index,
          ),
        );

        onTap(result);
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
            color: isSelected ? const Color(0xFFF5F5F5) : const Color(0xFF454C53),
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
    // 필터 옵션 (탭 인덱스와 필터 타이틀에 따라 결정)
    List<String> options = [];

    switch (tabIndex) {
      case 0: // 채용
        if (title == '직무') {
          options = ['개발', '마케팅', '디자인', '기획', '영업', '경영/인사', '회계/재무', '연구/설계', '기타'];
        } else if (title == '신입~5년') {
          options = ['신입', '1년 이하', '1~3년', '3~5년', '5년 이상'];
        } else if (title == '서울 전체') {
          options = ['서울 전체', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
        } else if (title == '학력') {
          options = ['고졸 이상', '초대졸 이상', '대졸 이상', '석사 이상', '박사 이상', '학력 무관'];
        }
        break;

      case 1: // 인턴
        if (title == '직무') {
          options = ['개발', '마케팅', '디자인', '기획', '영업', '경영/인사', '회계/재무', '연구/설계', '기타'];
        } else if (title == '기간') {
          options = ['1개월 이하', '1~3개월', '3~6개월', '6개월 이상'];
        } else if (title == '지역') {
          options = ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
        } else if (title == '학력') {
          options = ['고졸 이상', '초대졸 이상', '대졸 이상', '석사 이상', '박사 이상', '학력 무관'];
        }
        break;

      case 2: // 대외활동
        if (title == '분야') {
          options = ['IT', '디자인', '마케팅', '경영', '공학', '스타트업', '미디어', '환경', '교육', '기타'];
        } else if (title == '기관') {
          options = ['대학교', '기업', '정부기관', '비영리단체', '연구소', '기타'];
        } else if (title == '지역') {
          options = ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주', '온라인'];
        } else if (title == '주최기관') {
          options = ['기업', '정부/공공기관', '학교', '협회', '민간단체', '기타'];
        }
        break;

      case 3: // 교육/강연
        if (title == '분야') {
          options = ['IT/개발', '디자인', '마케팅', '경영', '금융', '어학', '취업준비', '자격증', '취미', '기타'];
        } else if (title == '기간') {
          options = ['1회성', '1개월 이하', '1~3개월', '3~6개월', '6개월 이상'];
        } else if (title == '지역') {
          options = ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
        } else if (title == '온/오프라인') {
          options = ['온라인', '오프라인', '혼합'];
        }
        break;

      case 4: // 공모전
      default:
        if (title == '분야') {
          options = ['IT', '디자인', '마케팅', '경영', '공학', '기타'];
        } else if (title == '대상') {
          options = ['대학생', '일반인', '청소년', '제한없음'];
        } else if (title == '주최기관') {
          options = ['기업', '정부/공공기관', '학교', '협회', '기타'];
        } else if (title == '혜택') {
          options = ['상금', '입사 가산점', '취업 연계', '해외연수', '기타'];
        }
        break;
    }

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
