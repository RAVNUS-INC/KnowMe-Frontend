import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/models/contests_model.dart';
import 'package:knowme_frontend/features/posts/widgets/post_grid.dart';
import 'package:knowme_frontend/features/posts/widgets/post_tab_bar.dart';
import 'package:knowme_frontend/features/posts/widgets/filter_row_widget.dart';
import 'package:knowme_frontend/shared/widgets/base_scaffold.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen>
    with SingleTickerProviderStateMixin {
  final List<String> tabTitles = ['채용', '인턴', '대외활동', '교육/강연', '공모전'];
  late TabController _tabController;

  // View에서 직접 생성하지 않고 routes에서 주입된 컨트롤러 사용
  late PostController _postController;

  @override
  void initState() {
    super.initState();

    // 1) 컨트롤러 주입받기
    _postController = Get.find<PostController>();

    // 2) Get.arguments에서 tabIndex를 받아옴 (+ PostController에도 반영)
    int initialIndex = 0;
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      if (args.containsKey('tabIndex') && args['tabIndex'] is int) {
        initialIndex = args['tabIndex'];
        // ← 이 부분을 바로 실행하지 않고, 빌드 이후에 실행하도록 한다.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _postController.selectedTabIndex.value = initialIndex;
        });
      }
    }

    // 3) TabController 초기화
    _tabController = TabController(
      length: tabTitles.length,
      vsync: this,
      initialIndex: initialIndex,
    );

    // 4) TabBar와 PageView 연결 (사용자 스와이프/탭 변경 시 changeTab 호출)
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _postController.changeTab(_tabController.index);
      }
    });

    // 5) 화면 띄운 직후 PageController가 들어오면 초기 페이지로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_postController.pageController.hasClients) {
        _postController.pageController.jumpToPage(initialIndex);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 0, // '공고' 탭 인덱스
      backgroundColor: const Color(0xFFEEEFF0),
      body: Column(
        children: [
          // 상단 고정 영역: 탭 바
          PostTabBar(
            tabController: _tabController,
            tabTitles: tabTitles,
          ),

          // 필터 행 위젯
          FilterRowWidget(
            tabController: _tabController,
          ),

          // 스크롤 가능한 콘텐츠 영역
          Expanded(
            child: PageView.builder(
              controller: _postController.pageController,
              onPageChanged: (index) {
                // 사용자 스와이프 시 _tabController에 반영
                if (_tabController.index != index) {
                  _tabController.animateTo(index);
                }

                // 빌드 이후에 탭 전환 처리
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _postController.onPageChanged(index);
                });
              },
              itemCount: tabTitles.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  // // 현재 탭이면 데이터 표시, 아니면 플레이스홀더
                  // if (_postController.selectedTabIndex.value == index) {
                  //   if (_postController.isLoading.value) {
                  //     return const Center(child: CircularProgressIndicator());
                  //   } else {
                  //     return PostGrid(contests: _postController.contests);
                  //   }
                  // } else {
                  //   // 플레이스홀더를 보여줄 때 콘솔에 로그를 찍음
                  //   print('[$index] 탭이 선택되지 않아 플레이스홀더 표시');
                  //   return Center(child: Text("탭을 선택하면 데이터가 로드됩니다"));
                  // 1) 현재 탭이 로딩 중이면서 해당 index라면 로딩 인디케이터 표시
                  if (_postController.isLoading.value &&
                      _postController.selectedTabIndex.value == index) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2) 캐시 데이터를 가져오되, null이면 (캐시가 없으면)
                  //    - 현재 탭이면 controller.contests 사용
                  //    - 아니라면 빈 리스트 전달
                  final cachedList = _postController.getCachedContests(index);
                  final dataToShow = (cachedList != null)
                      ? cachedList
                      : (_postController.selectedTabIndex.value == index
                      ? _postController.contests
                      : <Contest>[]);

                  return PostGrid(contests: dataToShow);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}