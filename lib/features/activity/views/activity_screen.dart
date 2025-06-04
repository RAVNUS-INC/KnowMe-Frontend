import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../controllers/activity_controller.dart';
import '../views/activity_detail_screen.dart';
import '../views/activity_add_screen.dart';
import '../views/activity_common.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  static const double _side = 20;

  @override
  Widget build(BuildContext context) {
    final ActivityController controller = Get.find<ActivityController>();

    return BaseScaffold(
      currentIndex: 1,
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: Column(
          children: [
            _tagFilterRow(controller),
            const SizedBox(height: 20),
            _projectList(context, controller),
          ],
        ),
      ),
    );
  }

  // 필터 UI
  Widget _tagFilterRow(ActivityController controller) => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _side, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    GestureDetector(
                      onTap: () => controller.selectTag(null),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/refresh.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    ...controller.availableTags.map((tag) {
                      final sel = tag == controller.selectedTag.value;
                      return GestureDetector(
                        onTap: () => controller.selectTag(sel ? null : tag),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: sel
                                ? ActivityColor.primaryBlue
                                : ActivityColor.gray100,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: sel
                                  ? ActivityColor.primaryBlue
                                  : ActivityColor.gray200,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 13,
                              color: sel ? Colors.white : ActivityColor.gray700,
                              fontWeight:
                                  sel ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
  // 프로젝트 리스트 UI
  Widget _projectList(BuildContext context, ActivityController controller) =>
      Expanded(
        child: Obx(() {
          // 로딩 상태 처리
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 에러 상태 처리
          if (controller.errorMessage.isNotEmpty) {
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
                    '데이터를 불러올 수 없습니다',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ActivityColor.gray700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 14,
                      color: ActivityColor.gray400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.refreshActivity(),
                    child: Text('다시 시도'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ActivityColor.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: GoogleFonts.notoSansKr(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }

          // 정상적으로 데이터가 있는 경우
          return RefreshIndicator(
            onRefresh: () => controller.refreshActivity(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: _side),
              itemCount: controller.visibleProjects.length + 1,
              separatorBuilder: (_, i) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                if (i == controller.visibleProjects.length) {
                  // 하단 플러스 버튼 (프로젝트 추가)
                  return Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ActivityAddScreen()),
                        );
                      },
                      child: Center(
                        child: Image.asset(
                          'assets/images/btn-rounded.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }
                final p = controller.visibleProjects[i];
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActivityDetailScreen(project: p),
                      ),
                    );
                    // 삭제는 ActivityController에서 직접 처리하므로 별도 처리 불필요
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ActivityColor.gray200),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ActivityColor.gray700,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.8,
                          color: ActivityColor.gray200,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.description,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: p.tags
                              .map(
                                (t) => Chip(
                                  label: Text(
                                    t,
                                    style: GoogleFonts.notoSansKr(fontSize: 12),
                                  ),
                                  backgroundColor: ActivityColor.gray100,
                                  visualDensity: VisualDensity.compact,
                                  side: BorderSide.none,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '생성: ${_formatDate(p.createdAt)}',
                              style: GoogleFonts.notoSansKr(
                                fontSize: 12,
                                color: ActivityColor.gray400,
                              ),
                            ),
                            Text(
                              '수정: ${_formatDate(p.updatedAt)}',
                              style: GoogleFonts.notoSansKr(
                                fontSize: 12,
                                color: ActivityColor.gray400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      );

  // 날짜 포맷팅 헬퍼 메서드
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString; // 파싱 실패 시 원본 문자열 반환
    }
  }
}
