import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/splash_controller.dart';
import '../widgets/animated_logo.dart';
import '../widgets/language_button.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashController controller = SplashController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    controller.startTyping();
  }

  @override
  void dispose() {
    controller.disposeController();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedLogo(
                text: controller.displayedText,
                moveUp: controller.moveUp,
                maxHeight: constraints.maxHeight,
              ),
              AnimatedOpacity(
                opacity: controller.showButtons ? 1 : 0,
                duration: const Duration(milliseconds: 700),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 535.h),
                        const LanguageButton(text: 'العربية', localeCode: 'ar'),
                        SizedBox(height: 14.h),
                        const LanguageButton(text: 'English', localeCode: 'en'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
