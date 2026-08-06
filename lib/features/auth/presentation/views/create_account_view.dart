import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/network/dio_error_utils.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/services/auth_service.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_title_section.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/phone_number_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/terms_checkbox.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  String countryCode = '+20';
  final nationalIdController = TextEditingController();
  final birthDateController = TextEditingController();

  bool _acceptedTerms = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    nationalIdController.addListener(_validateForm);
    birthDateController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        phoneController.text.length == 11 &&
        nationalIdController.text.length == 14 &&
        birthDateController.text.isNotEmpty &&
        _acceptedTerms;

    setState(() {
      _isButtonEnabled = isValid;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 2.h),
          AuthBackButton(onPressed: () => context.pop()),
          SizedBox(height: 4.h),
          const AuthTitleSection(
            title: 'إنشاء الحساب',
            subtitle: 'اكتب بياناتك علشان تبدأ رحلتك',
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentMinHeight = constraints.maxHeight - 56.h;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(top: 32.h, bottom: 24.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: contentMinHeight > 0 ? contentMinHeight : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabeledTextField(
                          label: 'الاسم الأول',
                          controller: firstNameController,
                          hintText: 'حسام',
                        ),
                        SizedBox(height: 16.h),
                        LabeledTextField(
                          label: 'الاسم الأخير',
                          controller: lastNameController,
                          hintText: 'حسن',
                        ),
                        SizedBox(height: 16.h),
                        PhoneNumberField(
                          controller: phoneController,
                          onCountryChanged: (code) {
                            countryCode = code;
                          },
                        ),
                        SizedBox(height: 16.h),
                        LabeledTextField(
                          label: 'الرقم القومي',
                          controller: nationalIdController,
                          hintText: '30123456789012',
                        ),
                        SizedBox(height: 16.h),
                        LabeledTextField(
                          label: 'تاريخ الميلاد',
                          controller: birthDateController,
                          hintText: 'YYYY-MM-DD',
                          readOnly: true,
                          onTap: _selectDate,
                        ),
                        SizedBox(height: 50.h),
                        TermsCheckbox(
                          value: _acceptedTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptedTerms = value ?? true;
                            });
                            _validateForm();
                          },
                          onTermsTap: () {
                            context.push(AppRoutes.kTermsAndConditionsView);
                          },
                          onPrivacyTap: () {
                            context.push(AppRoutes.kTermsAndConditionsView);
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                    PrimaryButton(
                      text: 'تأكيد',
                      isEnabled: _isButtonEnabled,
                      onPressed: _isButtonEnabled
                          ? () async {
                              await _register();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _register() async {
    try {
      final mobileNumber = '$countryCode${phoneController.text}';
      final legalName = '${firstNameController.text} ${lastNameController.text}';

      await getIt<AuthService>().completeProfile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        nationalId: nationalIdController.text,
        dateOfBirth: birthDateController.text,
        mobileNumber: mobileNumber,
      );

      final cache = getIt<CacheHelper>();
      await cache.saveData(key: CacheKeys.legalName, value: legalName);
      await cache.saveData(key: CacheKeys.phone, value: mobileNumber);
      await cache.saveData(
        key: CacheKeys.nationalId,
        value: nationalIdController.text,
      );
      await cache.saveData(
        key: CacheKeys.birthDate,
        value: birthDateController.text,
      );

      if (mounted) {
        context.go(AppRoutes.kProfileView);
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              dioErrorMessage(e, fallback: 'حدث خطأ في إنشاء الحساب'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('حدث خطأ غير متوقع')));
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      birthDateController.text =
          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';

      _validateForm();
    }
  }
}
