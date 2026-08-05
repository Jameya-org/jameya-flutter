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
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AccountVerificationScreen(),
    );
  }
}

class AccountVerificationScreen extends StatelessWidget {
  const AccountVerificationScreen({super.key});

  static const Color tealColor = Color(0xFF0F766E);
  static const Color lightGreyBar = Color(0xFFE5E7EB);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color itemBg = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top header with title and arrow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.chevron_right, color: tealColor, size: 22),
                  const Text(
                    'توثيق الحساب',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: tealColor,
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),
            ),

            // Step progress indicator (3 steps, last one active/teal)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Expanded(child: _StepBar(color: lightGreyBar)),
                  SizedBox(width: 6),
                  Expanded(child: _StepBar(color: lightGreyBar)),
                  SizedBox(width: 6),
                  Expanded(child: _StepBar(color: tealColor)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Main card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                ),
                child: Column(
                  children: [
                    // Red X circle icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDECEC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFFE94B4B),
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'الهوية غير موثقة',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Description
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'يجب التحقق من هويتك للاستفادة من جميع ميزات التطبيق ورفع حدود المعاملات.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Item: الهوية الوطنية
                    const _VerificationItem(label: 'الهوية الوطنية'),
                    const SizedBox(height: 12),

                    // Item: إثبات المرتب
                    const _VerificationItem(label: 'إثبات المرتب'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tealColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'ابدأ التوثيق',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBar extends StatelessWidget {
  final Color color;
  const _StepBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _VerificationItem extends StatelessWidget {
  final String label;
  const _VerificationItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFF5A623), size: 20),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
