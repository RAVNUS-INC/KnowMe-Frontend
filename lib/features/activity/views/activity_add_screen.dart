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
}

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