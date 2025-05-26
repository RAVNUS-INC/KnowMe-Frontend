// 📁 widgets/filter_dropdown.dart
import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final Future<String?> Function() onTap;

  const FilterDropdown({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF454C53),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final result = await onTap();
              if (result != null) {
                // 선택 처리 로직은 외부에서
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selectedValue != null ? const Color(0xFF232323) : const Color(0xFFB7C4D4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedValue ?? '전체',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: selectedValue != null ? const Color(0xFF232323) : const Color(0xFFB7C4D4),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFFB7C4D4))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
