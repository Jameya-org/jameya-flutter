import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_tile.dart';
import '../widgets/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<ProfileProvider>().logout(context);
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // ✅ leading بدل actions عشان يظهر يمين في RTL زي الصورة
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.teal, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null && provider.profile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: provider.loadProfile,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            final profile = provider.profile;
            if (profile == null) return const SizedBox();

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: ProfileHeader(profile: profile),
                  ),
                  const SizedBox(height: 12),
                  SettingsSection(
                    title: 'إعدادات الحساب',
                    tiles: [
                      SettingsTile(
                        title: 'المعلومات الشخصية',
                        iconBgColor: const Color(0xFFD6EAF8),
                        iconColor: const Color(0xFF3498DB),
                        icon: Icons.person_outline,
                        trailingIcon:
                            Icons.chevron_left, // ✅ أيقونة السهم على اليمين
                        onTap: () =>
                            Navigator.pushNamed(context, '/personal-info'),
                      ),
                      SettingsTile(
                        title: 'طرق الدفع',
                        iconBgColor: const Color(0xFFFFF3CD),
                        iconColor: const Color(0xFFD4A017),
                        icon: Icons.credit_card,
                        trailingIcon: Icons.chevron_left,
                        onTap: () =>
                            Navigator.pushNamed(context, '/payment-methods'),
                      ),
                      SettingsTile(
                        title: 'توثيق الهوية',
                        iconBgColor: const Color(0xFFD5F5E3),
                        iconColor: const Color(0xFF27AE60),
                        icon: Icons.fingerprint,
                        trailingIcon: Icons.chevron_left,
                        onTap: () =>
                            Navigator.pushNamed(context, '/kyc-verification'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SettingsSection(
                    title: 'الدعم و المعلومات',
                    tiles: [
                      SettingsTile(
                        title: 'الشروط و الاحكام',
                        iconBgColor: const Color(0xFFD6EAF8),
                        iconColor: const Color(0xFF3498DB),
                        icon: Icons.description_outlined,
                        trailingIcon: Icons.chevron_left,
                        onTap: () => Navigator.pushNamed(context, '/terms'),
                      ),
                      SettingsTile(
                        title: 'عن تطبيق جمعيه',
                        iconBgColor: const Color(0xFFFDEBD0),
                        iconColor: const Color(0xFFE67E22),
                        icon: Icons.help_outline,
                        trailingIcon: Icons.chevron_left,
                        trailingText: '1.0 V', // ✅ رقم الإصدار جوه نفس الصف
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LogoutButton(onTap: () => _confirmLogout(context)),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
        // ✅ الـ Bottom Navigation Bar الناقص
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Expanded(
                  child: _NavItem(
                    icon: Icons.person,
                    label: 'حسابي',
                    selected: true,
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.payments_outlined,
                    label: 'سجل التعاملات',
                    selected: false,
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.sync,
                    label: 'جمعياتي',
                    selected: false,
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.home_outlined,
                    label: 'الرئيسية',
                    selected: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF1A7A6E) : Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
