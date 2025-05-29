import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/services/filter_options_service.dart';
import 'package:knowme_frontend/features/posts/views/post_detail_screen.dart';
import 'package:knowme_frontend/features/posts/views/post_list_screen.dart';

class AppRoutes {
  // 포스트 관련 라우트
  static const String postList = '/post-list';
  static const String postDetail = '/post-detail';

  // 의존성 주입을 위한 공통 메서드
  static void dependencies() {
    // Controller 등록
    Get.put(PostController());
    Get.put(FilterController());
    
    // Services 등록
    Get.put(FilterOptionsService());
  }
  
  // main.dart에서 사용할 지연 의존성 주입
  static void lazyDependencies() {
    // 필터 옵션 서비스 등록
    Get.lazyPut(() => FilterOptionsService());
    
    // 필터 컨트롤러 등록
    Get.lazyPut(() => FilterController());
  }
  
  // 각 화면별 바인딩 클래스 정의
  static final Bindings postListBinding = BindingsBuilder(() {
    Get.put(PostController());
    Get.put(FilterController());
    Get.put(FilterOptionsService());
  });

  static final Bindings postDetailBinding = BindingsBuilder(() {
    Get.put(PostController());
  });
  
  // 라우트 목록
  static final routes = [
    // 포스트 관련 페이지들
    GetPage(
      name: postList,
      page: () => const PostListScreen(),
      binding: postListBinding,
    ),
    GetPage(
      name: postDetail,
      page: () => const PostDetailScreen(),
      binding: postDetailBinding,
    ),
  ];
}
