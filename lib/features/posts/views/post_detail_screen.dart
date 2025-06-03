import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/postsPostid_controller.dart';
import 'package:knowme_frontend/features/posts/models/postsPostid_model.dart';
import 'package:knowme_frontend/features/posts/widgets/post_text_widgets.dart';
import 'package:knowme_frontend/shared/widgets/base_scaffold.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;
  
  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final PostDetailController _controller;

  @override
  void initState() {
    super.initState();
    // 컨트롤러 초기화 및 폴링 시작
    _controller = Get.put(PostDetailController());
    
    // postId가 유효한 경우에만 폴링 시작
    if (widget.postId > 0) {
      _controller.startPolling(widget.postId);
    } else {
      // 유효하지 않은 postId 처리
      Future.microtask(() {
        Get.snackbar(
          '오류',
          '유효하지 않은 게시물 ID입니다',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back(); // 이전 화면으로 돌아가기
      });
    }
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    Get.delete<PostDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 0, // 공고 탭 활성화
      showBackButton: true, // 뒤로가기 버튼 표시
      onBack: () => Navigator.of(context).pop(), // 뒤로가기 동작
      backgroundColor: const Color(0xFFF5F5F5), // 배경색 변경
      body: Obx(() {
        if (_controller.isLoading && _controller.post == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '데이터를 불러오는 중 오류가 발생했습니다:\n${_controller.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _controller.fetchPostDetail(widget.postId),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        final post = _controller.post;
        if (post == null) {
          return const Center(child: Text('게시물을 찾을 수 없습니다.'));
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderImage(),
                  _buildPostContent(context, post),
                  const SizedBox(height: 70), // 플로팅 버튼을 위한 추가 공간
                ],
              ),
            ),
            _buildFloatingActionButton(context),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderImage() {
    return Image.asset(
      'assets/posts_images/image.png',
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
    );
  }

  Widget _buildPostContent(BuildContext context, PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(post),
          const SizedBox(height: 4),
          Text(
            post.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),

          const SectionTitle('회사 소개'),
          const SizedBox(height: 8),
          Text(
            post.description,
          ),
          const SizedBox(height: 8),
          if (post.attachments != null && post.attachments!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.attachments![0].url,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/posts_images/unsplash_JdcJn85xD2k.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),
          const SectionTitle('모집 부문'),
          const SizedBox(height: 8),
          Text(post.jobTitle ?? '프론트엔드 개발자 (신입/경력)'),

          const SizedBox(height: 24),
          const SubSectionTitle('담당 업무'),
          const SizedBox(height: 8),
          BulletList(post.requirements ?? const [
            '자사 웹 서비스 및 클라이언트 프로젝트의 프론트엔드 개발',
            '디자이너 및 백엔드 개발자와의 협업을 통한 UI 구현',
            '사용자 경험 개선 및 퍼포먼스 최적화',
          ]),

          if (post.benefits != null && post.benefits!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
            const SectionTitle('복지'),
            const SizedBox(height: 8),
            BulletList(post.benefits!),
          ],
          
          if (post.applicationPeriod != null) ...[
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
            const SectionTitle('지원 기간'),
            const SizedBox(height: 8),
            Text(
              '${_formatDate(post.applicationPeriod!.startDate)} ~ ${_formatDate(post.applicationPeriod!.endDate)}',
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 300,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF0068E5),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33184273),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // 지원 페이지나 다른 상세 정보로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('지원 페이지로 이동합니다')),
                );
              },
              child: const Center(
                child: Text(
                  '자세히 보기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF5F5F5),
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(PostModel post) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            post.company,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Transform.translate(
            offset: const Offset(5, 0),
            child: IconButton(
              icon: Icon(
                _controller.post?.isSaved == true ? Icons.bookmark : Icons.bookmark_border,
                color: _controller.post?.isSaved == true ? Colors.blue : null,
              ),
              onPressed: () {
                // TODO: 실제 사용자 ID 적용
                if (post.post_id != null) {
                  _controller.toggleBookmark(post.post_id!, 1);
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
