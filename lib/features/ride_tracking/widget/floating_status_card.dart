import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/ride_tracking/ride_traking_controller/ride_tracking_controller.dart';

class FloatingStatusCard extends StatelessWidget {
  const FloatingStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrackRideController>();
    const iconColor = Colors.grey;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Row(
            children: [
              Icon(Icons.access_time_outlined, size: 20.r, color: iconColor), 
              SizedBox(width: 8.w),
              Text("Estimated Arrival", style: GoogleFonts.inter(fontSize: 14.sp, color: iconColor)),
              const Spacer(),
              Text(
                controller.estimatedArrival, // dynamic status per design
                style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // --- Linear Progress Bar matching design standard ---
          LinearProgressIndicator(
            value: controller.percentageComplete,
            color: Colors.black, // Dark grey progress color
            backgroundColor: const Color(0xFFF3F3F3), // Soft grey background
            minHeight: 8.h,
            borderRadius: BorderRadius.circular(5.r),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(controller.pickup, style: GoogleFonts.inter(fontSize: 12.sp, color: iconColor)),
              // Dynamic Percentage logic per design standard
              Text("${(controller.percentageComplete * 100).toStringAsFixed(0)}%", style: GoogleFonts.inter(fontSize: 12.sp, color: iconColor)),
              Text(controller.dropoff, style: GoogleFonts.inter(fontSize: 12.sp, color: iconColor)),
            ],
          ),
        ],
      ),
    );
  }
}