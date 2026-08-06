import 'package:flutter/material.dart';
import 'package:jameya_user/features/profile/screens/profile_info_screen.dart';
import 'package:jameya_user/features/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'core/token_storage.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/payment/providers/payment_provider.dart';
import 'features/payment/screens/add_card_screen.dart';
import 'features/payment/screens/saved_cards_screen.dart';
import 'features/kyc/providers/kyc_provider.dart';
import 'features/kyc/screens/kyc_screen.dart';
import 'features/info/screens/terms_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => KycProvider()),
      ],
      child: MaterialApp(
        title: 'جمعية',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Cairo'),
        home: const SplashDecider(), // ✅ بتقرر تروح فين
        routes: {
          '/login': (_) => const LoginScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/personal-info': (_) => const PersonalInfoScreen(),
          '/payment-methods': (_) => const SavedCardsScreen(),
          '/add-card': (_) => const AddCardScreen(),
          '/kyc-verification': (_) => const KycScreen(),
          '/terms': (_) => const TermsScreen(),
        },
      ),
    );
  }
}

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    await Future.delayed(const Duration(milliseconds: 500)); // splash بسيط

    final token = await TokenStorage.getAccessToken();

    if (!mounted) return;

    if (token != null) {
      // ✅ عنده token → روح للبروفايل
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      // ❌ مفيش token → روح للـ Login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A7A6E),
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
