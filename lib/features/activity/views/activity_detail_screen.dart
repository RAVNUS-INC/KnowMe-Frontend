import 'package:flutter/material.dart';
import 'package:knowme_frontend/shared/widgets/base_scaffold.dart';
import 'package:knowme_frontend/features/activity/models/activity_record.dart';
import 'package:knowme_frontend/features/activity/views/activity_common.dart';

///상세페이지
class ActivityDetailScreen extends StatelessWidget {
  final Project project;
  const ActivityDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 1, // '내 활동' 탭 강조
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.grey[50],
            ),
            const SizedBox(height: 20),

            // 🔽 Row로 제목~설명~태그~날짜 + 메뉴 아이콘 구성
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 왼쪽 텍스트 영역
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        children:
                        project.tags
                            .map(
                              (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: ActivityColor.gray100,
                            side: BorderSide.none,
                          ),
                        )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        project.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // 오른쪽 menu 아이콘
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => MenuPopup(project: project),
                    );
                  },
                  child: Image.asset(
                    'assets/images/menu.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔽 요약 ~ 링크 ~ 파일 이미지들
            Divider(thickness: 3, color: Colors.grey[50], height: 20),
            Image.asset(
              'assets/images/summation.png',
              height: 190,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),

            Divider(thickness: 3, color: Colors.grey[50], height: 20),
            Image.asset(
              'assets/images/activity-link.png',
              height: 190,
              fit: BoxFit.contain,
            ),

            Divider(thickness: 3, color: Colors.grey[50], height: 20),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/activity-file.png',
              height: 190,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}