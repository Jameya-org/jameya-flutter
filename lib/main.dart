import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jameya/features/splash/view/splash_view.dart';

void main() {
  runApp(const Jameya());
}

class Jameya extends StatelessWidget {
  const Jameya({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: SplashView(),
        );
      },
    );
  }
}
