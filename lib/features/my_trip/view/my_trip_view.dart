import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/my_trip/controller/my_trip_controller.dart';
import 'package:ride_sharing/features/my_trip/model/my_trip_model.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using context.watch to rebuild when the controller changes
    final controller = context.watch<MyTripsController>();

    return BaseScaffold(
      title: _buildHeaderTitle(),
      headerBackground: Opacity(
        opacity: 0.1,
        child: Image.asset(
          'assets/images/pattern_bg.png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("My Booking Trip"),
          _buildBookingTripCard(controller.bookingTrip, controller),
          SizedBox(height: 24.h),
          _sectionTitle("Active Trip"),
          _buildActiveTripCard(controller.activeTrip, controller),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  // --- Header Component ---
  Widget _buildHeaderTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back",
                style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
            Text("Safi",
                style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            _notificationBadge(),
            SizedBox(width: 15.w),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person_outline, color: Colors.white, size: 20.r),
            ),
          ],
        ),
      ],
    );
  }

  // --- Card Builders ---
  Widget _buildBookingTripCard(TripModel trip, MyTripsController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildCardHeader(trip.date, trip.isUpcoming),
          SizedBox(height: 16.h),
          _buildRouteInfo(trip.pickup, trip.dropoff),
          _divider(),
          _buildDriverRow(trip, isBooking: true),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => controller.cancelBooking(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFFEAEA)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: const Text("Cancel Booking", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 8.h),
          Text("Free cancellation up to 24 hours before departure",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
        ],
      ),
    );
  }

  Widget _buildActiveTripCard(TripModel trip, MyTripsController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildRouteInfo(trip.pickup, trip.dropoff)),
              _priceColumn(trip.price),
            ],
          ),
          SizedBox(height: 12.h),
          _buildTimeInfo(trip.date, trip.time),
          _divider(),
          Row(
            children: [
              _driverAvatar(trip.initial),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.driverName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    Text(trip.durationOrCar, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.trackTrip(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
                child: const Text("Track"),
              )
            ],
          ),
        ],
      ),
    );
  }

  // --- Reusable Small Widgets ---
  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      );

  Widget _divider() => Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Divider(height: 1, color: Colors.grey.shade200),
      );

  Widget _sectionTitle(String title) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
      );

  Widget _driverAvatar(String initial) => Container(
        width: 40.r, height: 40.r,
        decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10.r)),
        child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      );

  Widget _buildRouteInfo(String p, String d) => Column(
        children: [
          _routeRow(Icons.circle, Colors.grey.shade400, p),
          Padding(
            padding: EdgeInsets.only(left: 5.5.w),
            child: Align(alignment: Alignment.centerLeft, child: Container(width: 1, height: 15.h, color: Colors.grey.shade300)),
          ),
          _routeRow(Icons.circle, Colors.black, d),
        ],
      );

  Widget _routeRow(IconData icon, Color color, String loc) => Row(
        children: [
          Icon(icon, size: 12.r, color: color),
          SizedBox(width: 12.w),
          Text(loc, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        ],
      );

  Widget _notificationBadge() => Stack(children: [
        Icon(Icons.notifications_none, color: Colors.white, size: 28.r),
        Positioned(right: 2, top: 2, child: Container(width: 8.r, height: 8.r, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
      ]);

  Widget _buildCardHeader(String date, bool isUpcoming) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(Icons.calendar_today_outlined, size: 16.r, color: Colors.grey),
            SizedBox(width: 8.w),
            Text(date, style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp)),
          ]),
          if (isUpcoming)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(20.r)),
              child: Text("Upcoming", style: TextStyle(color: const Color(0xFF1967D2), fontWeight: FontWeight.bold, fontSize: 12.sp)),
            )
        ],
      );

  Widget _buildDriverRow(TripModel trip, {required bool isBooking}) => Row(
        children: [
          _driverAvatar(trip.initial),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(trip.driverName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              Row(children: [Icon(Icons.star, size: 14.r, color: Colors.orange), Text(" ${trip.rating}", style: TextStyle(fontSize: 12.sp))]),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text("\$${trip.price}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
            Text(trip.durationOrCar, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          ])
        ],
      );

  Widget _priceColumn(String price) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("\$$price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp)),
          Text("per seat", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
        ],
      );

  Widget _buildTimeInfo(String date, String time) => Row(children: [
        Icon(Icons.calendar_today_outlined, size: 16.r, color: Colors.grey),
        SizedBox(width: 4.w),
        Text(date, style: TextStyle(fontSize: 13.sp)),
        SizedBox(width: 12.w),
        Icon(Icons.access_time, size: 16.r, color: Colors.grey),
        SizedBox(width: 4.w),
        Text(time, style: TextStyle(fontSize: 13.sp)),
      ]);
}