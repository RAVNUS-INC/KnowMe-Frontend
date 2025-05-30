import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/services/filter_options_service.dart';
import 'package:knowme_frontend/features/posts/views/post_detail_screen.dart';
import 'package:knowme_frontend/features/posts/views/post_list_screen.dart';
import 'package:knowme_frontend/features/recommendation/controllers/reommendation_controller.dart';
import 'package:knowme_frontend/features/recommendation/views/recommendation_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String postList = '/posts';
  static const String postDetail = '/posts/detail';
  static const String notification = '/notification';
  static const String chat = '/chat';
  static const String chatRoom = '/chat/room';
  static const String search = '/search';

  // 추천 활동 관련 라우트
  static const String recommendationScreen = '/recommendation';

  // 의존성 주입을 위한 공통 메서드
  static void dependencies() {
    // Controller 등록
    Get.put(PostController());
    Get.put(FilterController());
    Get.put(RecommendationController());
    
    // Services 등록
    Get.put(FilterOptionsService());
  }
  
  // main.dart에서 사용할 지연 의존성 주입
  static void lazyDependencies() {
    // 필터 옵션 서비스 등록
    Get.lazyPut(() => FilterOptionsService());
    
    // 필터 컨트롤러 등록
    Get.lazyPut(() => FilterController());
    
    // 추천 컨트롤러 등록
    Get.lazyPut(() => RecommendationController());
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
  
  static final Bindings recommendationBinding = BindingsBuilder(() {
    Get.put(RecommendationController());
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
    
    // 추천 활동 페이지
    GetPage(
      name: recommendationScreen,
      page: () => RecommendationScreen(),
      binding: recommendationBinding,
    ),
  ];
}
