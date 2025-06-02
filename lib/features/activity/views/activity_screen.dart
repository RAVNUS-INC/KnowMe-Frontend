import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme_frontend/shared/widgets/base_scaffold.dart';
import 'package:knowme_frontend/features/activity/models/activity_record.dart';
import 'package:knowme_frontend/features/activity/controllers/activity_controller.dart';
import 'package:knowme_frontend/features/activity/views/activity_detail_screen.dart';
import 'package:knowme_frontend/features/activity/views/activity_add_screen.dart';
import 'package:knowme_frontend/features/activity/views/activity_common.dart';

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
            const SizedBox(height: 8),
            _projectList(context, controller),
          ],
        ),
      ),
    );
  }

  // 필터 UI
  Widget _tagFilterRow(ActivityController controller) => Obx(() =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _side),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  GestureDetector(
                    onTap: () => controller.selectTag(null),
                    child: Image.asset(
                      'assets/images/refresh.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  ...controller.filterTags.map((tag) {
                    final sel = tag == controller.selectedTag.value;
                    return GestureDetector(
                      onTap: () => controller.selectTag(sel ? null : tag),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: sel ? ActivityColor.primaryBlue : ActivityColor.gray100,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: sel ? ActivityColor.primaryBlue : ActivityColor.gray200,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 13,
                            color: sel ? Colors.white : ActivityColor.gray700,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
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
  Widget _projectList(BuildContext context, ActivityController controller) => Expanded(
    child: Obx(() => ListView.separated(
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
                  MaterialPageRoute(builder: (_) => const ActivityAddScreen()),
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
            final deleted = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ActivityDetailScreen(project: p),
              ),
            );
            if (deleted != null && deleted is Project) {
              controller.removeProject(deleted);
            }
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
                Text(
                  p.date,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 12,
                    color: ActivityColor.gray400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )),
  );
}