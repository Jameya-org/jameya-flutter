import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/localization/cubit/localization_cubit.dart';
import 'core/localization/cubit/localization_state.dart';
import 'core/routing/app_router.dart';
import 'core/services/services_locator.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/kyc/presentation/providers/kyc_provider.dart';
import 'features/payment/presentation/providers/payment_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const JameyaApp());
}

class JameyaApp extends StatelessWidget {
  const JameyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => KycProvider()),
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        BlocProvider<LocaleCubit>(
          create: (_) => getIt<LocaleCubit>()..loadSavedLanguage(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              return MaterialApp.router(
                title: 'جمعية',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: 'Cairo',
                  primaryColor: const Color(0xFF008080),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF008080),
                  ),
                ),
                locale: state.locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
