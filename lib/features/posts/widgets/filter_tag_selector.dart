// filter_tags.dart
import 'package:flutter/material.dart';
import 'package:knowme_frontend/features/posts/presenters/filter_presenter.dart';

class FilterTagSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selected;
  final int? tabIndex;
  final FilterPresenter? presenter;
  final ValueChanged<String?>? onSelected;

  const FilterTagSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    this.tabIndex,
    this.presenter,
    this.onSelected,
  }) : assert((tabIndex != null && presenter != null) || onSelected != null,
  '(tabIndex와 presenter) 또는 onSelected 중 하나가 제공되어야 합니다');

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
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = option == selected;
              return GestureDetector(
                onTap: () {
                  if (presenter != null && tabIndex != null) {
                    // MultiSelect 방식 (presenter 사용)
                    presenter!.updateMultiSelectValue(tabIndex!, title, option, isSelected);
                  } else if (onSelected != null) {
                    // 일반 TagSelector 방식
                    onSelected!(isSelected ? null : option);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0068E5) : const Color(0xFFDEE3E7),
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
          ),
        ],
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