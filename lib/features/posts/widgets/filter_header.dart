import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterHeader extends StatelessWidget {
  final String title;
  final VoidCallback onReset;
  final VoidCallback onClose;

  const FilterHeader({
    super.key,
    required this.title,
    required this.onReset,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // 📌 Material로 감싸야 터치 투명 문제 방지 가능
      color: const Color(0xFFF5F5F5), // 반투명 흰색 배경
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16,0), // 적당한 여백 설정
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내용만큼만 차지하도록
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: SvgPicture.asset('assets/icons/cancel.svg', width: 16, height: 16),
                ),
                GestureDetector(
                  onTap: onReset,
                  child: SvgPicture.asset('assets/icons/refresh.svg', width: 24, height: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0068E5),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.72,
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[300], thickness: 1),
          ],
        ),

      ),
    );
  }
}
