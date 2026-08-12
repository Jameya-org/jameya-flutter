import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _governorateController;
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;
  late final TextEditingController _birthDateController;

  // ✅ FocusNodes عشان نتحكم في الانتقال بين الحقول بزرار Enter
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _nationalIdFocus = FocusNode();
  final FocusNode _governorateFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _streetFocus = FocusNode();

  static const int _phoneLength = 11;
  static const int _nationalIdLength = 14;

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

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _nationalIdFocus.dispose();
    _governorateFocus.dispose();
    _cityFocus.dispose();
    _streetFocus.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    // لو الكيبورد فاتح لأي حقل، اقفله الأول
    FocusScope.of(context).unfocus();

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

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _nationalIdController.text.trim().isEmpty ||
        _governorateController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _streetController.text.trim().isEmpty ||
        _selectedBirthDate == null) {
      _showValidationError('من فضلك املأ كل الحقول المطلوبة');
      return;
    }

    // ✅ التحقق من طول رقم الهاتف (11 رقم)
    if (_phoneController.text.trim().length != _phoneLength) {
      _showValidationError('رقم الهاتف لازم يكون $_phoneLength رقم');
      FocusScope.of(context).requestFocus(_phoneFocus);
      return;
    }

    // ✅ التحقق من طول الرقم القومي (14 رقم)
    if (_nationalIdController.text.trim().length != _nationalIdLength) {
      _showValidationError('الرقم القومي لازم يكون $_nationalIdLength رقم');
      FocusScope.of(context).requestFocus(_nationalIdFocus);
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
          content: Text('تم حفظ التعديلات بنجاح ✅'),
          backgroundColor: Color(0xFF1A7A6E),
        ),
      );
      Navigator.pop(context);
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
      textDirection: TextDirection.ltr,
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            final profile = provider.profile;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
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
                            // ✅ بادچ القلم زي الصورة (شكلي فقط، تعديل الصورة نفسه من شاشة البروفايل)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A7A6E),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile?.name ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile?.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildField(
                    label: 'الأسم',
                    controller: _nameController,
                    icon: Icons.person_outline,
                    focusNode: _nameFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_phoneFocus),
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'البريد الإلكتروني',
                    controller: _emailController,
                    icon: Icons.mail_outline,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'رقم الهاتف',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.number,
                    focusNode: _phoneFocus,
                    textInputAction: TextInputAction.next,
                    maxLength: _phoneLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_nationalIdFocus),
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'الرقم القومي',
                    controller: _nationalIdController,
                    icon: Icons.badge_outlined,
                    keyboardType: TextInputType.number,
                    focusNode: _nationalIdFocus,
                    textInputAction: TextInputAction.next,
                    maxLength: _nationalIdLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_governorateFocus),
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'المحافظة',
                    controller: _governorateController,
                    icon: Icons.map_outlined,
                    focusNode: _governorateFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_cityFocus),
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'المدينة',
                    controller: _cityController,
                    icon: Icons.location_city_outlined,
                    focusNode: _cityFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_streetFocus),
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'العنوان بالتفصيل',
                    controller: _streetController,
                    icon: Icons.location_on_outlined,
                    focusNode: _streetFocus,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      // آخر حقل نصي: نقفل الكيبورد ونفتح تاريخ الميلاد زي الصورة
                      FocusScope.of(context).unfocus();
                      _pickBirthDate();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildField(
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
                              'حفظ التغييرات',
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
                      onPressed: () => Navigator.pop(context),
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    TextDirection textDirection = TextDirection.rtl,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          textDirection: textDirection,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            counterText: '', // ✅ نخفي عداد الحروف الافتراضي
            prefixIcon: Icon(icon, color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A7A6E)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }
}
