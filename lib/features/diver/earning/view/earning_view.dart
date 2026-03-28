import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
      title: "Earnings",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(left: 180.w),
          child: SvgPicture.asset(
            'assets/icons/download.svg',
            width: 20.sp,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Weekly Overview Card
            Container(
              padding: EdgeInsets.all(24.r,), 
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF161D27),
                    Color(0xFF000000),
                  ], // Darker navy to black
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/tips.svg',
                        width: 16.sp,
                        height: 16.sp,
                        colorFilter: const ColorFilter.mode(
                          Colors.white70,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Total Earnings",
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "\$${earnings.totalEarnings.toInt()}",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 42.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Timeframe Selector Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimeButton("Week", isActive: false),
                      _buildTimeButton("Month", isActive: true),
                      _buildTimeButton("Year", isActive: false),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Bottom Metrics Row
                  Row(
                    children: [
                      _buildMetricBox("Avg per trip", "\$108"),
                      SizedBox(width: 15.w),
                      _buildMetricBox("Total trips", "5"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),
            // 2. Withdrawal Shortcut
            _buildEarningsActionSection(
              pendingValue: "\$98.00", 
              availableValue: "\$441.00",
              onWithdraw: () => controller.navigateToWithdraw(context),
            ),
            SizedBox(height: 30.h),
            // 3. Trip History List
            Text("Recent Trips", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 15.h),
            ...earnings.trips.map((trip) => _buildTripTile(trip)).toList(),
          ],
        ),
      ),
    );
  }

  // Widget _buildBar(double height) {
  //   return Container(
  //     width: 30.w,
  //     height: height.h,
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.3),
  //       borderRadius: BorderRadius.circular(4.r),
  //     ),
  //   );
  // }

  Widget _buildTimeButton(String label, {required bool isActive}) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFF1F2630), // White for active
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(label, 
          style: GoogleFonts.inter(
            color: isActive ? Colors.black : Colors.white, 
            fontWeight: FontWeight.w600,
            fontSize: 13.sp
          )),
      ),
    ),
  );
}

Widget _buildMetricBox(String label, String value) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2630), // Dark grey-blue boxes
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12.sp)),
          SizedBox(height: 8.h),
          Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

  Widget _buildEarningsActionSection({
  required String pendingValue,
  required String availableValue,
  required VoidCallback onWithdraw,
}) {
  return Column(
    children: [
      Row(
        children: [
          // Left Card: Pending
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/clock.svg', 
                        width: 14.sp, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
                      SizedBox(width: 6.w),
                      Text("Pending", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    pendingValue, 
                    style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Right Card: Available (Gradient)
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E4597), Color(0xFF0C1C3E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/wallet.svg', 
                        width: 14.sp, colorFilter: const ColorFilter.mode(Colors.white70, BlendMode.srcIn)),
                      SizedBox(width: 6.w),
                      Text("Available", style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.sp)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(availableValue, 
                    style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 15.h),
      // Full Width Withdraw Button
      SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: onWithdraw,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            elevation: 0,
          ),
          child: Text("Withdraw Earnings", 
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp)),
        ),
      ),
    ],
  );
}

  Widget _buildTripTile(TripHistory trip) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route text
                Text(
                  "${trip.pickup} → ${trip.dropoff}", 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp, color: const Color(0xFF1A1D21))
                ),
                SizedBox(height: 6.h),
                // Date with Calendar SVG
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/calendar.svg', 
                      width: 14.sp, 
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                    ),
                    SizedBox(width: 6.w),
                    Text(trip.date, style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Main Price
                Text(
                  "\$${trip.amount.toInt()}", 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20.sp, color: const Color(0xFF1A1D21))
                ),
                // Paid Status
                Text(
                  "Paid", 
                  style: GoogleFonts.inter(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.w600)
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 16.h),
        // Gray Summary Box
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: "Fare: ",
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp),
                  children: [
                    TextSpan(
                      text: "\$${trip.amount.toInt()}",
                      style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              // Unpaid Fee Label
              Text(
                "P-fee unpaid", 
                style: GoogleFonts.inter(color: Colors.red, fontSize: 13.sp, fontWeight: FontWeight.w500)
              ),
              // Passenger Count
              Text(
                "${trip.passengers} passenger(s)", 
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}