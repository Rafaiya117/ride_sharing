import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/ride_tracking/ride_traking_controller/ride_tracking_controller.dart';

class TripDetailsSheet extends StatelessWidget {
  const TripDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrackRideController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Driver Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: const Color(0xFF0F172A), 
                child: Text(
                  controller.driver.driverInitials,
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.driver.name,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(height: 3.h),
                    Text(
                      "${controller.driver.carModel} • ${controller.driver.carPlate}",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              _buildCircularAction(Icons.phone_in_talk_outlined, () => controller.callDriver()),
              SizedBox(width: 10.w),
              _buildCircularAction(Icons.chat_bubble_outline, () => controller.openChatWithDriver(context)),
            ],
          ),
          
          SizedBox(height: 20.h),
          const Divider(thickness: 1, color: Color(0xFFF1F1F1)),
          SizedBox(height: 20.h),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Distance", "${controller.totalDistanceMiles.toStringAsFixed(0)} miles"),
              _buildStatItem("Duration", "${controller.totalDuration.inHours}h ${controller.totalDuration.inMinutes.remainder(60)}m"),
              _buildStatItem("Price", "\$${controller.price.toStringAsFixed(0)}"),
            ],
          ),          
          SizedBox(height: 25.h),
          // Action Button
          OutlinedButton(
            onPressed: () => controller.shareTripWithFamily(context),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 52.h),
              side: BorderSide(color: Colors.grey.shade200, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              backgroundColor: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share_outlined, color: Colors.black, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  "Share Trip with Family",
                  style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildCircularAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 22.sp),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade500)),
        SizedBox(height: 6.h),
        Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}