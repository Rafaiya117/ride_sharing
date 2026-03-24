import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
        borderRadius: BorderRadius.circular(20.r), // Standard corner radius
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
        children: [
          // 1. --- Pickup/Dropoff Timeline ---
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    SvgPicture.asset('assets/icons/pickup_marker.svg', width: 20.w, colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
                    const Expanded(child: VerticalDivider(color: Colors.grey, thickness: 1.5, indent: 4, endIndent: 4)),
                    SvgPicture.asset('assets/icons/dropoff_marker.svg', width: 20.w, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
                  ],
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.pickup,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        trip.dropoff,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${trip.pricePerSeat.toStringAsFixed(0)}", // pricePerSeat is dynamic double
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "per seat",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
          SizedBox(height: 15.h),

          // 2. --- Date & Time ---
          Row(
            children: [
              SvgPicture.asset('assets/icons/calendar.svg', width: 16.w, colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
              SizedBox(width: 8.w),
              Text(trip.date, style: TextStyle(fontSize: 14.sp)),
              SizedBox(width: 25.w),
              SvgPicture.asset('assets/icons/clock.svg', width: 16.w, colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
              SizedBox(width: 8.w),
              Text(trip.time, style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 20.h),
          const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
          SizedBox(height: 15.h),

          // 3. --- Driver info ---
          Row(
            children: [
              // Assuming SVG Avatar, use NetworkImage for dynamic avatars normally
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.black12,
                child: Text(trip.driverName.substring(0, 1), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // Simple Initial
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.driverName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2.h),
                    Text(trip.carModel, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                  ],
                ),
              ),
              // TRACK BUTTON (Matches design)
              SizedBox(
                height: 35.h,
                child: OutlinedButton(
                  onPressed: onTrackPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text("Track", style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}