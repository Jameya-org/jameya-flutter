import 'package:flutter/material.dart';
import 'package:jameya/core/utils/assets.dart';
import 'package:jameya/generated/l10n.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  static const int pageCount = 3;

  static List<OnboardingModel> getPages(BuildContext context) {
    return [
      OnboardingModel(
        image: Assets.imagesOnboardingOne,
        title: S.of(context).onboardingTitle1,
        subtitle: S.of(context).onboardingSubtitle1,
      ),
      OnboardingModel(
        image: Assets.imagesOnboardingTwo,
        title: S.of(context).onboardingTitle2,
        subtitle: S.of(context).onboardingSubtitle2,
      ),
      OnboardingModel(
        image: Assets.imagesOnboardingThree,
        title: S.of(context).onboardingTitle3,
        subtitle: S.of(context).onboardingSubtitle3,
      ),
    ];
  }
}
