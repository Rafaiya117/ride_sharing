import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
      title: Row(
    children: [
      // 1. Expanded takes up the middle space
      Expanded(
        child: Text(
          "Confirm Withdrawal",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // 2. Invisible spacer to balance the back button's width (approx 48)
      const SizedBox(width: 48), 
    ],
  ),
  titleAlign: TextAlign.center,
  isCurved: true,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => controller.goBack(context),
  ),
      child: Column(
        children: [
          SizedBox(height: 10.h),

          // 1. Summary Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
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
                Text("Total Amount", style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp)),
                SizedBox(height: 5.h),
                Text("\$${data.amount.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 48.sp, fontWeight: FontWeight.bold)),
                Text(
                  "Will arrive in 1-3 business days",
                  style: GoogleFonts.inter(color: const Color(0xFF00E676), fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20.h),
                // Inner Breakdown
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow("Withdrawal Amount", "\$${data.amount.toInt()}"),
                      SizedBox(height: 15.h),
                      _buildSummaryRow("Processing Fee", "Free"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Divider(color: Colors.white24, thickness: 1),
                      ),
                      _buildSummaryRow("You'll Receive", "\$${data.amount.toStringAsFixed(2)}", isBold: true, fontSize: 20.sp),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          // 2. Withdrawal Method Section
          _buildInfoSection(
            title: "Withdraw to",
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12.r)),
                  child: SvgPicture.asset('assets/icons/card.svg', width: 24.sp, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
                ),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.methodTitle, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    Text(data.methodSubtitle, style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          // 3. SEPARATE Important Info Box
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF).withOpacity(0.5),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xFFE0E7FF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Left aligned
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/info.svg', width: 24.sp, colorFilter: const ColorFilter.mode(Color(0xFF2563EB), BlendMode.srcIn)),
                    SizedBox(width: 12.w),
                    Text("Important", style: GoogleFonts.inter(color: const Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Once confirmed, this withdrawal cannot be cancelled. Please verify all details before proceeding.",
                  style: GoogleFonts.inter(color: const Color(0xFF2563EB), fontSize: 14.sp, height: 1.4, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h), // Replaced Spacer to fix unbounded height crash

          // 4. Action Buttons
          CustomButton(text: "Withdraw Earnings", onTap: () => controller.confirmAndWithdraw(context)),
          SizedBox(height: 15.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: OutlinedButton(
              onPressed: () => controller.goBack(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text("Go Back", style: GoogleFonts.inter(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, double? fontSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: fontSize ?? 15.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: fontSize ?? 15.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildInfoSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }
}