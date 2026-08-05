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
      title: 'حسابي',
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color tealColor = Color(0xFF0E7C7B);
  static const Color pinkColor = Color(0xFFF9D8D6);
  static const Color pinkTextColor = Color(0xFFE05A50);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      // Top chevron
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.chevron_left,
                            size: 28,
                            color: tealColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Avatar
                      Center(
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/Frame 1321315920.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'احمد سامح',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          'omar.j@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // إعدادات الحساب section
                      SettingsSection(
                        title: 'إعدادات الحساب',
                        items: [
                          SettingsItemData(
                            label: 'المعلومات الشخصية',
                            icon: Icons.person_outline,
                            iconBg: const Color(0xFFDCEFFB),
                            iconColor: const Color(0xFF3B9DD6),
                          ),
                          SettingsItemData(
                            label: 'طرق الدفع',
                            icon: Icons.credit_card,
                            iconBg: const Color(0xFFFBF3CF),
                            iconColor: const Color(0xFFCBAF2E),
                          ),
                          SettingsItemData(
                            label: 'توثيق الهوية',
                            icon: Icons.fingerprint,
                            iconBg: const Color(0xFFDCF3E3),
                            iconColor: const Color(0xFF3FAE64),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // الدعم والمعلومات section
                      SettingsSection(
                        title: 'الدعم و المعلومات',
                        items: [
                          SettingsItemData(
                            label: 'الشروط و الاحكام',
                            icon: Icons.description_outlined,
                            iconBg: const Color(0xFFDCEFFB),
                            iconColor: const Color(0xFF3B9DD6),
                          ),
                          SettingsItemData(
                            label: 'عن تطبيق جمعيه',
                            icon: Icons.help_outline,
                            iconBg: const Color(0xFFFCE7CF),
                            iconColor: const Color(0xFFE0932E),
                            trailingText: '1.0 V',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Logout button
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: pinkColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'تسجيل الخروج',
                                style: TextStyle(
                                  color: pinkTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.logout,
                                color: pinkTextColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const BottomNavBarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsItemData {
  final String label;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String? trailingText;

  SettingsItemData({
    required this.label,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.trailingText,
  });
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItemData> items;

  const SettingsSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            color: ProfileScreen.tealColor,
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          // Items
          for (int i = 0; i < items.length; i++) ...[
            SettingsRow(data: items[i]),
            if (i != items.length - 1)
              Divider(height: 1, color: Colors.grey.shade200),
          ],
        ],
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  final SettingsItemData data;

  const SettingsRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.chevron_left, color: ProfileScreen.tealColor),
            const SizedBox(width: 8),
            if (data.trailingText != null)
              Text(
                data.trailingText!,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
            const Spacer(),
            Text(
              data.label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: data.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, color: data.iconColor, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.ltr,
        children: const [
          _NavBarItem(icon: Icons.person_outline, label: 'حسابي', active: true),
          _NavBarItem(icon: Icons.payments_outlined, label: 'سجل التعاملات'),
          _NavBarItem(icon: Icons.sync, label: 'جمعياتي'),
          _NavBarItem(icon: Icons.home_outlined, label: 'الرئيسية'),
        ],
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
    final color = active ? ProfileScreen.tealColor : Colors.grey;
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
