import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jameya/core/animations/smart_animate_transition.dart';
import 'package:jameya/features/onboarding/data/models/onboarding_model.dart';
import 'package:jameya/features/onboarding/presentation/view/widgets/onboarding_subtitle.dart';
import 'package:jameya/features/onboarding/presentation/view/widgets/onboarding_title.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPageItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLandscape = constraints.maxHeight < 500;
        // Calculate a responsive image height based on the available screen height
        final double dynamicImageHeight = (constraints.maxHeight * 0.40).clamp(
          100.0,
          270.h,
        );

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 33.w,
                  right: 33.w,
                  top: isLandscape ? 4.h : 16.h,
                  bottom: 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ── Illustration with Smart Animate ───────────
                    AnimatedSwitcher(
                      duration: SmartAnimateTransition.duration,
                      transitionBuilder:
                          SmartAnimateTransition.transitionBuilder,
                      child: Image.asset(
                        model.image,
                        key: ValueKey(model.image),
                        height: dynamicImageHeight,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: isLandscape ? 12.h : 70.h),

                    // ── Title with Smart Animate ───────────────────
                    AnimatedSwitcher(
                      duration: SmartAnimateTransition.duration,
                      transitionBuilder:
                          SmartAnimateTransition.transitionBuilder,
                      child: OnboardingTitle(
                        key: ValueKey(model.title),
                        title: model.title,
                      ),
                    ),

                    SizedBox(height: isLandscape ? 6.h : 14.h),

                    // ── Subtitle with Smart Animate ────────────────
                    AnimatedSwitcher(
                      duration: SmartAnimateTransition.duration,
                      transitionBuilder:
                          SmartAnimateTransition.transitionBuilder,
                      child: OnboardingSubtitle(
                        key: ValueKey(model.subtitle),
                        subtitle: model.subtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
