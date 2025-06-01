import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart';

class FilterTagSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  final dynamic selected; // String? 또는 List<String> 지원
  final int? tabIndex;
  final FilterController? controller;
  final ValueChanged<dynamic>? onSelected;

  const FilterTagSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    this.tabIndex,
    this.controller,
    this.onSelected,
  }) : assert((tabIndex != null && controller != null) || onSelected != null,
            '(tabIndex와 controller) 또는 onSelected 중 하나가 제공되어야 합니다');

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
          // 필터 상태가 변경될 때 UI가 업데이트되도록 Obx 사용
          title == '대상' ||
                  title == '주최기관' ||
                  title == '혜택' ||
                  title == '온/오프라인' ||
                  title == '학력'
              ? _buildMultiSelectOptions()
              : _buildSingleSelectOptions(),
        ],
      ),
    );
  }

  // 다중 선택 옵션 목록 - Obx로 감싸 반응형 UI 구현
  Widget _buildMultiSelectOptions() {
    return Obx(() {
      return Wrap(
        spacing: 10,
        runSpacing: 8,
        children: options.map((option) {
          bool isSelected = _isMultiOptionSelected(option);
          return GestureDetector(
            onTap: () {
              if (controller != null && tabIndex != null) {
                controller!.updateMultiSelectValue(
                    tabIndex!, title, option, isSelected);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0068E5)
                    : const Color(0xFFDEE3E7),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF454C53),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.48,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // 단일 선택 옵션 목록
  Widget _buildSingleSelectOptions() {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: options.map((option) {
        bool isSelected = option == selected;
        return GestureDetector(
          onTap: () {
            if (onSelected != null) {
              // 일반 TagSelector 방식 - 단일 선택만 지원
              onSelected!(isSelected ? null : option);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0068E5)
                  : const Color(0xFFDEE3E7),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF454C53),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.48,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 다중 선택 옵션이 선택되었는지 확인
  bool _isMultiOptionSelected(String option) {
    if (controller != null && tabIndex != null) {
      return controller!.isOptionSelected(tabIndex!, title, option);
    }
    return false;
  }

  TextStyle get _titleStyle => const TextStyle(
        color: Color(0xFF454C53),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.56,
      );
}
