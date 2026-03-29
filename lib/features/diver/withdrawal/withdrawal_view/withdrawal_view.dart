import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/withdrawal/withdrawal_controller/withdrawal_controller.dart';
import 'package:ride_sharing/features/diver/withdrawal/withdrawal_model/withdrawal_model.dart';

class WithdrawalView extends StatelessWidget {
  const WithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WithdrawalController>();
    final dashboard = controller.data;

    return BaseScaffold(
      title: Row(
    children: [
      // 1. Expanded takes up the middle space
      Expanded(
        child: Text(
          "Withdraw",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // 2. Invisible spacer to balance the back button (standard is 48px)
      const SizedBox(width: 48), 
    ],
  ),
  titleAlign: TextAlign.center,
  isCurved: true,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => controller.navigateBack(context),
  ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          
          // 1. Balance Summary Row
          Row(
            children: [
              _buildBalanceCard(
                title: "Available",
                amount: "\$${dashboard.availableBalance.toInt()}",
                subText: "Ready to withdraw",
                isDark: true,
                iconPath: 'assets/icons/credit.svg',
              ),
              SizedBox(width: 15.w),
              _buildBalanceCard(
                title: "Pending",
                amount: "\$${dashboard.pendingBalance.toInt()}",
                subText: "Processing",
                isDark: false,
                iconPath: 'assets/icons/clock.svg',
              ),
            ],
          ),
          SizedBox(height: 25.h),

          // 2. Primary CTA
          CustomButton(
            text: "Withdraw Earnings",
            onTap: () => controller.navigateToWithdrawAmount(context),
          ),
          SizedBox(height: 30.h),

          // 3. Monthly Statistics
          _buildSectionTitle("This Month"),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem("Earned", "\$${dashboard.monthlyEarned.toInt()}"),
                _buildStatItem("Withdrawn", "\$${dashboard.monthlyWithdrawn.toInt()}"),
                _buildStatItem("Trips", "${dashboard.monthlyTrips}"),
              ],
            ),
          ),
          SizedBox(height: 30.h),

          // 4. Transaction List
          _buildSectionTitle("Recent Withdrawals"),
          SizedBox(height: 15.h),
          ...dashboard.transactions.map((tx) => _buildTransactionTile(tx)),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)));
  }

  Widget _buildBalanceCard({
  required String title, 
  required String amount, 
  required String subText, 
  required bool isDark, 
  required String iconPath, // Changed from IconData to String
}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: isDark ? const Color(0xFF1E4597) : Colors.white,
        gradient: isDark 
            ? const LinearGradient(
                colors: [Color(0xFF1E4597), Color(0xFF0C1C3E)], 
                begin: Alignment.topLeft, 
                end: Alignment.bottomRight) 
            : null,
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            // Replaced Icon with SvgPicture
            SvgPicture.asset(
              iconPath,
              width: 18.sp,
              height: 18.sp,
              colorFilter: ColorFilter.mode(
                isDark ? Colors.white70 : Colors.deepOrange, // Adjusted color to match labels
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(title, style: GoogleFonts.inter(color: isDark ? Colors.white70 : Colors.grey, fontSize: 13.sp)),
          ]),
          SizedBox(height: 12.h),
          Text(amount, 
            style: GoogleFonts.inter(
              color: isDark ? Colors.white : const Color(0xFFFF4500), // Match the orange/red from image
              fontSize: 28.sp, // Slightly adjusted for better fit
              fontWeight: FontWeight.bold
            )
          ),
          SizedBox(height: 4.h),
          Text(subText, style: GoogleFonts.inter(color: isDark ? const Color(0xFF4CAF50) : Colors.grey, fontSize: 11.sp)),
        ],
      ),
    ),
  );
}

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)),
        SizedBox(height: 4.h),
        Text(value, style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTransactionTile(WithdrawalTransaction tx) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/icons/check.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFF4CAF50),
                BlendMode.srcIn,
              ),
              width: 20.sp,
              height: 20.sp,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\$${tx.amount}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                Text(tx.method, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(tx.date, style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.black87)),
              Text(tx.status, style: GoogleFonts.inter(color: const Color(0xFF4CAF50), fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}