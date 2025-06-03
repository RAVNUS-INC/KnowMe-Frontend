import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../controllers/activity_controller.dart';

///활동 추가 페이지
class ActivityAddScreen extends StatefulWidget {
  const ActivityAddScreen({super.key});

  @override
  State<ActivityAddScreen> createState() => _ActivityAddScreenState();
}

class _ActivityAddScreenState extends State<ActivityAddScreen> {
  DateTime? selectedDate;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  // ActivityController 인스턴스 가져오기 (없으면 생성)
  late final ActivityController activityController;

  @override
  void initState() {
    super.initState();
    // ActivityController 초기화 (없으면 생성)
    try {
      activityController = Get.find<ActivityController>();
    } catch (e) {
      activityController = Get.put(ActivityController());
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    titleController.dispose();
    contentController.dispose();
    summaryController.dispose();
    tagController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('ko', 'KR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            '${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  /// 활동을 생성합니다
  Future<void> _createActivity() async {
    // 입력 검증
    if (titleController.text.trim().isEmpty) {
      _showErrorDialog('제목을 입력해주세요.');
      return;
    }

    if (contentController.text.trim().isEmpty) {
      _showErrorDialog('내용을 입력해주세요.');
      return;
    }

    if (summaryController.text.trim().isEmpty) {
      _showErrorDialog('요약을 입력해주세요.');
      return;
    }

    try {
      // 태그 파싱
      final tags = activityController.parseTagsFromString(tagController.text);

      // 활동 생성 API 호출
      final success = await activityController.createActivity(
        title: titleController.text.trim(),
        description: summaryController.text.trim(),
        content: contentController.text.trim(),
        tags: tags,
      );

      if (success) {
        // 성공 시 이전 페이지로 돌아가기
        Navigator.of(context).pop();

        // 성공 메시지 표시 (옵션)
        Get.snackbar(
          '성공',
          '활동이 성공적으로 추가되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        _showErrorDialog('활동 생성에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      _showErrorDialog('오류가 발생했습니다: $e');
    }
  }

  /// 에러 다이얼로그를 표시합니다
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 파일
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '기본 정보',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12), // 제목 입력창
                  SizedBox(
                    height: 44,
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: '제목',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB7C4D4),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFD2DAE6)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF1565C0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // 날짜 입력창
                  SizedBox(
                    height: 44,
                    child: TextField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: '날짜 (YYYY.MM.DD)',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB7C4D4),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFD2DAE6)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF1565C0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFFB7C4D4),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

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
                  // 본문
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '내용',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16), // 내용 입력창 (높이 크게)
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFD2DAE6)),
                        ),
                        child: TextField(
                          controller: contentController,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: '직접 입력',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB7C4D4),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF232323),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Divider(
              thickness: 3,
              color: Colors.grey[50],
              height: 24,
            ),

            // 요약 섹션 추가
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // 본문
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '요약',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 요약 입력창 (높이 작게)
                      SizedBox(
                        height: 44,
                        child: TextField(
                          controller: summaryController,
                          decoration: InputDecoration(
                            hintText: '활동 내용을 요약해서 입력해주세요',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB7C4D4),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFFD2DAE6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF1565C0)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF232323),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 오른쪽 위 AI 아이콘
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/ai.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '태그',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    '추천태그',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF72787F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 빈 태그 리스트 (Wrap, children: [] 로 아무것도 없음)                  // 입력창
                  SizedBox(
                    height: 44,
                    child: TextField(
                      controller: tagController,
                      decoration: InputDecoration(
                        hintText: '직접 입력 후 엔터',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB7C4D4),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFD2DAE6)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF1565C0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Divider(
              thickness: 3,
              color: Colors.grey[50], // ✅ 아주 연한 회색
              height: 24,
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 왼쪽: link.png 아이콘
                  Image.asset(
                    'assets/images/link.png',
                    width: 28,
                    height: 28,
                  ),
                  // 오른쪽: 동그란 파란색 원 안에 plus 아이콘 (addition-circle.png)
                  Image.asset(
                    'assets/images/addition-circle.png',
                    width: 36,
                    height: 36,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단: 좌측 아이콘, 우측 아이콘
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

                  // 입력창 (회색 배경)
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '직접 입력 후 엔터',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB7C4D4),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF232323),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: Obx(() => GestureDetector(
                    onTap: activityController.isCreatingActivity.value
                        ? null // 로딩 중에는 비활성화
                        : _createActivity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/wrapper-btn.png',
                          width: 300,
                          fit: BoxFit.contain,
                        ),
                        if (activityController.isCreatingActivity.value)
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
