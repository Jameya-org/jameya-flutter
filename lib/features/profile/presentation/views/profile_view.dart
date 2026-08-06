import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/routes.dart';
import '../providers/profile_provider.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_nav_item.dart';
import '../widgets/settings_tile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileProvider>().loadProfile();
      }
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
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.teal, size: 18),
            onPressed: () => context.pop(),
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
                        onTap: () => context.push(AppRoutes.kProfileDetailsView),
                      ),
                      SettingsTile(
                        title: 'طرق الدفع',
                        iconBgColor: const Color(0xFFFFF3CD),
                        iconColor: const Color(0xFFD4A017),
                        icon: Icons.credit_card,
                        onTap: () => context.push(AppRoutes.kPaymentMethodsView),
                      ),
                      SettingsTile(
                        title: 'توثيق الهوية',
                        iconBgColor: const Color(0xFFD5F5E3),
                        iconColor: const Color(0xFF27AE60),
                        icon: Icons.fingerprint,
                        onTap: () => context.push(AppRoutes.kKycVerificationView),
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
                        onTap: () => context.push(AppRoutes.kTermsAndConditionsView),
                      ),
                      SettingsTile(
                        title: 'عن تطبيق جمعيه',
                        iconBgColor: const Color(0xFFFDEBD0),
                        iconColor: const Color(0xFFE67E22),
                        icon: Icons.help_outline,
                        trailingText: '1.0 V',
                        onTap: () {},
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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
                  child: ProfileNavItem(
                    icon: Icons.person,
                    label: 'حسابي',
                    selected: true,
                  ),
                ),
                Expanded(
                  child: ProfileNavItem(
                    icon: Icons.payments_outlined,
                    label: 'سجل التعاملات',
                    selected: false,
                  ),
                ),
                Expanded(
                  child: ProfileNavItem(
                    icon: Icons.sync,
                    label: 'جمعياتي',
                    selected: false,
                  ),
                ),
                Expanded(
                  child: ProfileNavItem(
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
