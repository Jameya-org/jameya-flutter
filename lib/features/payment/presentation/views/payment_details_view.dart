import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/transaction_detail_model.dart';
import '../cubit/payment_details_cubit.dart';

class PaymentDetailsView extends StatelessWidget {
  const PaymentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<PaymentDetailsCubit, PaymentDetailsState>(
        builder: (context, state) {
          // ── Result screen (paid / pending / failed) ──────────────
          if (state is PaymentDetailsResult) {
            return _ResultScreen(model: state.model);
          }

          // ── Processing overlay ────────────────────────────────────
          final model = state is PaymentDetailsReady
              ? state.model
              : (state as PaymentDetailsProcessing).model;
          final isLoading = state is PaymentDetailsProcessing;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: _buildAppBar(context, 'تفاصيل العملية'),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PaymentMethodCard(model: model),
                      SizedBox(height: 16.h),
                      _InstallmentCard(model: model),
                    ],
                  ),
                ),
                if (isLoading)
                  const ColoredBox(
                    color: Color(0x55000000),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: _buildPayButton(context, isLoading),
          );
        },
      ),
    );
  }

  // ── Shared AppBar ─────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: const SizedBox.shrink(),
      actions: [
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 20.sp,
          ),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        SizedBox(width: 4.w),
      ],
      title: Text(
        title,
        style: AppTextStyles.subtitle.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Pay button ───────────────────────────────────────────────────
  Widget _buildPayButton(BuildContext context, bool isLoading) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: CustomButton(
          text: 'ادفع الآن',
          onPressed: isLoading
              ? () {}
              : () => context.read<PaymentDetailsCubit>().payInstallment(),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({this.model});
  final TransactionDetailModel? model;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: _InfoRow(
        label: 'طريقة الدفع',
        value: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model?.cardBrand ?? 'Credit card',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2.h),
              Text(
                '**** ${model?.cardLast4 ?? '1 1 1 1'}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// Installment-details card
// ════════════════════════════════════════════════════════════════
class _InstallmentCard extends StatelessWidget {
  const _InstallmentCard({this.model});
  final TransactionDetailModel? model;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Column(
        children: [
          _InfoRow(
            label: 'الجمعية',
            value: Text(
              model?.circleName ?? 'جمعية شهر 12',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 14.h),
          _InfoRow(
            label: 'القسط',
            value: Text(
              '# ${model?.installmentNumber ?? '2'}',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: const Divider(color: AppColors.grey200, height: 1),
          ),
          _InfoRow(
            label: 'المبلغ المطلوب',
            value: Text(
              model?.amount ?? '1,000 ج.م',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 14.h),
          _InfoRow(
            label: 'تاريخ الاستحقاق',
            value: Text(
              model?.dueDate ?? '25-4-2026',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (model?.referenceNumber != null) ...[
            SizedBox(height: 14.h),
            _InfoRow(
              label: 'رقم المرجع',
              value: Text(
                model!.referenceNumber!,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// Result screen  (paid ✅ / pending ⏳ / failed ❌)
// ════════════════════════════════════════════════════════════════
class _ResultScreen extends StatelessWidget {
  const _ResultScreen({required this.model});
  final TransactionDetailModel model;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(model.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary,
              size: 20.sp,
            ),
            onPressed: () {
              if (context.canPop()) context.pop();
            },
          ),
          SizedBox(width: 4.w),
        ],
        title: Text(
          'تفاصيل العملية',
          style: AppTextStyles.subtitle.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status illustration card ──────────────────────────
            _InfoCard(
              child: Column(
                children: [
                  Image.asset(
                    config.imagePath,
                    height: 80.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    config.title,
                    style: AppTextStyles.body2.copyWith(
                      color: config.titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (config.subtitle != null) ...[
                    SizedBox(height: 6.h),
                    Text(
                      config.subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // ── Transaction details card ──────────────────────────
            _InfoCard(
              child: Column(
                children: [
                  _InfoRow(
                    label: 'الجمعية',
                    value: Text(
                      model.circleName,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _InfoRow(
                    label: 'تاريخ الدفع',
                    value: Text(
                      model.dueDate,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _InfoRow(
                    label: 'طريقة الدفع',
                    value: Text(
                      model.cardBrand,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: const Divider(color: AppColors.grey200, height: 1),
                  ),
                  _InfoRow(
                    label: 'رقم المرجع',
                    value: Text(
                      model.referenceNumber ?? '# 42507026',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (model.status == TransactionStatus.failed) ...[
                    SizedBox(height: 6.h),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        'يرجى مراجعة بيانات الدفع أو تواصل معنا في حال استمرار الخطأ.',
                        style: AppTextStyles.label.copyWith(
                          color: const Color(0xFFE02222),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    if (model.status == TransactionStatus.paid) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: 'حاول مرة أخرى',
              onPressed: () =>
                  context.read<PaymentDetailsCubit>().retryPayment(),
            ),
            if (model.status == TransactionStatus.failed) ...[
              SizedBox(height: 12.h),
              CustomButton(
                text: 'تغيير البطاقة',
                backgroundColor: AppColors.surface,
                textColor: AppColors.primary,
                onPressed: () {
                  // TODO: navigate to change card screen
                  if (context.canPop()) context.pop();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  _StatusConfig _statusConfig(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.paid:
        return const _StatusConfig(
          imagePath: Assets.imagesTransactionPaid,
          title: 'تم إرسال مبلغ الجمعية بنجاح 12,000',
          titleColor: AppColors.primary,
          subtitle: null,
        );
      case TransactionStatus.pending:
        return const _StatusConfig(
          imagePath: Assets.imagesTransactionPending,
          title: 'قسط متأخر',
          titleColor: Color(0xFFF57C00),
          subtitle: null,
        );
      case TransactionStatus.failed:
        return const _StatusConfig(
          imagePath: Assets.imagesTransactionFailed,
          title: 'تعذر إتمام الدفع',
          titleColor: Color(0xFFE02222),
          subtitle:
              'لم تتمكن من متابعة الدفع بسبب بيانات بطاقتك البنكية المدخلة.',
        );
      case TransactionStatus.due:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TransactionStatus.late:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TransactionStatus.received:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

// ════════════════════════════════════════════════════════════════
// Helpers
// ════════════════════════════════════════════════════════════════
class _StatusConfig {
  const _StatusConfig({
    required this.imagePath,
    required this.title,
    required this.titleColor,
    this.subtitle,
  });
  final String imagePath;
  final String title;
  final Color titleColor;
  final String? subtitle;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Align(alignment: Alignment.centerLeft, child: value),
        ),
      ],
    );
  }
}
