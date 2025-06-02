import 'package:flutter/material.dart';
import '../../../shared/widgets/base_scaffold.dart';

///활동 추가 페이지
class ActivityAddScreen extends StatelessWidget {
  const ActivityAddScreen({super.key});

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
                  const SizedBox(height: 12),
                  // 제목 입력창
                  SizedBox(
                    height: 44,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '제목',
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 설명 입력창
                  SizedBox(
                    height: 44,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '설명',
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // 날짜
                  const Text(
                    '2025.04.17',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF232323),
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
                      // 입력창 (힌트: 직접 입력)
                      SizedBox(
                        height: 44,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '직접 입력',
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
                  // 오른쪽 위 동그란 배경+ai.png 아이콘
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

                  // 빈 태그 리스트 (Wrap, children: [] 로 아무것도 없음)

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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
      builder:
          (_) => Dialog(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}