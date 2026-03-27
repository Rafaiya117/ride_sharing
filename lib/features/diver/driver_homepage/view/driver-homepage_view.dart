import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_homepage/controller/driver_homepage_controller.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverHomeController>();

    return BaseScaffold(
      isCurved: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Welcome back", 
                style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
              Text(controller.driverName, 
                style: TextStyle(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              // Notification Icon with the red dot exactly as pictured
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 28.sp),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  )
                ],
              ),
              IconButton(
                icon: Icon(Icons.account_circle_outlined, color: Colors.white, size: 28.sp),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOnlineToggle(controller),
          SizedBox(height: 20.h), // Tightened spacing

          _buildStatsSection(controller),
          SizedBox(height: 20.h),

          _buildPostRideButton(context),
          SizedBox(height: 25.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ride Requests (2)", 
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE), 
                  borderRadius: BorderRadius.circular(10.r) // More rectangular radius
                ),
                child: Text("New", style: TextStyle(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 15.h),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.rideRequests.length,
            itemBuilder: (context, index) => _buildRequestCard(controller.rideRequests[index]),
          ),
        ],
      ),
    );
  }

  // --- Refined Helper Widgets for Exact Match ---

  Widget _buildOnlineToggle(DriverHomeController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F9F1), // Softer green
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(color: Color(0xFF00C853), shape: BoxShape.circle),
            child: Icon(Icons.near_me, color: Colors.white, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You are Online", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                Text("Accepting ride requests", style: TextStyle(color: Colors.black54, fontSize: 12.sp)),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8, // Smaller switch
            child: Switch(
              value: controller.isOnline,
              onChanged: (v) => controller.toggleOnlineStatus(v),
              activeColor: Colors.white,
              activeTrackColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(DriverHomeController controller) {
    return Row(
      children: [
        _buildStatBox("4.9", "Rating", Icons.star_outline),
        SizedBox(width: 10.w),
        _buildStatBox("156", "Trips", Icons.location_on_outlined),
        SizedBox(width: 10.w),
        // The darker blue gradient box
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2B5CB3), Color(0xFF0A1D3A)]
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 20.sp),
                    Text("\$2.0k", style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8.h),
                Text("This Month • Tap to view", style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.black54, size: 18.sp),
            SizedBox(height: 4.h),
            Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostRideButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text("Post New Ride", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(dynamic request) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: const Color(0xFF1A1A1A),
                child: Text(request.initial, style: const TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.passengerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    Text("★ ${request.rating} • ${request.pickupTimeAgo}", 
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${request.price.toInt()}", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
                  Text("${request.seats} seats", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                ],
              )
            ],
          ),
          _buildLocationTimeline(request.pickupLocation, request.dropoffLocation),
          Row(
            children: [
              Expanded(
                child: _buildBtn("Accept", Colors.black, Colors.white, Icons.check_circle_outline)
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildBtn("Decline", Colors.white, Colors.black, Icons.cancel_outlined, hasBorder: true)
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBtn(String label, Color bg, Color text, IconData icon, {bool hasBorder = false}) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: hasBorder ? Border.all(color: Colors.black12) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: text, size: 18.sp),
          SizedBox(width: 8.w),
          Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildLocationTimeline(String pickup, String dropoff) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.circle, size: 10.sp, color: Colors.grey.shade400),
            SizedBox(width: 12.w),
            Text(pickup, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500))
          ]),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 4.w),
              height: 15.h,
              width: 1,
              color: Colors.grey.shade300,
            ),
          ),
          Row(children: [
            Icon(Icons.circle, size: 10.sp, color: Colors.black),
            SizedBox(width: 12.w),
            Text(dropoff, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500))
          ]),
        ],
      ),
    );
  }
}