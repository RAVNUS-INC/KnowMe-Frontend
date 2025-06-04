import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../models/activity_record.dart';
import '../controllers/activity_controller.dart';
import '../views/activity_common.dart';

// 활동 상세 페이지 - API 데이터 연동 버전
class ActivityDetailScreen extends StatefulWidget {
  final Project project;
  const ActivityDetailScreen({super.key, required this.project});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  late ActivityController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<ActivityController>();

    // portfolioId 유효성 검사
    if (widget.project.portfolioId <= 0) {
      print('Error: Invalid portfolioId: ${widget.project.portfolioId}');
      print('Project data: ${widget.project.toJson()}');
      // 에러 상태로 설정
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.detailErrorMessage.value =
            'Invalid activity ID: ${widget.project.portfolioId}';
      });
      return;
    }

    // 빌드 완료 후에 상세 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProjectDetail(widget.project.portfolioId);
    });
  }

  @override
  void dispose() {
    // 화면을 나갈 때 상세 데이터 초기화 (선택사항)
    controller.projectDetail.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 1,
      body: Obx(() {
        // 로딩 상태 처리
        if (controller.isLoadingDetail.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 에러 상태 처리
        if (controller.detailErrorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: ActivityColor.gray400,
                ),
                const SizedBox(height: 16),
                Text(
                  '상세 정보를 불러올 수 없습니다',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ActivityColor.gray700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.detailErrorMessage.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: ActivityColor.gray400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller
                      .refreshProjectDetail(widget.project.portfolioId),
                  child: Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        // 정상적으로 데이터가 있는 경우
        final detail = controller.projectDetail.value;
        if (detail == null) {
          return const Center(child: Text('데이터가 없습니다'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, detail),
              const SizedBox(height: 28),
              _divider(),
              _summary(context, detail),
              const SizedBox(height: 28),
              _divider(),
              _linkSection(context),
              const SizedBox(height: 28),
              _divider(),
              _fileSection(context),
            ],
          ),
        );
      }),
    );
  }

  // ── 헤더(제목·태그 등) ─────────────────────────────────────────
  Widget _header(BuildContext context, ProjectDetail detail) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(detail.description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: detail.tags
                      .map((t) => Chip(
                            label: Text(t),
                            backgroundColor: ActivityColor.gray100,
                            side: BorderSide.none,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '생성: ${_formatDate(detail.createdAt)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '수정: ${_formatDate(detail.updatedAt)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => MenuPopup(project: widget.project),
            ),
            child: Image.asset('assets/images/menu.png', width: 24),
          ),
        ],
      );

  // ── 요약 블록 ────────────────────────────────────────────────
  Widget _summary(BuildContext context, ProjectDetail detail) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('요약',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              Image.asset('assets/images/icon-ai2.png', width: 18),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ActivityColor.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              detail.content, // 실제 content 데이터 사용
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ); // ── 링크 섹션 (아이콘 위 + 리스트) ───────────────────────────
  Widget _linkSection(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 단독 표시
          Image.asset('assets/images/link.png', width: 24),
          const SizedBox(height: 12),
          // 예시 링크 데이터 표시
          ..._getExampleLinks().map((url) => _urlTile(context, url)).toList(),
        ],
      ); // ── 파일 섹션 ────────────────────────────────────────────────
  Widget _fileSection(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/file.png', width: 24),
          const SizedBox(height: 12),
          // 예시 파일 데이터 표시
          ..._getExampleFiles().map((url) => _urlTile(context, url)).toList(),
        ],
      );

  // ── URL 타일 (아이콘 X, 링크만) ───────────────────────────────
  Widget _urlTile(BuildContext context, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () async {
            final uri = Uri.tryParse(label);
            if (uri != null && await canLaunchUrl(uri)) await launchUrl(uri);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: ActivityColor.gray100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      );

  Widget _divider() =>
      Divider(thickness: 3, color: Colors.grey[50], height: 20);

  // ── 날짜 포맷팅 헬퍼 메서드 ─────────────────────────────────
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString; // 파싱 실패 시 원본 문자열 반환
    }
  } // ── 예시 데이터 (API에서 링크/파일 데이터를 제공하지 않음) ─────

  List<String> _getExampleLinks() {
    return [
      'https://github.com/example/project',
      'https://example.com/demo',
    ];
  }

  List<String> _getExampleFiles() {
    return [
      'project_document.pdf',
      'design_mockup.figma',
    ];
  }
}
