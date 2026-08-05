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
      // Force RTL layout to match the Arabic design
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
      theme: ThemeData(
        fontFamily: 'Cairo', // Use any Arabic-supporting font you like
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AccountVerificationPage(),
    );
  }
}

class AccountVerificationPage extends StatelessWidget {
  const AccountVerificationPage({super.key});

  static const Color tealColor = Color(0xFF15A79A);
  static const Color lightTealBg = Color(0xFFB7F0EC);
  static const Color fieldBg = Color(0xFFF4F5F7);
  static const Color labelGrey = Color(0xFF9A9DA6);
  static const Color valueDark = Color(0xFF1F2126);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AppBar row: title + back chevron
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.chevron_right, color: tealColor, size: 26),
                  const Spacer(),
                  const Text(
                    'توثيق الحساب',
                    style: TextStyle(
                      color: tealColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 26), // balance the chevron width
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Main card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE7E8EC)),
                ),
                child: Column(
                  children: [
                    // Check icon circle
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: lightTealBg,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: tealColor, width: 2.5),
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: tealColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'الهوية موثقة',
                      style: TextStyle(
                        color: valueDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    const Text(
                      'تم التحقق من هويتك بنجاح.\nيمكنك الآن الاستفادة من جميع ميزات التطبيق.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: labelGrey,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info fields
                    _InfoField(
                      label: 'الاسم الكامل',
                      value: 'محمد عبدالله العلي',
                    ),
                    const SizedBox(height: 12),
                    _InfoField(label: 'رقم الهوية', value: '1234567890'),
                    const SizedBox(height: 12),
                    _InfoField(label: 'تاريخ التوثيق', value: '15/1/2026'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;

  const _InfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AccountVerificationPage.fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AccountVerificationPage.valueDark,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AccountVerificationPage.labelGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
