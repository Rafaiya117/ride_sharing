import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final controller = context.watch<TrackRideController>();
    const iconColor = Colors.white;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startRideTimeout(context);
    });

    return BaseScaffold(
      title: "Track Ride",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.navigateBack(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/share.svg',
            width: 24.w,
            colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
            onPressed: () => controller.shareTripWithFamily(context),
          ),
        ],
        child: Container(
          color: const Color(0xFFF2F2F2), 
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
            // 1. Map Background
            Positioned.fill(
              child: Image.asset(
                'assets/images/map_placeholder.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            
            // 2. Floating Status Card
            Positioned(
              top: 20.h, left: 20.w, right: 20.w,
              child: const FloatingStatusCard(),
            ),

            // 3. New York Marker (Example position)
            Positioned(
              top: 150.h, left: 100.w,
              child: FloatingMapMarker(isPickup: true, locationName: controller.pickup),
            ),

            // 4. Emergency SOS Button (Floating above sheet)
            Positioned(
              bottom: 300.h, 
              left: MediaQuery.of(context).size.width * 0.22,
              right: MediaQuery.of(context).size.width * 0.22,
              child: SizedBox(
                height: 55.h,
                child: ElevatedButton(
                  onPressed: () => controller.triggerEmergencySOS(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B30),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        "Emergency SOS",
                        style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            // 5. Flat White Bottom Sheet
            const Positioned(
              bottom: 0, left: 0, right: 0,
              child: TripDetailsSheet(),
            ),
          ],
        ),
      ),
    );
  }
}