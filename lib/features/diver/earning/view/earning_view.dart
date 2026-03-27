import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/earning/controller/earning_controller.dart';
import 'package:ride_sharing/features/diver/earning/model/earning_model.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EarningsController>();
    final earnings = controller.data;

    return BaseScaffold(
      title: "My Earnings",
      titleAlign: TextAlign.center,
      isCurved: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Weekly Overview Card
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E4597), Color(0xFF0C1C3E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Text("Total Earnings This Week", style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                SizedBox(height: 10.h),
                Text("\$${earnings.totalEarnings.toStringAsFixed(2)}", 
                  style: TextStyle(color: Colors.white, fontSize: 36.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.h),
                // Simple Custom Bar Chart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: earnings.weeklyData.map((val) => _buildBar(val)).toList(),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 25.h),

          // 2. Withdrawal Shortcut
          _buildActionCard(
            title: "Available Balance",
            value: "\$441.00",
            buttonText: "Withdraw Now",
            onTap: () => controller.navigateToWithdraw(context),
          ),

          SizedBox(height: 30.h),

          // 3. Trip History List
          Text("Recent Trips", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 15.h),
          ...earnings.trips.map((trip) => _buildTripTile(trip)).toList(),
        ],
      ),
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 30.w,
      height: height.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  Widget _buildActionCard({required String title, required String value, required String buttonText, required VoidCallback onTap}) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              Text(value, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text(buttonText, style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildTripTile(TripHistory trip) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trip.date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              Text(trip.time, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
            ],
          ),
          Text("+\$${trip.amount.toStringAsFixed(2)}", 
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16.sp)),
        ],
      ),
    );
  }
}