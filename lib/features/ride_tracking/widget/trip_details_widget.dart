import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/ride_tracking/ride_traking_controller/ride_tracking_controller.dart';

class TripDetailsSheet extends StatelessWidget {
  const TripDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrackRideController>();
    const iconColor = Colors.grey;

    return Container(
      padding: EdgeInsets.all(20.w), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10, 
            offset: const Offset(0, -4)
          ), // subtle shadow up
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Standard circular avatar with dynamic initials
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.black12,
                child: Text(
                  controller.driver.driverInitials, 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ), 
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.driver.name, 
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${controller.driver.carModel} • ${controller.driver.carPlate}", 
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Communication actions
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/call.svg', 
                  width: 24.w, 
                  colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)
                ),
                onPressed: () => controller.callDriver(),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/chat.svg', 
                  width: 24.w, 
                  colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)
                ),
                onPressed: () => controller.openChatWithDriver(context),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
          SizedBox(height: 15.h),
          // --- Dynamic Distance, Duration, Price Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Distance", "${controller.totalDistanceMiles.toStringAsFixed(0)} miles"),
              _buildStatItem("Duration", "${controller.totalDuration.inHours}h ${controller.totalDuration.inMinutes.remainder(60)}m"),
              _buildStatItem("Price", "\$${controller.price.toStringAsFixed(0)}"),
            ],
          ),
          SizedBox(height: 20.h),

          // Share Trip with Family Button
          OutlinedButton(
            onPressed: () => controller.shareTripWithFamily(context),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)), 
              backgroundColor: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/share.svg', 
                  width: 20.w, 
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)
                ),
                SizedBox(width: 10.w),
                Text(
                  "Share Trip with Family",
                  style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
        SizedBox(height: 4.h),
        Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}