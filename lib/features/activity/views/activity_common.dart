import 'package:flutter/material.dart';
import 'package:knowme_frontend/features/activity/models/activity_record.dart';
import 'package:knowme_frontend/features/activity/views/activity_add_screen.dart';

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
    builder:
        (_) => AlertDialog(
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
                    builder:
                        (_) => AddProjectPage(
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
                  context,
                  project,
                ); // ← project 삭제 요청 보내기
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