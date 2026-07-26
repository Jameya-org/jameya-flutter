import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jameya/core/localization/cubit/localization_cubit.dart';
import 'package:jameya/core/localization/cubit/localization_state.dart';
import 'package:jameya/core/routing/app_router.dart';
import 'package:jameya/core/services/services_locator.dart';
import 'package:jameya/generated/l10n.dart';

void main() async {
  // Ensure Flutter bindings are ready before any async work
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize all services (cache, cubit, etc.)
  await setupServiceLocator();
  runApp(const Jameya());
}

class Jameya extends StatelessWidget {
  const Jameya({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide LocaleCubit globally and load the saved language on start
      create: (_) => getIt<LocaleCubit>()..loadSavedLanguage(),
      child: ScreenUtilInit(
        // Base design size used for responsive scaling
        designSize: const Size(440, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            // Rebuild the app whenever the locale changes
            builder: (context, state) {
              return MaterialApp.router(
                routerConfig: AppRouter.router,
                //* Localization
                locale: state.locale,
                supportedLocales: S.delegate.supportedLocales,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                theme: ThemeData(primarySwatch: Colors.blue),
              );
            },
          );
        },
      ),
    );
  }
}
