import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_track_ride/driver_track_ride_controller/driver_track_ride_controller.dart';
import 'package:ride_sharing/features/diver/driver_track_ride/driver_track_ride_model/driver_track_ride_model.dart';

class DriverTrackScreen extends StatelessWidget {
  const DriverTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverTrackController>();
    final trip = controller.trip;

    return BaseScaffold(
      title: Row(
    children: [
      Expanded(
        child: Text(
          "Track Ride",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  ),
  titleAlign: TextAlign.center,
  isCurved: true,
  actions: [
    IconButton(
      icon: const Icon(Icons.share_outlined, color: Colors.white),
      onPressed: controller.shareTrip,
    ),
  ],
      child: SizedBox(
        height: 1.sh - 100.h, // Adjust based on BaseScaffold header height
        child: Stack(
          children: [
            // 1. Map Background
            Positioned.fill(
              child: Image.asset('assets/images/map_placeholder.png', fit: BoxFit.cover),
            ),

            // 2. Floating Arrival Card
            Positioned(
              top: 20.h, left: 20.w, right: 20.w,
              child: _buildArrivalCard(trip),
            ),

            // 3. Status Badge on Map
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   _buildStatusIndicator(trip.currentStatus),
                ],
              ),
            ),

            // 4. Emergency SOS Button
            Positioned(
              bottom: 280.h, left: 60.w, right: 60.w,
              child: _buildSOSButton(controller.triggerSOS),
            ),

            // 5. Bottom Details Sheet
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildDetailsSheet(trip, controller,context),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildArrivalCard(DriverTrackModel trip) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.access_time, size: 18.r, color: Colors.grey),
                SizedBox(width: 8.w),
                Text("Estimated Arrival", style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)),
              ]),
              Text(trip.estimatedArrival, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18.sp)),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: 0.63, // trip.progress
              backgroundColor: const Color(0xFFE0E0E0),
              color: Colors.black,
              minHeight: 5.h,
              // This property specifically rounds the "inner" black bar's head
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trip.pickup, style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey)),
              Text("${(trip.progress * 100).toInt()}%", style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey)),
              Text(trip.destination, style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20.r)),
      child: Text(status, style: GoogleFonts.inter(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSOSButton(VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20.r),
      label: Text("Emergency SOS", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      ),
    );
  }

  Widget _buildDetailsSheet(DriverTrackModel trip, DriverTrackController controller, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.all(12.w), // Slightly increased for better spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r, backgroundColor: const Color(0xFF131D33),
                  child: Text(trip.initials, style: GoogleFonts.inter(color: Colors.white)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(trip.passengerName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    Text("${trip.carModel} • ${trip.carPlate}", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                  ]),
                ),
                // Updated to use SVG paths
                _roundIconBtn('assets/icons/phone_outline.svg', controller.callPassenger),
                SizedBox(width: 10.w),
                _roundIconBtn('assets/icons/chat_outline.svg', controller.messagePassenger),
              ],
            ),
            Divider(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem("Distance", trip.distance),
                _statItem("Duration", trip.duration),
                _statItem("Price", "\$${trip.price}"),
              ],
            ),
            SizedBox(height: 20.h),
            _actionOutlineBtn("Share Trip with Family", controller.shareTrip),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.endRide(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text("End Ride", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Ensure your _roundIconBtn is updated to handle the SVG String
Widget _roundIconBtn(String svgPath, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        svgPath,
        width: 20.r,
        height: 20.r,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
    ),
  );

  Widget _statItem(String l, String v) => Column(children: [
    Text(l, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
    Text(v, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp)),
  ]);

  Widget _actionOutlineBtn(String l, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(Icons.share_outlined, size: 18.r, color: Colors.black),
      label: Text(l, style:GoogleFonts.inter(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );
}