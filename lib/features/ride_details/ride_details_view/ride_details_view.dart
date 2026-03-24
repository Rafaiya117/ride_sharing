import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_info_card.dart';
import 'package:ride_sharing/core/components/ride_top_card.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/ride_details/ride_details_controller/ride_details_controller.dart';
import 'package:ride_sharing/features/ride_details/widget/driver_card.dart';


class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RideDetailsController>();
    
    return BaseScaffold(
      title: "Ride Details",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/share.svg', width: 24.w, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          onPressed: () => controller.shareRideDetails(context),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RideTopCard(ride: controller.ride),
          SizedBox(height: 20.h,),
          DriverCardModular(
            name: 'hhh', 
            rating: 'ghfhfh', 
            trips: 'ghfhg', 
            carModel: 'hfgh', 
            plateNumber: 'hgfhf',
          ),
          SizedBox(height: 20.h,),
          // 1. --- Driver Image Section ---
          _sectionTitle("Driver Image"),
          CustomInfoCard(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.asset('assets/images/driver_placeholder.png', fit: BoxFit.cover, height: 200.h),
            ),
          ),

          // 2. --- Vehicle Information ---
          _sectionTitle("Vehicle Information"),
          Row(
            children: [
              Expanded(child: _infoTile("Model", controller.ride.carModel)),
              SizedBox(width: 15.w),
              Expanded(child: _infoTile("Plate Number", controller.ride.carLicense)),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(child: _infoTile("Color", controller.ride.vehicleColor)),
              SizedBox(width: 15.w),
              Expanded(child: _infoTile("Total Seats", "${controller.ride.totalSeats} seats")),
            ],
          ),
          
          SizedBox(height: 100.h), // Space for bottom buttons
        ],
      ),
    );
  }

  // --- Helper Methods defined inside the class to fix your error ---

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF3F3F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}