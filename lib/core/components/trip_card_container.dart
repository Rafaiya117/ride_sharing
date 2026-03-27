import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/features/trip_history/model/my_trip_history_model.dart';

class HistoryTripCard extends StatelessWidget {
  final TripHistoryModel trip;

  const HistoryTripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildCardHeader(),
          SizedBox(height: 16.h),
          _buildRouteInfo(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Divider(height: 1, color: Colors.grey.shade100),
          ),
          _buildDriverAndPriceRow(),
          SizedBox(height: 16.h),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // --- Helper Builders ---

  Widget _buildCardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16.r, color: Colors.grey),
            SizedBox(width: 8.w),
            Text(trip.date, style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp)),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7ED), // Very light green
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            "Completed",
            style: TextStyle(color: const Color(0xFF27AE60), fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
        )
      ],
    );
  }

  Widget _buildDriverAndPriceRow() {
    return Row(
      children: [
        Container(
          width: 45.r,
          height: 45.r,
          decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12.r)),
          child: Center(child: Text(trip.driverInitial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trip.driverName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black)),
              Row(
                children: [
                  Icon(Icons.star, size: 14.r, color: Colors.amber),
                  Text(" ${trip.formattedRating}", style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700)),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("\$${trip.price.toInt()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.black)),
            Text(trip.duration, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          ],
        )
      ],
    );
  }

  Widget _buildRouteInfo() {
    return Column(
      children: [
        _routeRow(Icons.circle, Colors.grey.shade400, trip.pickupLocation),
        Padding(
          padding: EdgeInsets.only(left: 11.5.w),
          child: Align(alignment: Alignment.centerLeft, child: Container(width: 1, height: 20.h, color: Colors.grey.shade200)),
        ),
        _routeRow(Icons.location_on_rounded, Colors.black, trip.dropoffLocation),
      ],
    );
  }

  Widget _routeRow(IconData icon, Color color, String location) {
    return Row(
      children: [
        Icon(icon, size: 14.r, color: color),
        SizedBox(width: 12.w),
        Text(location, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _outlinedButton("Rate Driver", Icons.star_border_rounded)),
        SizedBox(width: 12.w),
        Expanded(child: _outlinedButton("Receipt", Icons.receipt_long_outlined)),
      ],
    );
  }

  Widget _outlinedButton(String text, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18.r, color: Colors.black),
      label: Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }
}