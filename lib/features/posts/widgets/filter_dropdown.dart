import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';

class FilterDropdown extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final VoidCallback onTap;
  final int? tabIndex; // 탭 인덱스 추가
  
  const FilterDropdown({
    super.key,
    required this.title,
    required this.options,
    this.selectedValue,
    required this.onTap,
    this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _titleStyle),
          const SizedBox(height: 8),
          _buildDropdownField(context),
        ],
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFDEE3E7),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              selectedValue ?? '선택',
              style: TextStyle(
                color: selectedValue != null
                    ? const Color(0xFF232323)
                    : const Color(0xFFABB0B5),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.56,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF454C53),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _titleStyle => const TextStyle(
        color: Color(0xFF454C53),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.56,
      );
}
