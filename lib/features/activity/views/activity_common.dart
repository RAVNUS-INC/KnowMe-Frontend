import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/activity_record.dart';
import '../controllers/activity_controller.dart';
import '../views/activity_modify_screen.dart';

class ActivityColor {
  static const primaryBlue = Color(0xFF0066FF);
  static const gray100 = Color(0xFFF1F5F9);
  static const gray200 = Color(0xFFE2E8F0);
  static const gray400 = Color(0xFF94A3B8);
  static const gray700 = Color(0xFF334155);
}

///팝업 위젯
Future<bool> _showDeleteDialog(BuildContext context, Project project) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
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
            style: TextStyle(fontSize: 13, color: Colors.black45),
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
            child: const Text(
              '확인',
              style: TextStyle(color: Color(0xFF0066FF)),
            ),
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

class MenuPopup extends StatelessWidget {
  final Project project;
  const MenuPopup({super.key, required this.project});

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
                    builder: (_) => ActivityModifyScreen(
                      project: project, // 수정할 데이터 전달
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
            const SizedBox(height: 16), // 활동 삭제하기
            GestureDetector(
              onTap: () async {
                // 메뉴 팝업을 닫지 말고 바로 삭제 다이얼로그 호출
                final confirmed = await _showDeleteDialog(context, project);

                // 다이얼로그 결과에 관계없이 메뉴 팝업 닫기
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }                if (confirmed) {
                  // ActivityController를 사용하여 삭제 실행
                  final controller = Get.find<ActivityController>();
                  final success = await controller.removeProject(project);
                  if (success) {
                    // 성공 메시지 표시
                    Get.snackbar(
                      '성공',
                      '활동이 삭제되었습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );

                    // 상세 화면에서 호출된 경우 내 활동 화면으로 이동
                    // Get.back()을 여러 번 호출하여 상세 화면을 벗어나고 내 활동 화면으로 이동
                    Get.until((route) => route.settings.name == '/activity');
                  } else {
                    // 실패 메시지 표시
                    Get.snackbar(
                      '실패',
                      '활동 삭제에 실패했습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
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
