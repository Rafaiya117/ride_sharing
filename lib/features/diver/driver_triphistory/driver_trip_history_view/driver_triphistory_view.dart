import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/core/utils/bottom_nav.dart';
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
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/user_icon.svg',
                  width: 28.r,
                  height: 28.r,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => context.push('/drive_profile_screen'),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: controller.currentNavbarIndex,
        onTap: (index) => controller.setNavbarIndex(index),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Text(
              "${controller.trips.length} trips completed",
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
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
                  Text(trip.date, style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20.r)),
                child: Text("Completed", style: GoogleFonts.inter(color: Color(0xFF008236), fontSize: 12.sp, fontWeight: FontWeight.bold)),
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
                  child: Text(trip.initials, style:GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.passengerName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/star_filled_black.svg',
                          width: 14.r,
                          height: 14.r,
                          // colorFilter: const ColorFilter.mode(
                          //   Colors.amber,
                          //   BlendMode.srcIn,
                          // ),
                        ),
                        Text(" ${trip.rating}", style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${trip.price.toStringAsFixed(0)}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  Text(trip.duration, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                ],
              )
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _buildActionButton("Rate Passenger",'assets/icons/star_outlined.svg')),
              SizedBox(width: 12.w),
              Expanded(child: _buildActionButton("Receipt", 'assets/icons/download2.svg')),
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
        Row(children: [Icon(Icons.circle, size: 12.r, color: Colors.grey), SizedBox(width: 12.w), Text(pickup, style: GoogleFonts.inter(fontSize: 14.sp))]),
        Padding(
          padding: EdgeInsets.only(left: 5.5.w),
          child: Align(alignment: Alignment.centerLeft, child: Container(width: 1, height: 12.h, color: Colors.grey.shade300)),
        ),
        Row(children: [Icon(Icons.circle, size: 12.r, color: Colors.black), SizedBox(width: 12.w), Text(dropoff, style: GoogleFonts.inter(fontSize: 14.sp))]),
      ],
    );
  }

  Widget _buildActionButton(String label, String icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 16.r,
            height: 16.r,
            // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 6.w),
          Text(label, style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}