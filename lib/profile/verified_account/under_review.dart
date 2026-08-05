import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Arabic RTL layout
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      theme: ThemeData(
        fontFamily: 'Cairo', // swap with your Arabic font family if needed
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const AccountVerificationReviewPage(),
    );
  }
}

class AccountVerificationReviewPage extends StatelessWidget {
  const AccountVerificationReviewPage({super.key});

  static const Color tealColor = Color(0xFF16736A);
  static const Color orangeColor = Color(0xFFE0A429);
  static const Color orangeBg = Color(0xFFFEF6E4);
  static const Color orangeBorder = Color(0xFFF0D48A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 8),
            // Progress bar
            _buildProgressBar(),
            const SizedBox(height: 24),
            // Card content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCard(),
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: _buildDoneButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: tealColor, size: 28),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: const Text(
                  'توثيق الحساب',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: tealColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: index == 2 ? 0 : 4,
                right: index == 0 ? 0 : 4,
              ),
              height: 4,
              decoration: BoxDecoration(
                color: tealColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          // Clock icon circle
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFFDF1D6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: orangeColor,
              size: 34,
            ),
          ),
          const SizedBox(height: 20),
          // Title
          const Text(
            'قيد المراجعة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          // Description
          const Text(
            'تم استلام مستنداتك وهي قيد المراجعة من قبل فريقنا.\nسيتم إشعارك خلال 24-48 ساعة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 20),
          // Info box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: orangeBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: orangeBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'تم الإرسال: ',
                      style: TextStyle(fontSize: 13, color: orangeColor),
                    ),
                    const Text(
                      '29 يوليو 2026',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'الوقت المتوقع للمراجعة: 1-2 يوم عمل',
                  style: TextStyle(fontSize: 13, color: orangeColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          // Handle done action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: tealColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'تم',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
