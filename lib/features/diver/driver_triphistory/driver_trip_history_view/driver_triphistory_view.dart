import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_triphistory/driver_trip_history_model/driver_triphistory_model.dart';
import 'package:ride_sharing/features/diver/driver_triphistory/driver_triphistory_controller/driver_triphistory_controller.dart';

class DriverTripHistoryScreen extends StatelessWidget {
  const DriverTripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverTripHistoryController>();

    return BaseScaffold(
      // --- Header Content ---
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Welcome back", style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
              Text("Safi", style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Icon(Icons.notifications_none, color: Colors.white, size: 28.r),
                  Positioned(right: 4, top: 4, child: CircleAvatar(radius: 4.r, backgroundColor: Colors.red)),
                ],
              ),
              SizedBox(width: 12.w),
              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person_outline, color: Colors.white, size: 20.r),
              ),
            ],
          )
        ],
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              "${controller.trips.length} trips completed",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.trips.length,
            itemBuilder: (context, index) {
              return _buildTripCard(controller.trips[index]);
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildTripCard(DriverTripHistoryModel trip) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16.r, color: Colors.grey),
                  SizedBox(width: 6.w),
                  Text(trip.date, style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20.r)),
                child: Text("Completed", style: TextStyle(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          SizedBox(height: 12.h),
          _buildRouteTimeline(trip.pickupLocation, trip.dropoffLocation),
          Divider(height: 24.h, color: Colors.grey.shade100),
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.r)),
                child: Center(
                  // Dynamic Initial from Model
                  child: Text(trip.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.passengerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14.r),
                        Text(" ${trip.rating}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${trip.price.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  Text(trip.duration, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                ],
              )
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _buildActionButton("Rate Passenger", Icons.star_outline)),
              SizedBox(width: 12.w),
              Expanded(child: _buildActionButton("Receipt", Icons.receipt_long_outlined)),
            ],
          )
        ],
      ),
    );
  }

  // UI Helpers (Timeline and Buttons)
  Widget _buildRouteTimeline(String pickup, String dropoff) {
    return Column(
      children: [
        Row(children: [Icon(Icons.circle, size: 12.r, color: Colors.grey), SizedBox(width: 12.w), Text(pickup, style: TextStyle(fontSize: 14.sp))]),
        Padding(
          padding: EdgeInsets.only(left: 5.5.w),
          child: Align(alignment: Alignment.centerLeft, child: Container(width: 1, height: 10.h, color: Colors.grey.shade300)),
        ),
        Row(children: [Icon(Icons.circle, size: 12.r, color: Colors.black), SizedBox(width: 12.w), Text(dropoff, style: TextStyle(fontSize: 14.sp))]),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16.r),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}