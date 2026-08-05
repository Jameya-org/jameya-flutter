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
      locale: const Locale('ar'),
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: TermsAndConditionsPage(),
      ),
    );
  }
}

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  static const Color primaryTeal = Color(0xFF17A398);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الشروط والاحكام',
          style: TextStyle(
            color: primaryTeal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: primaryTeal),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE7E7E7)),
                ),
                child: const Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن '
                  'الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع '
                  'ودور النشر. كان لوريم إيبسوم والايزال المعيار للنص الشكلي '
                  'منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من '
                  'الأحرف بشكل عشوائي أخذتها من نص لتكوّن كتيّب بمثابة دليل أو '
                  'مرجع شكلي لهذه الأحرف. خمسة قرون من الزمن لم تقضي على هذا '
                  'النص، بل انه صار مستخدماً وبشكله الأصلي في الطباعة '
                  'والتنضيد الإلكتروني. انتشر بشكل كبير في ستينيّات هذا القرن '
                  'مع إصدار رقائق "ليتراسيت" (Letraset) البلاستيكية تحوي '
                  'مقاطع من هذا النص، وعاد لينتشر مرة أخرى مؤخراً مع ظهور '
                  'برامج النشر الإلكتروني مثل "ألدوس بايج مايكر" (Aldus '
                  'PageMaker) والتي حوت أيضاً على نسخ من نص لوريم إيبسوم.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.9,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const Center(
                child: Text(
                  'Jameya',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryTeal,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  '1.0 V',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  '© 2026 جمعيتي. جميع الحقوق محفوظة.',
                  style: TextStyle(fontSize: 12, color: Color(0xFFBFBFBF)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          textDirection: TextDirection.ltr,
          children: const [
            _NavBarItem(
              icon: Icons.person_outline,
              label: 'حسابي',
              active: true,
            ),
            _NavBarItem(icon: Icons.payments_outlined, label: 'سجل التعاملات'),
            _NavBarItem(icon: Icons.sync, label: 'جمعياتي'),
            _NavBarItem(icon: Icons.home_outlined, label: 'الرئيسية'),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavBarItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF17A398) : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}
