// widgets/filter_apply_button.dart
import 'package:flutter/material.dart';

class FilterApplyButton extends StatelessWidget {
  final VoidCallback onApply;

  const FilterApplyButton({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: Center(
        child: GestureDetector(
          onTap: onApply,
          child: Container(
            width: 300,
            height: 45,
            decoration: ShapeDecoration(
              color: const Color(0xFF0068E5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              shadows: const [
                BoxShadow(
                  color: Color(0x33184173),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: const Center(
              child: Text(
                '적용',
                style: TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.72,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
