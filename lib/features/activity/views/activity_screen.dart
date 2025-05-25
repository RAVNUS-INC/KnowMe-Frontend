import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/shared/widgets/base_scaffold.dart';

const double _side = 20;

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String? _selectedTag;
  static const _filterTags = [
    'React',
    'Firebase',
    'ResponsiveUI',
    'TailwindCSS',
    'TypeScript',
    'API\\u연동',
  ];

  final _projects = const [
    Project(
      title: 'MyPlanner – 일정 관리 웹앱',
      description: 'React와 Firebase로 만든 개인 일정 관리 서비스',
      tags: ['React', 'Firebase', 'ResponsiveUI'],
      date: '2025.03.28',
    ),
    Project(
      title: 'Shopixel – 반응형 이커머스 프론트엔드',
      description: 'SCSS와 JavaScript로 만든 쇼핑몰 웹사이트',
      tags: ['ResponsiveUI', 'VanillaJS', 'SCSS'],
      date: '2024.10.02',
    ),
    Project(
      title: '코딩톡 – 개발자 커뮤니티 SPA',
      description: 'Next.js 기반의 소셜 피드형 커뮤니티',
      tags: ['React', 'TailwindCSS', 'TypeScript'],
      date: '2024.08.12',
    ),
    Project(
      title: 'DevBoard – 개발자 대시보드',
      description: 'Github API 기반의 개인 프로젝트 관리 대시보드',
      tags: ['React', 'API\\u연동', 'ResponsiveUI'],
      date: '2024.06.05',
    ),
    Project(
      title: '모두의 날씨 – 실시간 날씨 조회 앱',
      description: 'OpenWeather API 연동과 사용자 경험 중심 UI',
      tags: ['React', 'API\\u연동', 'ResponsiveUI'],
      date: '2024.02.10',
    ),
  ];

  List<Project> get _visible => _selectedTag == null
      ? _projects
      : _projects.where((p) => p.tags.contains(_selectedTag)).toList();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 1,
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: Column(
          children: [
            _tagFilterRow(),
            const SizedBox(height: 8),
            _projectList(),
          ],
        ),
      ),
    );
  }

  Widget _tagFilterRow() => Column(
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
                    onTap: () => setState(() => _selectedTag = null),
                    child: Image.asset(
                      'assets/images/refresh.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  ..._filterTags.map((tag) {
                    final sel = tag == _selectedTag;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedTag = sel ? null : tag),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: sel ? _Color.primaryBlue : _Color.gray100,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: sel ? _Color.primaryBlue : _Color.gray200,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 13,
                            color: sel ? Colors.white : _Color.gray700,
                            fontWeight:
                                sel ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );

  Widget _projectList() => Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: _side),
          itemCount: _visible.length + 1,
          separatorBuilder: (_, i) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            if (i == _visible.length) {
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

            final p = _visible[i];
            return GestureDetector(
              onTap: () async {
                final deleted = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActivityDetailScreen(project: p),
                  ),
                );

                if (deleted != null && deleted is Project) {
                  setState(() {
                    _projects.remove(deleted);
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _Color.gray200),
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
                        color: _Color.gray700,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: _Color.gray200,
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
                          .map((t) => Chip(
                                label: Text(
                                  t,
                                  style: GoogleFonts.notoSansKr(fontSize: 12),
                                ),
                                backgroundColor: _Color.gray100,
                                visualDensity: VisualDensity.compact,
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      p.date,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 12,
                        color: _Color.gray400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}

class Project {
  final String title, description, date;
  final String? summary;
  final List<String> tags;

  const Project({
    required this.title,
    required this.description,
    required this.tags,
    required this.date,
    this.summary,
  });
}

class _Color {
  static const primaryBlue = Color(0xFF0066FF);
  static const gray100 = Color(0xFFF1F5F9);
  static const gray200 = Color(0xFFE2E8F0);
  static const gray400 = Color(0xFF94A3B8);
  static const gray700 = Color(0xFF334155);
}

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
                        children: project.tags
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: _Color.gray100,
                                  side: BorderSide.none,
                                ))
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
                      builder: (_) => _MenuPopup(project: project),
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
            Image.asset('assets/images/summation.png',
                height: 190, fit: BoxFit.contain),
            const SizedBox(height: 8),

            Divider(thickness: 3, color: Colors.grey[50], height: 20),
            Image.asset('assets/images/activity-link.png',
                height: 190, fit: BoxFit.contain),

            Divider(thickness: 3, color: Colors.grey[50], height: 20),
            const SizedBox(height: 16),
            Image.asset('assets/images/activity-file.png',
                height: 190, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}

///팝업 위젯
Future<bool> _showDeleteDialog(BuildContext context, Project project) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '활동을 삭제할까요?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '삭제한 내용은 복구할 수 없습니다.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black45,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 100,
          height: 40,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF0066FF)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('확인', style: TextStyle(color: Color(0xFF0066FF))),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}

