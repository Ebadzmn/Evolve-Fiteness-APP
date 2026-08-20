import 'package:flutter/material.dart';

class FullWidthSliderTrackShape extends RoundedRectSliderTrackShape {
  const FullWidthSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class FullWidthSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final double trackHeight;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color thumbColor;
  final double enabledThumbRadius;
  final Color? overlayColor;

  const FullWidthSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.trackHeight = 5.0,
    this.activeTrackColor = const Color(0xFF69B427),
    this.inactiveTrackColor = const Color(0xFF2C2C3E),
    this.thumbColor = const Color(0xFF69B427),
    this.enabledThumbRadius = 10.0,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = (value.isFinite ? value : min).clamp(min, max).toDouble();
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: trackHeight,
        trackShape: const FullWidthSliderTrackShape(),
        activeTrackColor: activeTrackColor,
        inactiveTrackColor: inactiveTrackColor,
        thumbColor: thumbColor,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: enabledThumbRadius,
        ),
        overlayColor: overlayColor,
      ),
      child: Slider(
        value: safeValue,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}
