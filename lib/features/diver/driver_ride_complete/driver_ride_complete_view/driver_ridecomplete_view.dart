import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_ride_complete/driver_ride_conmplete_controller/driver_ridecomplete_controller.dart';

class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RideCompletedController>();

    return BaseScaffold(
      title: "Ride Completed!",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 30.h),
            
            // 1. Success Icon
            Center(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFE9F7EF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: const Color(0xFF27AE60),
                  size: 48.sp,
                ),
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // 2. Completion Text
            Text(
              "Ride Completed!",
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              "Great job! You've successfully completed\nthis trip",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),

            SizedBox(height: 30.h),

            // 3. Passenger & Location Card
            _buildTripSummaryCard(controller),

            SizedBox(height: 20.h),

            // 4. Earnings Gradient Card
            _buildEarningsCard(controller.earningsAmount),

            const Spacer(),

            // 5. Continue Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => controller.onContinue(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8.w),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard(RideCompletedController controller) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Passenger Info
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: const Color(0xFF1A1A1A),
                child: Text(controller.initials, style: const TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.passengerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.sp),
                      Text(" ${controller.rating} rating", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                    ],
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: Colors.grey[300]),
          ),
          // Route Details
          _buildLocationRow(Icons.location_on_outlined, const Color(0xFF27AE60), "From", controller.fromLocation),
          SizedBox(height: 12.h),
          _buildLocationRow(Icons.location_on, const Color(0xFFEB5757), "To", controller.toLocation),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, Color color, String label, String city) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20.sp),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey, fontSize: 10.sp)),
            Text(city, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsCard(int amount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 18),
              SizedBox(width: 8.w),
              Text("Earnings", style: TextStyle(color: Colors.white, fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "\$$amount",
            style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            "Added to your balance",
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}