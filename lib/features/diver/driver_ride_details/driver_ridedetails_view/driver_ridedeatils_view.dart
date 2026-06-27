import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_ride_details/driver_ridedetails_controller/driver_ridedetails_controller.dart';
import 'package:ride_sharing/features/diver/driver_ride_details/driver_ridedetails_model/driver_ridedetails_model.dart';

class DriverRideDetailsScreen extends StatelessWidget {
  final String rideId;

  const DriverRideDetailsScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverRideDetailsController>();

    if (!controller.isLoading && controller.ride == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DriverRideDetailsController>().fetchRideDetails(rideId);
      });
    }

    return BaseScaffold(
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ), 
          Expanded(
            child: Text(
              "Ride Details",
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
          onPressed: controller.shareRide,
        ),
      ],

      child: controller.isLoading && controller.ride == null
        ? const Center(child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator()))
        : () {
          final data = controller.ride;
            if (data == null) {
              return const Center(child: Text("Failed to retrieve ride profile info."));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(data),
                  SizedBox(height: 20.h),

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

                  _buildWhiteCard(
                    title: "Passenger",
                    chatSvgPath: 'assets/icons/chat_outline.svg',
                    callSvgPath: 'assets/icons/phone_outline.svg',
                    onChatTap: () {
                      context.read<DriverRideDetailsController>().navigateToChat(
                        context,
                        targetUserId: data.passengerId,
                        targetRideId: int.tryParse(rideId),
                      );
                    },
                    onCallTap: () => controller.callPassenger(),
                    child: Row(
                      children: [
                        Container(
                          width: 60.r,
                          height: 60.r,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Center(
                            child: Text(
                              data.passengerInitial,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 28.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.passengerName,
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  _buildBadge(
                                    data.rating.toString(),
                                  Colors.black,
                                  Colors.white,
                                  'assets/icons/star_filled_white.svg',
                                ),
                              SizedBox(width: 12.w),
                              Text(
                                "• ${data.totalTrips} trips",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
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
              if (data.status == "active" && !controller.isLocalStarted) ...[
                (() {
                  debugPrint(
                    '!------ Rendering Start Ride Button for Ride ID: $rideId | Current Status: ${data.status}',
                  );
                  return const SizedBox.shrink();
                    }()),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading
                          ? null : () {
                          if (controller.ride != null) {
                            controller.startRide(context, rideId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      child: controller.isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          "Start Ride",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                SizedBox(height: 20.h),
              ],
            );
          }(),
        );
      }

  // --- UI Component Builders ---

  Widget _buildSummaryCard(DriverRideDetailsModel data) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E4597), Color(0xFF0C1C3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Price",
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    "\$${data.totalPrice}",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "per seat",
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.date,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    data.time,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Divider(color: Colors.white24, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _whiteIconText(Icons.access_time, data.duration),
              _whiteIconText(Icons.location_on_outlined, data.distance),
              _whiteIconText(Icons.people_outline, "${data.seats} seats"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteCard({
    required String title,
    required Widget child,
    String? chatSvgPath, // Changed to optional
    String? callSvgPath, // Changed to optional
    VoidCallback? onChatTap, // FIXED: Added named parameter
    VoidCallback? onCallTap, // FIXED: Added named parameter
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Only show the row if at least one path is provided
              if (chatSvgPath != null || callSvgPath != null)
                Row(
                  children: [
                    // FIXED: Passed onChatTap callback parameter here
                    if (chatSvgPath != null)
                      _buildActionButton(chatSvgPath, 20.r, onChatTap ?? () {}),
                    if (chatSvgPath != null && callSvgPath != null)
                      SizedBox(width: 8.w),
                    // FIXED: Passed onCallTap callback parameter here
                    if (callSvgPath != null)
                      _buildActionButton(callSvgPath, 20.r, onCallTap ?? () {}),
                  ],
                ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  // Helper to keep code clean and use SVG
  Widget _buildActionButton(String svgPath, double size, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: size,
            height: size,
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ), // Black outlines
          ),
        ),
      ),
    );
  }

  Widget _buildRoutePoint(
    IconData icon,
    Color color,
    String label,
    String location,
    String time,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14.r, color: color),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp),
              ),
              Text(
                location,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteConnector() {
    return Container(
      margin: EdgeInsets.only(left: 6.5.w, top: 2.h, bottom: 2.h),
      width: 1,
      height: 30.h,
      color: Colors.grey.shade200,
    );
  }

  // Widget _buildPassengerAvatar(String initial) {
  //   return Container(
  //     width: 45.r, height: 45.r,
  //     decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12.r)),
  //     child: Center(child: Text(initial, style:GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))),
  //   );
  // }

  // Widget _buildRoundAction(IconData icon, VoidCallback onTap) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Container(
  //       padding: EdgeInsets.all(10.r),
  //       decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
  //       child: Icon(icon, size: 20.r, color: Colors.black87),
  //     ),
  //   );
  // }

  Widget _buildSupportTile(
    IconData icon,
    Color color,
    String title,
    String sub,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 20.r),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                sub,
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _whiteIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16.r),
        SizedBox(width: 5.w),
        Text(
          text,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildBadge(
    String label,
    Color bgColor,
    Color textColor,
    String starIconPath,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 10.r),
          Text(
            " $label",
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
