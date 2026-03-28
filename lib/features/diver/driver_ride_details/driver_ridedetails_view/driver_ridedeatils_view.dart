import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_ride_details/driver_ridedetails_controller/driver_ridedetails_controller.dart';
import 'package:ride_sharing/features/diver/driver_ride_details/driver_ridedetails_model/driver_ridedetails_model.dart';

class DriverRideDetailsScreen extends StatelessWidget {
  const DriverRideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverRideDetailsController>();
    final data = controller.ride;

    return BaseScaffold(
      title: "Ride Details",
      isCurved: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: controller.shareRide,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Blue Summary Card
          _buildSummaryCard(data),
          SizedBox(height: 20.h),

          // 2. Journey Route Section
          _buildWhiteCard(
            title: "Journey Route",
            child: Column(
              children: [
                _buildRoutePoint(Icons.circle, Colors.grey, "Pickup", data.pickupLocation, data.pickupTime),
                _buildRouteConnector(),
                _buildRoutePoint(Icons.circle, Colors.black, "Drop-off", data.dropoffLocation, data.estArrival),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // 3. Passenger Card with Chat/Call
          _buildWhiteCard(
            title: "Passenger",
            child: Row(
              children: [
                _buildPassengerAvatar(data.passengerInitial),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.passengerName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      Row(children: [
                        _buildBadge(Icons.star, "${data.rating}"),
                        SizedBox(width: 8.w),
                        Text("• ${data.totalTrips} trips", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                      ]),
                    ],
                  ),
                ),
                _buildRoundAction(Icons.chat_bubble_outline, controller.messagePassenger),
                SizedBox(width: 10.w),
                _buildRoundAction(Icons.phone_outlined, controller.callPassenger),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // 4. Safety & Support
          _buildWhiteCard(
            title: "Safety & Support",
            child: Column(
              children: [
                _buildSupportTile(Icons.shield_outlined, Colors.green, "Live Trip Tracking", "Share location with family & friends"),
                Divider(height: 24.h, indent: 45.w),
                _buildSupportTile(Icons.phone_in_talk_outlined, Colors.red, "Emergency Support", "24/7 assistance & emergency contacts"),
              ],
            ),
          ),
          
          SizedBox(height: 30.h),
          
          // 5. Start Ride Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.startRide(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text("Start Ride", style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // --- UI Component Builders ---

  Widget _buildSummaryCard(DriverRideDetailsModel data) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E4597), Color(0xFF0C1C3E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Total Price", style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.sp)),
                Text("\$${data.totalPrice}", style: GoogleFonts.inter(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold)),
                Text("per seat", style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.sp)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(data.date, style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp)),
                Text(data.time, style: GoogleFonts.inter(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 15.h), child: Divider(color: Colors.white24, height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _whiteIconText(Icons.access_time, data.duration),
              _whiteIconText(Icons.location_on_outlined, data.distance),
              _whiteIconText(Icons.people_outline, "${data.seats} seats"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWhiteCard({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildRoutePoint(IconData icon, Color color, String label, String location, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14.r, color: color),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
            Text(location, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15.sp)),
            Text(time, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
          ]),
        )
      ],
    );
  }

  Widget _buildRouteConnector() {
    return Container(
      margin: EdgeInsets.only(left: 6.5.w, top: 2.h, bottom: 2.h),
      width: 1, height: 30.h,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildPassengerAvatar(String initial) {
    return Container(
      width: 45.r, height: 45.r,
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12.r)),
      child: Center(child: Text(initial, style:GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildRoundAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
        child: Icon(icon, size: 20.r, color: Colors.black87),
      ),
    );
  }

  Widget _buildSupportTile(IconData icon, Color color, String title, String sub) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
          child: Icon(icon, color: color, size: 20.r),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            Text(sub, style: GoogleFonts.inter(color: Colors.grey, fontSize: 11.sp)),
          ]),
        )
      ],
    );
  }

  Widget _whiteIconText(IconData icon, String text) {
    return Row(children: [
      Icon(icon, color: Colors.white70, size: 16.r),
      SizedBox(width: 5.w),
      Text(text, style: GoogleFonts.inter(color: Colors.white, fontSize: 12.sp)),
    ]);
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12.r)),
      child: Row(children: [
        Icon(icon, color: Colors.amber, size: 10.r),
        Text(" $label", style: GoogleFonts.inter(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}