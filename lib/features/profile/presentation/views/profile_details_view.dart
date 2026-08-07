import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../features/kyc/presentation/providers/kyc_provider.dart';
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
    // Identity fields come from KycProvider.kycStatus.identityProfile
    final identity =
        context.read<KycProvider>().kycStatus?.identityProfile;

    _nameController = TextEditingController(text: profile?.legalName ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(
      text: identity?.mobileNumber ?? profile?.mobileNumber ?? '',
    );
    _nationalIdController = TextEditingController(
      text: identity?.nationalIdNumber ?? '',
    );
    _governorateController = TextEditingController(
      text: identity?.address?.governorate ?? '',
    );
    _cityController = TextEditingController(
      text: identity?.address?.city ?? '',
    );
    _streetController = TextEditingController(
      text: identity?.address?.streetAddress ?? '',
    );

    final storedBirthDate = _parseStoredBirthDate(identity?.dateOfBirth);
    _selectedBirthDate = storedBirthDate;
    _birthDateController = TextEditingController(
      text: storedBirthDate != null
          ? _formatDate(storedBirthDate)
          : (identity?.dateOfBirth ?? ''),
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
        _birthDateController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  DateTime? _parseStoredBirthDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    // Try dd/mm/yyyy
    final parts = raw.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    // Fallback to ISO 8601 (yyyy-mm-dd)
    return DateTime.tryParse(raw);
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
      context: context,
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
                          child: Text(
                            (profile?.legalName.isNotEmpty ?? false)
                                ? profile!.legalName[0].toUpperCase()
                                : '؟',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A7A6E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile?.legalName ?? '',
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
