import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../widgets/profile_form_field.dart';

class ProfileDetailsView extends StatefulWidget {
  const ProfileDetailsView({super.key});

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _governorateController;
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;
  late final TextEditingController _birthDateController;

  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _nationalIdController = TextEditingController();
    _governorateController = TextEditingController();
    _cityController = TextEditingController();
    _streetController = TextEditingController();
    _birthDateController = TextEditingController(
      text: profile?.birthDate ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2001, 4, 22),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _nationalIdController.text.trim().isEmpty ||
        _governorateController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _streetController.text.trim().isEmpty ||
        _selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك املأ كل الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = context.read<ProfileProvider>();
    final success = await provider.updateProfile(
      legalName: _nameController.text.trim(),
      mobileNumber: _phoneController.text.trim(),
      nationalIdNumber: _nationalIdController.text.trim(),
      dateOfBirth: _selectedBirthDate!,
      governorate: _governorateController.text.trim(),
      city: _cityController.text.trim(),
      streetAddress: _streetController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التعديلات بنجاح'),
          backgroundColor: Color(0xFF1A7A6E),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'فشل حفظ التعديلات'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xFF1A7A6E),
              size: 18,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            final profile = provider.profile;
            final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardInset + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: profile?.avatarUrl != null
                              ? NetworkImage(profile!.avatarUrl!)
                              : null,
                          child: profile?.avatarUrl == null
                              ? Text(
                                  (profile?.name.isNotEmpty ?? false)
                                      ? profile!.name[0].toUpperCase()
                                      : '؟',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A7A6E),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile?.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ProfileFormField(
                    label: 'الأسم',
                    controller: _nameController,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  ProfileFormField(
                    label: 'البريد الإلكتروني',
                    controller: _emailController,
                    icon: Icons.mail_outline,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  ProfileFormField(
                    label: 'رقم الهاتف',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  ProfileFormField(
                    label: 'الرقم القومي',
                    controller: _nationalIdController,
                    icon: Icons.badge_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ProfileFormField(
                    label: 'المحافظة',
                    controller: _governorateController,
                    icon: Icons.map_outlined,
                  ),
                  const SizedBox(height: 16),
                  ProfileFormField(
                    label: 'المدينة',
                    controller: _cityController,
                    icon: Icons.location_city_outlined,
                  ),
                  const SizedBox(height: 16),
                  ProfileFormField(
                    label: 'العنوان بالتفصيل',
                    controller: _streetController,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),
                  ProfileFormField(
                    label: 'تاريخ الميلاد',
                    controller: _birthDateController,
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: _pickBirthDate,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A7A6E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: provider.isSaving ? null : _save,
                      child: provider.isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'حفظ التعديلات',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1A7A6E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.pop(),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          color: Color(0xFF1A7A6E),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
