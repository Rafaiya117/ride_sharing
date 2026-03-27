import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/confirm_widthdrawal/confirm_withdrawal_controller/confirm_withdrawal_controller.dart';

class ConfirmWithdrawalView extends StatelessWidget {
  const ConfirmWithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ConfirmWithdrawalController>();
    final data = controller.data;

    return BaseScaffold(
      title: "Confirm Withdrawal",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.goBack(context),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),

          // 1. Blue Summary Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E4597), Color(0xFF0C1C3E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text("Total Amount",
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                SizedBox(height: 8.h),
                Text("\$${data.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(data.date,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          // 2. Withdrawal Method Card
          _buildInfoSection(
            title: "Withdraw to",
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.credit_card, size: 24.sp, color: Colors.black),
                ),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.methodTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    Text(data.methodSubtitle,
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          // 3. Important Info Box
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: const Color(0xFF1E4597), size: 20.sp),
                    SizedBox(width: 8.w),
                    Text("Important",
                        style: TextStyle(
                            color: const Color(0xFF1E4597),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp)),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "Withdrawals usually take 3-5 business days to process depending on your bank.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: const Color(0xFF1E4597),
                      fontSize: 12.sp,
                      height: 1.5),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 4. Action Buttons
          CustomButton(
            text: "Withdraw Earnings",
            onTap: () => controller.confirmAndWithdraw(context),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: OutlinedButton(
              onPressed: () => controller.goBack(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text("Go Back",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500)),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }
}