import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart'; // FilterPresenter 대신 FilterController 임포트

class FilterRangeSlider extends StatelessWidget {
  final String title;
  final int tabIndex;
  final RangeValues currentRangeValues;
  final ValueChanged<RangeValues> onChanged;
  final FilterController controller; // FilterPresenter 대신 FilterController 사용

  const FilterRangeSlider({
    super.key,
    required this.title,
    required this.tabIndex,
    required this.currentRangeValues,
    required this.onChanged,
    required this.controller, // 속성 이름 변경
  });

  @override
  Widget build(BuildContext context) {
    final config = controller.getSliderConfig(tabIndex); // presenter -> controller

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _titleStyle),
          // 제목과 슬라이더 사이 간격 줄임
          const SizedBox(height: 4),
          // 전체 높이를 45로 줄여서 슬라이더와 레이블이 더 가까워지도록 조정
          SizedBox(
            height: 45,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 슬라이더 위젯 - 위치 위로 조정
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0, // 상단에 위치하도록 조정
                  child: SliderTheme(
                    data: _sliderTheme(context),
                    child: RangeSlider(
                      values: currentRangeValues,
                      min: config.min,
                      max: config.max,
                      divisions: config.divisions,
                      labels: RangeLabels(
                        controller.formatSliderLabel(currentRangeValues.start, tabIndex), // presenter -> controller
                        controller.formatSliderLabel(currentRangeValues.end, tabIndex), // presenter -> controller
                      ),
                      onChanged: (values) {
                        onChanged(controller.adjustSliderValues(values, config, currentRangeValues)); // presenter -> controller
                      },
                    ),
                  ),
                ),
                // 슬라이더 아래에 라벨 위치 - 슬라이더에 더 가깝게 배치
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 0, // 하단에 배치하여 슬라이더와 더 가깝게
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
