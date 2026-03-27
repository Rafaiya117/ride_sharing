import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      title: "Withdraw",
      titleAlign: TextAlign.center,
      isCurved: true, // Matches the curved design in standard headers
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
                icon: Icons.account_balance_wallet_outlined,
              ),
              SizedBox(width: 15.w),
              _buildBalanceCard(
                title: "Pending",
                amount: "\$${dashboard.pendingBalance.toInt()}",
                subText: "Processing",
                isDark: false,
                icon: Icons.access_time,
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
          ...dashboard.transactions.map((tx) => _buildTransactionTile(tx)).toList(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)));
  }

  Widget _buildBalanceCard({required String title, required String amount, required String subText, required bool isDark, required IconData icon}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: isDark ? const Color(0xFF1E4597) : Colors.white,
          gradient: isDark ? const LinearGradient(colors: [Color(0xFF1E4597), Color(0xFF0C1C3E)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
          boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: isDark ? Colors.white70 : Colors.orange, size: 18.sp),
              SizedBox(width: 8.w),
              Text(title, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 13.sp)),
            ]),
            SizedBox(height: 12.h),
            Text(amount, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 32.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            Text(subText, style: TextStyle(color: isDark ? const Color(0xFF4CAF50) : Colors.grey, fontSize: 11.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
        SizedBox(height: 4.h),
        Text(value, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
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
            child: Icon(Icons.check, color: const Color(0xFF4CAF50), size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\$${tx.amount}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                Text(tx.method, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(tx.date, style: TextStyle(fontSize: 13.sp, color: Colors.black87)),
              Text(tx.status, style: TextStyle(color: const Color(0xFF4CAF50), fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}