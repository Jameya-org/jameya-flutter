import 'package:flutter/material.dart';
import 'package:jameya/generated/l10n.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(S.of(context).WithYouEveryWhere)));
  }
}
