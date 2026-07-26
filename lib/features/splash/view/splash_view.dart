import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:jameya/core/utils/app_text_styles.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

@override
class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Jameya.',
              cursor: "",
              speed: const Duration(milliseconds: 400),
              textStyle: AppTextStyles.appTitle,
            ),
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ),
    );
  }
}
