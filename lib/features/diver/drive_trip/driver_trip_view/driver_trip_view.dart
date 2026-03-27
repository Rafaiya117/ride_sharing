import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/drive_trip/driver_trip_controller/driver_trip_controller.dart';
import 'package:ride_sharing/features/diver/drive_trip/driver_trip_model/driver_trip_model.dart';

class DriverTripScreen extends StatelessWidget {
  const DriverTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverTripController>();

    return BaseScaffold(
      // --- Header exactly as shown ---
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
          _buildTitle("My Posted Rides"),
          if (controller.postedRide != null) _buildPostedRideCard(controller.postedRide!),
          
          _buildTitle("Active Trip"),
          if (controller.activeTrip != null) _buildActiveTripCard(controller.activeTrip!),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
    );
  }

  // --- Specific Card UI Components ---

  Widget _buildPostedRideCard(PostedRideModel ride) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge("Active", const Color(0xFFE8F5E9), Colors.green, Icons.check_circle_outline),
              Text("Posted ${ride.postedDate}", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
            ],
          ),
          SizedBox(height: 16.h),
          _buildLocationItem(Colors.green, "From", ride.from),
          _buildLine(),
          _buildLocationItem(Colors.red, "To", ride.to),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconText(Icons.calendar_today, ride.date),
              _iconText(Icons.access_time, ride.time),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconText(Icons.attach_money, "\$${ride.pricePerSeat}/seat"),
              _iconText(Icons.people_outline, "${ride.seats} seats"),
            ],
          ),
          SizedBox(height: 16.h),
          _actionBtn("Cancel Ride", Colors.red, const Color(0xFFFFF1F0), Icons.cancel_outlined),
        ],
      ),
    );
  }

  Widget _buildActiveTripCard(ActiveTripModel trip) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.calendar_today_outlined, size: 16.r, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(trip.date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              ]),
              Row(children: [
                _buildBadge("Active", const Color(0xFFE3F2FD), Colors.blue, null),
                SizedBox(width: 8.w),
                _trackBtn(),
              ]),
            ],
          ),
          SizedBox(height: 16.h),
          _simpleTimeline(trip.pickup, trip.destination),
          Divider(height: 32.h, color: Colors.grey.shade100),
          Row(
            children: [
              Container(
                width: 40.r, height: 40.r,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.r)),
                child: Center(child: Text(trip.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.passengerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    Row(children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.r),
                      Text(" ${trip.rating}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                    ]),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${trip.price}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  Text(trip.duration, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildBadge(String t, Color b, Color tc, IconData? i) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(color: b, borderRadius: BorderRadius.circular(20.r)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (i != null) Icon(i, size: 14.r, color: tc),
      if (i != null) SizedBox(width: 4.w),
      Text(t, style: TextStyle(color: tc, fontSize: 12.sp, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _buildLocationItem(Color c, String l, String v) => Row(children: [
    Icon(Icons.location_on_outlined, color: c, size: 20.r),
    SizedBox(width: 12.w),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
      Text(v, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
    ])
  ]);

  Widget _buildLine() => Padding(
    padding: EdgeInsets.only(left: 10.w),
    child: Align(alignment: Alignment.centerLeft, child: Container(width: 1, height: 15.h, color: Colors.grey.shade200)),
  );

  Widget _iconText(IconData i, String t) => Row(children: [
    Icon(i, size: 16.r, color: Colors.grey),
    SizedBox(width: 8.w),
    Text(t, style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp)),
  ]);

  Widget _actionBtn(String l, Color tc, Color bc, IconData i) => Container(
    width: double.infinity, padding: EdgeInsets.symmetric(vertical: 12.h),
    decoration: BoxDecoration(color: bc, borderRadius: BorderRadius.circular(12.r)),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(i, color: tc, size: 18.r), SizedBox(width: 8.w),
      Text(l, style: TextStyle(color: tc, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _simpleTimeline(String s, String e) => Column(children: [
    Row(children: [Icon(Icons.circle, size: 10.r, color: Colors.grey), SizedBox(width: 12.w), Text(s)]),
    _buildLine(),
    Row(children: [Icon(Icons.circle, size: 10.r, color: Colors.black), SizedBox(width: 12.w), Text(e)]),
  ]);

  Widget _trackBtn() => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10.r)),
    child: Text("Track", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
  );
}