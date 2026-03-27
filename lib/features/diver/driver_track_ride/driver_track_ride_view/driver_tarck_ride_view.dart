import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      title: "Track Ride",
      isCurved: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: controller.shareTrip,
        ),
      ],
      child: Container(
        height: 1.sh - 100.h, // Adjust based on BaseScaffold header height
        child: Stack(
          children: [
            // 1. Map Background
            Positioned.fill(
              child: Image.asset('assets/images/map_bg.png', fit: BoxFit.cover),
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
              bottom: 240.h, left: 60.w, right: 60.w,
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
                Text("Estimated Arrival", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
              ]),
              Text(trip.estimatedArrival, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
            ],
          ),
          SizedBox(height: 12.h),
          LinearProgressIndicator(
            value: trip.progress,
            backgroundColor: Colors.grey.shade200,
            color: Colors.black,
            minHeight: 4.h,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trip.pickup, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
              Text("${(trip.progress * 100).toInt()}%", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
              Text(trip.destination, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
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
      child: Text(status, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSOSButton(VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20.r),
      label: Text("Emergency SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      ),
    );
  }

  Widget _buildDetailsSheet(DriverTrackModel trip, DriverTrackController controller,BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.r, backgroundColor: const Color(0xFF131D33),
                child: Text(trip.initials, style: const TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(trip.passengerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  Text("${trip.carModel} • ${trip.carPlate}", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                ]),
              ),
              _roundIconBtn(Icons.phone_outlined, controller.callPassenger),
              SizedBox(width: 10.w),
              _roundIconBtn(Icons.chat_bubble_outline, controller.messagePassenger),
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
              child: const Text("End Ride", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundIconBtn(IconData i, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
      child: Icon(i, size: 20.r),
    ),
  );

  Widget _statItem(String l, String v) => Column(children: [
    Text(l, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
    Text(v, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
  ]);

  Widget _actionOutlineBtn(String l, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(Icons.share_outlined, size: 18.r, color: Colors.black),
      label: Text(l, style: const TextStyle(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );
}