class _MenuPopup extends StatelessWidget {
  final Project project;
  const _MenuPopup({required this.project});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 활동 수정하기
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProjectPage(
                      project: project, // 수정할 데이터 전달
                      isEdit: true, // 수정모드라는 플래그 전달
                    ),
                  ),
                ); // 팝업 닫고
                //
              },
              child: Row(
                children: [
                  Image.asset('assets/images/edit.png', width: 18),
                  const SizedBox(width: 8),
                  const Text(
                    '활동 수정하기',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 활동 삭제하기
            GestureDetector(
              onTap: () async {
                await _showDeleteDialog(
                    context, project); // ← project 삭제 요청 보내기
              },
              child: Row(
                children: [
                  Image.asset('assets/images/trash.png', width: 18),
                  const SizedBox(width: 8),
                  const Text(
                    '활동 삭제하기',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///활동 수정 페이지
class AddProjectPage extends StatefulWidget {
  final Project? project;
  final bool isEdit;

  const AddProjectPage({super.key, this.isEdit = false, this.project});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '활동 작성을 취소할까요?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '지금까지 작성한 내용이 저장되지 않습니다.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                        Navigator.of(context).pop(); // 수정 페이지 나가기
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blueAccent),
                        foregroundColor: Colors.blueAccent,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('확인'),
                    ),
                  ),
                  // 취소 버튼
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('취소'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _sum = TextEditingController();
  final _tag = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _title.text = widget.project!.title;
      _desc.text = widget.project!.description;
      _sum.text = widget.project!.summary ?? '';
      _tag.text = ''; // 태그는 별도로 처리 가능
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _sum.dispose();
    _tag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBottomBar: false, // ✅ 하단 바 제거
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Divider(
              thickness: 20,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            // 기본정보
            Image.asset(
              'assets/images/기본정보.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            // 요약
            Image.asset(
              'assets/images/활동-요약.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            // 태그
            Image.asset(
              'assets/images/활동-tag.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            // 링크
            Image.asset(
              'assets/images/activity-link(2).png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            // 파일
            Image.asset(
              'assets/images/activity-file(2).png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            const SizedBox(height: 80),

            // ✅ 하단 버튼 직접 배치
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('저장'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.grey[300]!),
                      onPressed: () => _showCancelDialog(context),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///활동 추가 페이지
class ActivityAddScreen extends StatelessWidget {
  const ActivityAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBottomBar: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 파일
            Image.asset(
              'assets/images/기본정보(공란).png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            Image.asset(
              'assets/images/summation(공란).png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            Image.asset(
              'assets/images/tag(공란).png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            Image.asset(
              'assets/images/link(공란).png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            Image.asset(
              'assets/images/file(공란).png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            const SizedBox(height: 80),

            const SizedBox(height: 40),

            Center(
              child: GestureDetector(
                onTap: () {
                  _showCancelConfirmDialog(context); // '취소' 눌렀을 때 알림창
                },
                child: Image.asset(
                  'assets/images/wrapper-btn.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 외부 터치로 닫히지 않게
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '활동 작성을 취소할까요?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                '지금까지 작성한 내용이 저장되지 않습니다.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5C5C5C),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그만 닫기
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0066FF)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0066FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
