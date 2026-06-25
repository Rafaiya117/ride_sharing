import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_sharing/features/home/model/home_model.dart';


class UpcomingTripCard extends StatelessWidget {
  final UpcomingTrip trip;
  final VoidCallback onTrackPressed;

  const UpcomingTripCard({
    super.key,
    required this.trip,
    required this.onTrackPressed,
  });

  @override
  Widget build(BuildContext context) {
    const iconColor = Colors.grey;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r), 
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. --- Header Section (Date/Time, Status Chip, Track Button) ---
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16.sp, color: Colors.black54),
              SizedBox(width: 6.w),
              Text(
                "${trip.date} ${trip.time}",
                style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Spacer(),
              // Active status chip indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 12.sp, color: Colors.blue),
                    SizedBox(width: 4.w),
                    Text(
                      "Active",
                      style: GoogleFonts.inter(color: Colors.blue, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (trip.status == "accepted" && trip.timelineStatus == "ongoing") ...[
                SizedBox(width: 8.w),
                SizedBox(
                  height: 32.h,
                  child: OutlinedButton(
                    onPressed: onTrackPressed,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                    child: Text("Track", style: GoogleFonts.inter(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),

          // 2. --- Vertical Pickup / Dropoff Timeline ---
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                    ),
                    const Expanded(
                      child: VerticalDivider(color: Colors.black12, thickness: 1.5, indent: 4, endIndent: 4),
                    ),
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                    ),
                  ],
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.pickup,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.black54),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        trip.dropoff,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          const Divider(thickness: 1, color: Color(0xFFF5F5F5)),
          SizedBox(height: 8.h),

          // 3. --- Footer Section (Driver Profile & Fare Pricing) ---
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.black,
                child: Text(
                  trip.driverName.isNotEmpty ? trip.driverName.substring(0, 1).toUpperCase() : 'P', 
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)
                ), 
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.driverName, 
                      style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87)
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text("5.0", style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${trip.pricePerSeat.toStringAsFixed(0)}", 
                    style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    "Ongoing",
                    style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}