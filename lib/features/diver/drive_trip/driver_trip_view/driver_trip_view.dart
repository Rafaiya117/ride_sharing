import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/core/utils/bottom_nav.dart';
import 'package:ride_sharing/features/diver/drive_trip/driver_trip_controller/driver_trip_controller.dart';
import 'package:ride_sharing/features/diver/drive_trip/driver_trip_model/driver_trip_model.dart';

class DriverTripScreen extends StatelessWidget {
  const DriverTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverTripController>();

    return BaseScaffold(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Welcome back", style: GoogleFonts.inter(color: Colors.white70, fontSize: 14.sp)),
              Text("Safi", style: GoogleFonts.inter(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
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
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: controller.currentNavbarIndex,
        onTap: (index) => controller.setNavbarIndex(index), 
      ),
      // FIXED: FutureBuilder handles safe execution cleanly once on load
      child: FutureBuilder(
        future: context.read<DriverTripController>().fetchDriverTrips(),
        builder: (context, snapshot) {
          if (controller.isLoading && controller.postedRide == null && controller.activeTrip == null) {
            return const Center(child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator()));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle("My Posted Rides"),
              if (controller.postedRide != null) 
                _buildPostedRideCard(context, controller.postedRide!)
              else
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text("No posted rides available.", style: GoogleFonts.inter(color: Colors.grey)),
                ),                
              _buildTitle("Active Trip"),
              if (controller.activeTrip != null) 
                _buildActiveTripCard(context, controller.activeTrip!)
              else
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text("No active ongoing trips.", style: GoogleFonts.inter(color: Colors.grey)),
                ),
              SizedBox(height: 20.h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(title, style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold)),
    );
  }

  // --- Specific Card UI Components ---

 Widget _buildPostedRideCard(BuildContext context, PostedRideModel ride) { // Added context
  return GestureDetector(
    onTap: () => context.push('/drive_ridedetails_screen', extra: ride.id), // Change route name as needed
    child: Container(
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
              _buildBadge("Active", const Color(0xFFE8F5E9), Colors.green, 'assets/icons/check.svg'),
              Text("Posted ${ride.postedDate}", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
            ],
          ),
          SizedBox(height: 16.h),
          _buildLocationItem('assets/icons/pick_location.svg', "From", ride.from, Colors.green),
          _buildLine(),
          _buildLocationItem('assets/icons/drop_location.svg', "To", ride.to, Colors.red),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconText('assets/icons/calender.svg', ride.date),
              _iconText('assets/icons/clock.svg', ride.time),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconText('assets/icons/dollar.svg', "\$${ride.pricePerSeat}/seat"),
              _iconText('assets/icons/seats.svg', "${ride.seats} seats"),
            ],
          ),
          SizedBox(height: 16.h),
          // FIXED: Wrapped with an independent GestureDetector to prevent tap propagation to parent card routing profile
          GestureDetector(
            onTap: () {
              context.read<DriverTripController>().cancelRide(context, ride.id.toString());
            },
            child: _actionBtn("Cancel Ride", Colors.red, const Color(0xFFFFF1F0), 'assets/icons/cancel.svg'),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildActiveTripCard(BuildContext context, ActiveTripModel trip) { 
  return GestureDetector(
    onTap: () => context.push('/drive_ridedetails_screen', extra: trip.id), 
    child: Container(
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
              // Left Section: Date Info (Expanded to prevent crowding)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/calender.svg', 
                      height: 16.r, 
                      width: 16.r, 
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        trip.date, 
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13.sp), // Slightly adjusted size for safety
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 4.w), // Compact safe spacer gap
              
              // FIXED: Wrap the right action block in a Flexible container to prevent horizontal overflow pushes
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Wrap badge inside a Flexible to compress nicely if screen is ultra-small
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _buildBadge("Active", const Color(0xFFE3F2FD), Colors.blue, 'assets/icons/check.svg'),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _trackBtn(context, trip.id.toString()),
                    ),
                  ],
                ),
              ),
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
                child: Center(child: Text(trip.initials, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.passengerName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    Row(children: [
                      SvgPicture.asset('assets/icons/star.svg', width: 14.r, height: 14.r, colorFilter: const ColorFilter.mode(Colors.amber, BlendMode.srcIn)),
                      Text(" ${trip.rating}", style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey)),
                    ]),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${trip.price}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  Text(trip.duration, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}
  // --- Helper Widgets ---

  Widget _buildBadge(String t, Color b, Color tc, String? i) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(color: b, borderRadius: BorderRadius.circular(20.r)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (i != null) SvgPicture.asset(i, height: 14.h, width: 14.w, colorFilter: ColorFilter.mode(tc, BlendMode.srcIn)),
      if (i != null) SizedBox(width: 4.w),
      Text(t, style: GoogleFonts.inter(color: tc, fontSize: 12.sp, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _buildLocationItem(String s, String l, String v, Color c) => Row(children: [
    SvgPicture.asset(s, width: 20.r, height: 20.r, colorFilter: ColorFilter.mode(c, BlendMode.srcIn)),
    SizedBox(width: 12.w),
    // FIXED: Enclosed inside Expanded to force texts to truncate if they breach device bounds
    Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
        Text(
          v, 
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // Safe fallback "..." truncator
        ),
      ]),
    )
  ]);

  Widget _buildLine() => Padding(
    padding: EdgeInsets.only(left: 10.w),
    child: Align(alignment: Alignment.centerLeft, child: Container(width: 1, height: 15.h, color: Colors.grey.shade200)),
  );

  Widget _iconText(String i, String t) => Row(children: [
    SvgPicture.asset(i, width: 16.r, height: 16.r, colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
    SizedBox(width: 8.w),
    Text(t, style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 13.sp)),
  ]);

  Widget _actionBtn(String l, Color tc, Color bc, String i) => Container(
    width: double.infinity, padding: EdgeInsets.symmetric(vertical: 12.h),
    decoration: BoxDecoration(color: bc, borderRadius: BorderRadius.circular(12.r)),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SvgPicture.asset(i, width: 18.r, height: 18.r, colorFilter: ColorFilter.mode(tc, BlendMode.srcIn)),
      SizedBox(width: 8.w),
      Text(l, style: GoogleFonts.inter(color: tc, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _simpleTimeline(String s, String e) => Column(children: [
    // FIXED: Wrapped the trailing texts inside Expanded containers to prevent right-edge clipping overflows
    Row(children: [
      Icon(Icons.circle, size: 10.r, color: Colors.grey), 
      SizedBox(width: 12.w), 
      Expanded(
        child: Text(
          s,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]),
    _buildLine(),
    Row(children: [
      Icon(Icons.circle, size: 10.r, color: Colors.black), 
      SizedBox(width: 12.w), 
      Expanded(
        child: Text(
          e,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]),
  ]);

  Widget _trackBtn(BuildContext context, String rideId) => GestureDetector(
    onTap: () => context.push('/drive_trackride_screen', extra: rideId), // FIXED: Passed rideId via GoRouter extra payload parameter
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), 
        borderRadius: BorderRadius.circular(10.r)
      ),
      child: Text("Track", style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w500)),
    ),
  );
}