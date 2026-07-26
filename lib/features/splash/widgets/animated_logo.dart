import 'package:flutter/material.dart';
import 'package:jameya/core/utils/app_text_styles.dart';

// Animates the logo position from the screen center to the top
class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required this.text,
    required this.moveUp,
    required this.maxHeight,
  });

  final String text;
  final bool moveUp;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      // Slides up to a fixed position once moveUp is true
      top: moveUp ? 360 : maxHeight / 2 - 30,
      left: 0,
      right: 0,
      child: Center(child: Text(text, style: AppTextStyles.appTitle)),
    );
  }
}
