import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JourneyRouteContainer extends StatelessWidget {
  final String pickupLocation;
  final String pickupTime;
  final String dropoffLocation;
  final String dropoffTime;

  const JourneyRouteContainer({
    super.key,
    required this.pickupLocation,
    required this.pickupTime,
    required this.dropoffLocation,
    required this.dropoffTime,
  });

  @override
  Widget build(BuildContext context) {
    const locationColor = Color(0xFF202020);
    const subtextColor = Color(0xFF757575);
    const timelineColor = Color(0xFFDCDCDC);
    const dropoffCircleColor = Color(0xFF101010);
    const pickupCircleColor = Color(0xFF9E9E9E);

    final titleStyle = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: locationColor,
    );

    final locationStyle = TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: locationColor,
    );

    final subtextStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: subtextColor,
    );

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Journey Route', style: titleStyle),
          SizedBox(height: 20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Timeline Column
              Column(
                children: [
                  // Pickup circle aligned with "Pickup" text
                  SizedBox(height: 4.h), 
                  Icon(Icons.circle, size: 16.sp, color: pickupCircleColor),
                  // Timeline line
                  Container(
                    width: 2.w,
                    height: 80.h, // Adjusted height to bridge the gap properly
                    color: timelineColor,
                  ),
                  // FIXED: Drop-off circle now aligned with "Drop-off" text
                  Icon(Icons.circle, size: 16.sp, color: dropoffCircleColor),
                ],
              ),
              SizedBox(width: 16.w),

              // 2. Text Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup',
                      style: subtextStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4.h),
                    Text(pickupLocation, style: locationStyle),
                    SizedBox(height: 4.h),
                    Text(pickupTime, style: subtextStyle),

                    SizedBox(height: 28.h), 

                    // Drop-off Block
                    Text(
                      'Drop-off',
                      style: subtextStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4.h),
                    Text(dropoffLocation, style: locationStyle),
                    SizedBox(height: 4.h),
                    Text(dropoffTime, style: subtextStyle),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}