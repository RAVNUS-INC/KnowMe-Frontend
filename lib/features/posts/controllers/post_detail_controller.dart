import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/post_detail_dtos.dart';
import '../services/post_detail_api_service.dart';

/// 공고 상세 화면 컨트롤러
class PostDetailController extends GetxController {
  final PostDetailApiService _apiService = PostDetailApiService();
  final Logger _logger = Logger();

  // 상태 변수들
  final Rx<PostDetailDto?> postDetail = Rx<PostDetailDto?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isBookmarked = false.obs;
  final RxString errorMessage = ''.obs;

  // 공고 ID
  late final int postId;

  @override
  void onInit() {
    super.onInit();

    // Get.arguments에서 postId 받아오기
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      postId = args['postId'] ?? 0;

      if (postId > 0) {
        loadPostDetail();
      } else {
        errorMessage.value = '잘못된 공고 ID입니다.';
      }
    } else {
      errorMessage.value = '공고 정보를 불러올 수 없습니다.';
    }
  }

  /// 공고 상세 정보 로드
  Future<void> loadPostDetail() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      _logger.d('공고 상세 정보 로드 시작 - postId: $postId');

      final response = await _apiService.getPostDetail(postId);

      if (response.isSuccess && response.data != null) {
        postDetail.value = response.data!;
        _logger.d('공고 상세 정보 로드 성공: ${postDetail.value!.title}');
      } else {
        errorMessage.value = response.message ?? '공고 상세 정보를 불러올 수 없습니다.';
        _logger.e('공고 상세 정보 로드 실패: ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = '네트워크 오류가 발생했습니다.';
      _logger.e('공고 상세 정보 로드 예외: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 북마크 토글
  void toggleBookmark() {
    isBookmarked.value = !isBookmarked.value;

    // TODO: 북마크 API 호출
    _logger.d('북마크 상태 변경: ${isBookmarked.value}');

    // 사용자에게 피드백 제공
    Get.snackbar(
      '북마크',
      isBookmarked.value ? '북마크에 추가되었습니다.' : '북마크에서 제거되었습니다.',
      duration: const Duration(seconds: 2),
    );
  }

  /// 외부 링크로 이동 (상세보기 버튼)
  void navigateToExternalLink() {
    final post = postDetail.value;
    if (post == null) return;

    // TODO: 외부 링크 열기 또는 지원 페이지로 이동
    _logger.d('외부 링크 이동: ${post.title}');

    Get.snackbar(
      '알림',
      '해당 공고의 상세 페이지로 이동합니다.',
      duration: const Duration(seconds: 2),
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadPostDetail();
  }

  /// 공고 카테고리에 따른 표시 정보 가져오기
  String getCategoryDisplayName() {
    final post = postDetail.value;
    if (post == null) return '';

    switch (post.category.toLowerCase()) {
      case 'job':
        return '채용';
      case 'internship':
        return '인턴';
      case 'activity':
        return '대외활동';
      case 'education':
        return '교육/강연';
      case 'contest':
        return '공모전';
      default:
        return post.category;
    }
  }

  /// 공고 상태 확인 (마감일 기준)
  bool get isExpired {
    // TODO: 실제 마감일 로직 구현
    return false;
  }

  /// 공고 D-Day 계산
  String get dDay {
    // TODO: 실제 마감일 기반 D-Day 계산
    return 'D-30';
  }
}