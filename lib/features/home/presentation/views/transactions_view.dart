import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubit/transactions_cubit.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'سجل المعاملات',
            style: AppTextStyles.title.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: AppColors.primary),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            if (state is TransactionsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            // For now, always show the UI even if it's the initial/loaded state
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'القسط المستحق',
                style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12.h),
              _buildDueInstallmentCard(context),
              SizedBox(height: 24.h),
              Text(
                'القسط المستحق', // As requested in the exact design
                style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12.h),
              _buildTransactionItem(
                icon: Icons.check_circle_outline,
                iconColor: AppColors.primary,
                iconBgColor: const Color(0xFFE0F7FA),
                title: 'جمعية شهر 12 | يناير 2026',
                subtitle: null,
                pillText: 'تم الاستلام',
                pillColor: const Color(0xFFE0F7FA),
                pillTextColor: AppColors.primary,
                amount: '13,000 ج.م',
              ),
              SizedBox(height: 12.h),
              _buildTransactionItem(
                icon: Icons.error_outline,
                iconColor: const Color(0xFFF57C00),
                iconBgColor: const Color(0xFFFFF3E0),
                title: 'جمعية شهر 12 | يناير 2026',
                subtitle: 'القسط # 5',
                pillText: 'قسط متأخر',
                pillColor: const Color(0xFFFFF3E0),
                pillTextColor: const Color(0xFFF57C00),
                amount: '1,000 ج.م',
              ),
              SizedBox(height: 12.h),
              _buildTransactionItem(
                icon: Icons.check_circle_outline,
                iconColor: AppColors.primary,
                iconBgColor: const Color(0xFFE0F7FA),
                title: 'جمعية شهر 12 | يناير 2026',
                subtitle: 'القسط # 3',
                pillText: 'تم الدفع',
                pillColor: const Color(0xFFE0F7FA),
                pillTextColor: AppColors.primary,
                amount: '1,000 ج.م',
              ),
              SizedBox(height: 12.h),
              _buildTransactionItem(
                icon: Icons.check_circle_outline,
                iconColor: AppColors.primary,
                iconBgColor: const Color(0xFFE0F7FA),
                title: 'جمعية شهر 12 | يناير 2026',
                subtitle: 'القسط # 2',
                pillText: 'تم الدفع',
                pillColor: const Color(0xFFE0F7FA),
                pillTextColor: AppColors.primary,
                amount: '1,000 ج.م',
              ),
              SizedBox(height: 12.h),
              _buildTransactionItem(
                icon: Icons.check_circle_outline,
                iconColor: AppColors.primary,
                iconBgColor: const Color(0xFFE0F7FA),
                title: 'جمعية شهر 12 | يناير 2026',
                subtitle: 'القسط # 1',
                pillText: 'تم الدفع',
                pillColor: const Color(0xFFE0F7FA),
                pillTextColor: AppColors.primary,
                amount: '1,000 ج.م',
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    ),
  ),
);
  }

  Widget _buildDueInstallmentCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جمعية شهر 12 | يناير 2026',
                    style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'استحقاق: 25 يناير 2026',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  'مستحق قريباً',
                  style: AppTextStyles.label.copyWith(color: const Color(0xFFF57C00), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1,000 ج.م',
                style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 40.h,
                width: 130.w,
                child: CustomButton(
                  text: 'ادفع الآن',
                  borderRadius: 8.r,
                  onPressed: () {
                    // Navigate to payment details
                    context.push('/payment-details');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    required String pillText,
    required Color pillColor,
    required Color pillTextColor,
    required String amount,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBgColor,
            ),
            child: Icon(icon, color: iconColor, size: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                  ),
                ]
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: pillColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  pillText,
                  style: AppTextStyles.label.copyWith(color: pillTextColor, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                amount,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
