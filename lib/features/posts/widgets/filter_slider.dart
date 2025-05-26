import 'package:flutter/material.dart';
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart';

class FilterRangeSlider extends StatelessWidget {
  final String title;
  final int tabIndex;
  final RangeValues currentRangeValues;
  final ValueChanged<RangeValues> onChanged;
  final FilterController controller;

  const FilterRangeSlider({
    super.key,
    required this.title,
    required this.tabIndex,
    required this.currentRangeValues,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final config = controller.getSliderConfig(tabIndex);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _titleStyle),
          const SizedBox(height: 4),
          SizedBox(
            height: 45,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: SliderTheme(
                    data: _sliderTheme(context),
                    child: RangeSlider(
                      values: currentRangeValues,
                      min: config.min,
                      max: config.max,
                      divisions: config.divisions,
                      labels: RangeLabels(
                        controller.formatSliderLabel(currentRangeValues.start, tabIndex),
                        controller.formatSliderLabel(currentRangeValues.end, tabIndex),
                      ),
                      onChanged: (values) {
                        // 슬라이더 값이 변경될 때 즉시 반영
                        final adjustedValues = controller.adjustSliderValues(
                          values, config, currentRangeValues);
                        onChanged(adjustedValues);
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(config.startLabel, style: _labelStyle),
                      Text(config.endLabel, style: _labelStyle),
                    ],
                  ),
                ),
              ],
            ),
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

  TextStyle get _labelStyle => const TextStyle(
    color: Color(0xFF0068E5),
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.40,
  );

  SliderThemeData _sliderTheme(BuildContext context) {
    return SliderTheme.of(context).copyWith(
      trackHeight: 2,
      activeTrackColor: const Color(0xFF0068E5),
      inactiveTrackColor: const Color(0xFFDEE3E7),
      thumbColor: Colors.white,
      overlayColor: const Color(0x290068E5),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 6),
      rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
      valueIndicatorColor: const Color(0xFF0068E5),
      valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
