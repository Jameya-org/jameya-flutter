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
      title: 'Profile Page',
      theme: ThemeData(
        fontFamily: 'Cairo',
        primaryColor: const Color(0xFF0F8A7F),
        scaffoldBackgroundColor: Colors.white,
      ),

      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(
    text: 'احمد سامح',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'example@example.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '0100312546',
  );
  final TextEditingController _addressController = TextEditingController(
    text: 'المنصورة',
  );
  final TextEditingController _birthDateController = TextEditingController(
    text: '22/4/2001',
  );

  static const Color tealColor = Color(0xFF0F8A7F);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Top chevron
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_right,
                        color: tealColor,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Avatar with edit icon
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xFFEFEFEF),
                          backgroundImage: AssetImage(
                            'assets/images/Frame 1321315920.png',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: tealColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Name
                    Text(
                      _nameController.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1B3A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'omar.j@example.com',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 28),

                    // Form fields
                    _buildField(
                      label: 'الأسم',
                      controller: _nameController,
                      textDirection: TextDirection.ltr,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 18),
                    _buildField(
                      label: 'البريد الإلكتروني',
                      controller: _emailController,
                      textDirection: TextDirection.ltr,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 18),
                    _buildField(
                      label: 'رقم الهاتف',
                      controller: _phoneController,
                      textDirection: TextDirection.ltr,
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 18),
                    _buildField(
                      label: 'العنوان',
                      controller: _addressController,
                      textDirection: TextDirection.ltr,
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 18),
                    _buildField(
                      label: 'تاريخ الميلاد',
                      controller: _birthDateController,
                      textDirection: TextDirection.ltr,
                      icon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 28),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // Save changes logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tealColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'حفظ التغييرات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cancel button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          // Cancel logic
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: tealColor, width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                            color: tealColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom navigation bar
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required TextDirection textDirection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Directionality(
            textDirection: textDirection,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(icon, color: Colors.grey[500], size: 20),
                ),
              ),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.person_outline, 'حسابي', selected: true),
          _buildNavItem(Icons.payments_outlined, 'سجل التعاملات'),
          _buildNavItem(Icons.sync, 'جمعياتي'),
          _buildNavItem(Icons.home_outlined, 'الرئيسية'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool selected = false}) {
    final color = selected ? tealColor : Colors.grey[500];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
