import 'package:flutter/material.dart';

// Colors used across the screen
const Color kTeal = Color(0xFF0E7C7B);
const Color kTealDark = Color(0xFF0B6564);
const Color kBgGrey = Color(0xFFF7F8FA);
const Color kCardGrey = Color(0xFFE9EBEE);
const Color kTextGrey = Color(0xFF8A8F98);
const Color kBorderGrey = Color(0xFFE3E6EA);

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
        useMaterial3: true,
      ),
      home: const SavedCardsPage(),
    );
  }
}

class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({super.key});

  @override
  State<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  final PageController _pageController = PageController(viewportFraction: 0.86);
  final List<Widget> _cards = const [_GreyCreditCard(), _VisaCard()];
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  const Icon(Icons.chevron_right, color: kTeal, size: 28),
                  const Text(
                    'البطاقات المحفوظة',
                    style: TextStyle(
                      color: kTeal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card carousel
            SizedBox(
              height: 210,
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                pageSnapping: true,
                itemCount: _cards.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _cards[index],
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_cards.length, (index) {
                final bool active = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? kTeal : kBorderGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Info banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF6F5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFCFE9E7)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user_outlined,
                              color: kTeal,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'سيتم استخدام هذه البطاقة تلقائياً',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kTeal,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'عند سداد أقساط الجمعيات والمبالغ المستحقة.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kTextGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Edit / Delete buttons
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.edit_outlined,
                            iconColor: kTeal,
                            iconBg: const Color(0xFFE6F1F8),
                            label: 'تعديل البطاقة',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.delete_outline,
                            iconColor: const Color(0xFFE4685D),
                            iconBg: const Color(0xFFFBE7E5),
                            label: 'حذف البطاقة',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Security note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.lock_outline, size: 16, color: kTextGrey),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'بيانات بطاقتك مشفرة وآمنة ولا يتم الاحتفاظ برقم البطاقة بالكامل.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kTextGrey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Done button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'تم',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Back button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kTeal,
                          side: const BorderSide(color: kTeal),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'رجوع',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom navigation bar
            _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorderGrey),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreyCreditCard extends StatefulWidget {
  const _GreyCreditCard({super.key});

  @override
  State<_GreyCreditCard> createState() => _GreyCreditCardState();
}

class _GreyCreditCardState extends State<_GreyCreditCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'VISA',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                'Credit Card',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '• • • •   • • • •   • • • •',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  color: Colors.black87,
                ),
              ),
              Text(
                '8 8 3 2',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EXPIRES',
                style: TextStyle(color: Colors.black45, fontSize: 10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(color: Colors.black45, fontSize: 10),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'أحمد محمد',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisaCard extends StatelessWidget {
  const _VisaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kTealDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            '• • • •   • • • •   • • • •   • • • •',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 1,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'EXPIRES',
            style: TextStyle(color: Colors.white60, fontSize: 10),
          ),
          const SizedBox(height: 2),
          const Text(
            '12/26',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kBorderGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.rtl,
        children: const [
          _NavItem(icon: Icons.home_outlined, label: 'الرئيسية', active: false),
          _NavItem(icon: Icons.autorenew, label: 'جمعياتي', active: false),
          _NavItem(
            icon: Icons.payments_outlined,
            label: 'سجل التعاملات',
            active: false,
          ),
          _NavItem(icon: Icons.person_outline, label: 'حسابي', active: true),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? kTeal : kTextGrey;
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
