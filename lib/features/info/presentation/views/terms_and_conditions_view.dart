import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'الشروط و الاحكام',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xFF1A7A6E),
              size: 18,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'الشروط والأحكام الخاصة بالتطبيق والمستخدم.',
                textAlign: TextAlign.right,
                style: TextStyle(height: 1.8, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              const Text(
                'Jameya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A7A6E),
                ),
              ),
              const SizedBox(height: 4),
              const Text('1.0 V', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                '© 2026 جمعيتي. جميع الحقوق محفوظة.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
