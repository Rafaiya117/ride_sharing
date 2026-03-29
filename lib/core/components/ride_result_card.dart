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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.08), // Increased from 0.04
              blurRadius: 20, // Increased from 15
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Header: Time and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.departureTime,
                      style: GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xFF131D33)),
                    ),
                    Text(
                      ride.departureDate,
                      style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${ride.price.toStringAsFixed(0)}",
                      style: GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xFF131D33)),
                    ),
                    Text(
                      "per seat",
                      style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 2. Timeline Section (Grey Background)
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA), // Subtle grey from image
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Dot-Line-Dot logic
                    Column(
                      children: [
                        Container(width: 10.r, height: 10.r, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                        const Expanded(child: VerticalDivider(color: Colors.grey, thickness: 1, indent: 4, endIndent: 4)),
                        Container(width: 10.r, height: 10.r, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ride.pickup, style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text(ride.dropoff, style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // 3. Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('assets/icons/clock.svg', ride.duration),
                _buildStatItem('assets/icons/distance.svg', ride.distance),
                _buildStatItem('assets/icons/seats.svg', "${ride.seatsLeft} left", iconColor: Colors.grey),
              ],
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(color: Colors.grey.shade200, thickness: 1),
            ),

            // 4. Footer: Driver Info
            Row(
              children: [
                // Circular Avatar
                Container(
                  width: 44.r, height: 44.r,
                  decoration: const BoxDecoration(color: Color(0xFF131D33), shape: BoxShape.circle),
                  child: Center(
                    child: Text(ride.driverName.substring(0, 1), 
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ride.driverName, style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      Text(ride.carModel, style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                // Star Rating Badge (Black rounded pill)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(color: const Color(0xFF131D33), borderRadius: BorderRadius.circular(20.r)),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 16.r),
                      SizedBox(width: 4.w),
                      Text(ride.driverRating.toStringAsFixed(1), 
                        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
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

  Widget _buildStatItem(String iconPath, String text, {Color? iconColor}) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, width: 18.r, 
          colorFilter: ColorFilter.mode(iconColor ?? Colors.grey.shade700, BlendMode.srcIn)),
        SizedBox(width: 6.w),
        Text(text, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
      ],
    );
  }
}