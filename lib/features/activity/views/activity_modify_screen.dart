import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../models/activity_record.dart';
import '../controllers/activity_controller.dart';

///활동 수정 페이지
class AddProjectPage extends StatefulWidget {
  final Project? project;
  final bool isEdit;

  const AddProjectPage({super.key, this.isEdit = false, this.project});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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

  final controller = Get.find<ActivityController>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'MyPlanner – 일정 관리 웹앱');
    _descriptionController = TextEditingController(text: 'React와 Firebase로 만든 개인 일정 관리 서비스');
    controller.loadProjectForEdit(widget.project); // 새로 추가/수정 시
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
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

            // 기본정보 (이미지 대신 코드로 구현)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC), // 배경색 (아주 연한 회색)
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '기본 정보',
                    style: TextStyle(
                      color: Color(0xFF1565C0), // 파란색
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 첫 번째 입력창 (비활성화)
                  SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _titleController,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFD2DAE6)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 두 번째 입력창 (비활성화)
                  SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _descriptionController,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFD2DAE6)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 날짜
                  const Text(
                    '2025.03.28',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // 1. 본문
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 파란색 '요약' 텍스트
                      const Text(
                        '요약',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 요약 내용이 들어가는 회색 박스
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFFD2DAE6)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '개인 일정 관리 기능을 제공하는 웹앱으로, React로 UI 구성, Firebase로 실시간 데이터 연동 및 인증을 구현. 반응형 디자인으로 다양한 해상도에 최적화함.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF232323),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 2. 오른쪽 상단에 다이아몬드 png 아이콘
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/icon-ai2.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            // 태그 (이미지 대신 코드로 구현)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 파란색 '태그' 텍스트
                  const Text(
                    '태그',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // 선택된 태그 (파란색 배경, X 아이콘)
                  Wrap(
                    spacing: 8,
                    children: [
                      _TagChip(text: 'React', selected: true),
                      _TagChip(text: 'Firebase', selected: true),
                      _TagChip(text: 'ResponsiveUI', selected: true),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // '추천태그' 라벨
                  const Text(
                    '추천태그',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF72787F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 추천 태그 리스트 (연회색 배경)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _TagChip(text: 'RealtimeDatabase'),
                      _TagChip(text: 'ReactHooks'),
                      _TagChip(text: 'CRUD'),
                      _TagChip(text: 'MaterialUI'),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 입력창
                  SizedBox(
                    height: 44,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '직접 입력 후 엔터',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB7C4D4),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD2DAE6)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF1565C0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            // 링크 (이미지 대신 코드로 구현)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 아이콘 row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/link.png',
                        width: 24,
                        height: 24,
                      ),
                      Image.asset(
                        'assets/images/addition-circle.png',
                        width: 28,
                        height: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 링크 리스트 (예시 2개, 실제로는 ListView.builder 가능)
                  Column(
                    children: [
                      _LinkInputField(url: 'https://example.com/about'),
                      const SizedBox(height: 8),
                      _LinkInputField(url: 'https://example.com/about'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            // 파일 (이미지 대신 코드로 구현)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 아이콘 row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/file.png',
                        width: 24,
                        height: 24,
                      ),
                      Image.asset(
                        'assets/images/addition-circle.png',
                        width: 28,
                        height: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 파일명 리스트 (예시 2개, 실제로는 ListView.builder 가능)
                  Column(
                    children: [
                      _FileRow(filename: '프로젝트계획서.pdf'),
                      const SizedBox(height: 8),
                      _FileRow(filename: '디자인시안.png'),
                    ],
                  ),
                ],
              ),
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
                        backgroundColor: Colors.blueAccent,
                      ),
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
                        backgroundColor: Colors.grey[300]!,
                      ),
                      onPressed: () => _showCancelDialog(context),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
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
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}


// 태그 칩용 위젯 정의
class _TagChip extends StatelessWidget {
  final String text;
  final bool selected;

  const _TagChip({
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF4C80FF) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF72787F),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          if (selected)
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

// 입력 필드용 위젯 정의
class _LinkInputField extends StatelessWidget {
  final String url;

  const _LinkInputField({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        url,
        style: const TextStyle(
          color: Color(0xFF232323),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

// 아래에 파일명 행용 위젯 정의 (이 파일 아래쪽이나 따로 분리)
class _FileRow extends StatelessWidget {
  final String filename;

  const _FileRow({required this.filename});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        filename,
        style: const TextStyle(
          color: Color(0xFF232323),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}