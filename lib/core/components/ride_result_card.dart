import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_sharing/features/search/model/search_ride_model.dart';

class RideResultCard extends StatelessWidget {
  final RideResult ride;
  final VoidCallback onTap;

  const RideResultCard({
    super.key,
    required this.ride,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const iconColor = Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r), // Standard corner radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Subtle shadow from image
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. --- Header (Time, Date, Price) ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.departureTime,
                        style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ride.departureDate,
                        style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${ride.price.toStringAsFixed(0)}",
                      style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "per seat",
                      style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 2. --- Dynamic Timeline and Trip Details ---
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(15.r)),
              child: Column(
                children: [
                  // --- Dynamic Timeline ---
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        // Modular Timeline Column (similar to other trip cards)
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
                                ride.pickup,
                                style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Text(
                                ride.dropoff,
                                style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  SizedBox(height: 10.h),

                  // --- Ride Statistics ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Reusable Stat Item Builder
                      _buildStatItem('assets/icons/clock.svg', ride.duration),
                      _buildStatItem('assets/icons/distance.svg', ride.distance),
                      _buildStatItem('assets/icons/seats.svg', "${ride.seatsLeft} left", color: Colors.green), // dynamic color for urgency
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
            SizedBox(height: 10.h),

            // 3. --- Driver Footer ---
            Row(
              children: [
                // Assuming SVG Avatar, use NetworkImage for dynamic avatars normally
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.black12,
                  child: Text(ride.driverName.substring(0, 1), style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ride.driverName, style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2.h),
                      Text(ride.carModel, style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(10.r)),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16.r),
                      SizedBox(width: 4.w),
                      Text(ride.driverRating.toStringAsFixed(1), style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Simple Helper for consistent stat layout
  Widget _buildStatItem(String iconPath, String text, {Color? color}) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, width: 14.w, colorFilter: ColorFilter.mode(color ?? Colors.grey, BlendMode.srcIn)),
        SizedBox(width: 6.w),
        Text(text, style: GoogleFonts.inter(fontSize: 14.sp, color: color ?? Colors.black)),
      ],
    );
  }
}