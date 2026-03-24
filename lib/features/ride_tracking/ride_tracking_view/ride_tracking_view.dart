import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/floating_map_marker.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/ride_tracking/ride_traking_controller/ride_tracking_controller.dart';
import 'package:ride_sharing/features/ride_tracking/widget/floating_status_card.dart';
import 'package:ride_sharing/features/ride_tracking/widget/trip_details_widget.dart';

class TrackRideScreen extends StatelessWidget {
  const TrackRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller dynamically
    final controller = context.watch<TrackRideController>();
    const iconColor = Colors.white;

    return BaseScaffold(
      // --- CURVED BLACK HEADER ---
      title: "Track Ride",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.navigateBack(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/share.svg', width: 24.w, colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
          onPressed: () => controller.shareTripWithFamily(context),
        ),
      ],
      
      // --- BODY CONTENT ---
      // Body padding must be zero to allow map to be full width
      child: Stack(
        children: [
          // 1. --- Map Placeholder (Fixed at back) ---
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_placeholder.png', // Ensure asset exists, fits design standard
              fit: BoxFit.cover,
            ),
          ),
          // 2. --- Floating UI Elements ---
          Positioned(
            top: 20.h, left: 20.w, right: 20.w, 
            child: const FloatingStatusCard(),
          ),
          // --- Mocking Marker Positions dynamically ---
          Positioned(
            top: 150.h, left: 100.w, // Dynamic position
            child: FloatingMapMarker(isPickup: true, locationName: controller.pickup),
          ),
          Positioned(
            bottom: 250.h, right: 100.w, // Dynamic position
            child: FloatingMapMarker(isPickup: false, locationName: controller.dropoff),
          ),

          // C. Car Marker/Status bubble per image_11.png design standard
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45, 
            left: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/navigation.svg', width: 30.w, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)), // Assuming standard navigation arrow from design
                SizedBox(height: 5.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.r)),
                  child: Text(controller.currentStatusText, style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                ),
              ],
            ),
          ),

          // D. --- RED EMERGENCY SOS BUTTON per image_11.png design standard ---
          Positioned(
            bottom: 120.h, left: MediaQuery.of(context).size.width * 0.3, right: MediaQuery.of(context).size.width * 0.3, // centered above bottom sheet
            child: SizedBox(
              height: 50.h, // Standard primary button height from design
              child: ElevatedButton(
                onPressed: () => controller.triggerEmergencySOS(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B30), // VIBRANT RED SOS per image_11.png design standard
                  foregroundColor: Colors.white, // fits standard light readability
                  elevation: 5, // subtle shadow matches floating standard
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)), // pill shape per design
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/SOS.svg', width: 18.w, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)), // Solid SOS icon assumed
                    SizedBox(width: 8.w),
                    Text("Emergency SOS", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),

          // E. --- Standard Bottom Sheet per image_11.png design standard ---
          const Positioned(
            bottom: 0, left: 0, right: 0,
            child: TripDetailsSheet(),
          ),
        ],
      ),
    );
  }
}