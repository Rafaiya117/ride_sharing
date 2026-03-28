import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_sharing/features/ride_details/ride_details_model/ride_details_model.dart';

class RideTopCard extends StatelessWidget {
  final RideDetailsModel ride;
  const RideTopCard({
    super.key,
    required this.ride,
  });

  @override
  Widget build(BuildContext context) {
    // Colors matching Container (7).png
    const headerTextColor = Colors.white;
    final subTextColor = Colors.white.withOpacity(0.8);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // Exact blue-to-dark gradient from your image
        gradient: const LinearGradient(
          colors: [Color(0xFF1E4C9A), Color(0xFF0D1B2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // 1. --- Price and Date Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Price", 
                      style: GoogleFonts.inter(fontSize: 14.sp, color: subTextColor)),
                    Text(
                      "\$${ride.totalPrice.toStringAsFixed(0)}", 
                      style: GoogleFonts.inter(fontSize: 36.sp, fontWeight: FontWeight.bold, color: headerTextColor),
                    ),
                    Text("per seat", 
                      style: GoogleFonts.inter(fontSize: 14.sp, color: subTextColor)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(ride.date, 
                      style: GoogleFonts.inter(fontSize: 14.sp, color: subTextColor)),
                    SizedBox(height: 4.h),
                    Text(
                      ride.time, 
                      style: GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.bold, color: headerTextColor),
                    ),
                  ],
                ),
              ],
            ),
            
            // 2. --- Horizontal Divider ---
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Divider(thickness: 1, color: Colors.white.withOpacity(0.2)),
            ),

            // 3. --- Ride Statistics ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(Icons.access_time, ride.duration, headerTextColor),
                _buildStatItem(Icons.location_on_outlined, ride.distance, headerTextColor),
                _buildStatItem(Icons.people_outline, "${ride.totalSeats} seats", headerTextColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Consistent stat layout using standard Icons for better visual alignment with the image
  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: color),
        SizedBox(width: 8.w),
        Text(
          text, 
          style: GoogleFonts.inter(fontSize: 14.sp, color: color, fontWeight: FontWeight.w500)
        ),
      ],
    );
  }
}