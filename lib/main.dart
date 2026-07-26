import 'package:flutter/material.dart';
import 'package:jameya/features/splash/view/splash_view.dart';

void main() {
  runApp(const Jameya());
}

class Jameya extends StatelessWidget {
  const Jameya({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashView());
  }
}
