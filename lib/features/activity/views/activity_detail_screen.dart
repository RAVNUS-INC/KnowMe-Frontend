import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/widgets/base_scaffold.dart';
import '../models/activity_record.dart';
import '../views/activity_common.dart';

// 활동 상세 페이지 (정적 UI 버전 / SVG 시안과 1:1 대응)
class ActivityDetailScreen extends StatelessWidget {
  final Project project;
  const ActivityDetailScreen({super.key, required this.project});

  // ── 정적 예시 데이터 ─────────────────────────────────────────
  static const _summaryText =
      '개인 일정 관리 기능을 제공하는 웹앱으로, React로 UI 구성, Firebase로 실시간 데이터 연동 및 인증을 구현, 반응형 디자인으로 다양한 해상도에 최적화함.';
  static const _exampleLinks = [
    'https://example.com/about',
    'https://example.com/about',
  ];
  static const _exampleFiles = [
    'https://files.example.com/uploads/knowme_이한양.pdf',
    'https://files.example.com/uploads/knowme_이한양.pdf',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 28),
            _divider(),
            _summary(context),
            const SizedBox(height: 28),
            _divider(),
            _linkSection(context),
            const SizedBox(height: 28),
            _divider(),
            _fileSection(context),
          ],
        ),
      ),
    );
  }

  // ── 헤더(제목·태그 등) ─────────────────────────────────────────
  Widget _header(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(project.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: project.tags
                  .map((t) => Chip(
                label: Text(t),
                backgroundColor: ActivityColor.gray100,
                side: BorderSide.none,
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(project.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (_) => MenuPopup(project: project),
        ),
        child: Image.asset('assets/images/menu.png', width: 24),
      ),
    ],
  );

  // ── 요약 블록 ────────────────────────────────────────────────
  Widget _summary(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('요약',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
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
        child:
        Text(_summaryText, style: Theme.of(context).textTheme.bodyMedium),
      ),
    ],
  );

  // ── 링크 섹션 (아이콘 위 + 리스트) ───────────────────────────
  Widget _linkSection(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 아이콘 단독 표시
      Image.asset('assets/images/link.png', width: 24),
      const SizedBox(height: 12),
      ..._exampleLinks.map((url) => _urlTile(context, url)).toList(),
    ],
  );

  // ── 파일 섹션 ────────────────────────────────────────────────
  Widget _fileSection(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image.asset('assets/images/file.png', width: 24),
      const SizedBox(height: 12),
      ..._exampleFiles.map((url) => _urlTile(context, url)).toList(),
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

  Widget _divider() => Divider(thickness: 3, color: Colors.grey[50], height: 20);
}