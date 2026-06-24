import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/core/utils/bottom_nav.dart';
import 'package:ride_sharing/features/diver/driver_homepage/controller/driver_homepage_controller.dart';
import 'package:ride_sharing/features/diver/post_new_ride/view/post_new_ride_modal.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverHomeController>();

    return BaseScaffold(
      isCurved: false,
      // 1. Title section now includes the Welcome text AND the Online Toggle
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome back", 
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 13.sp)),
                  Text(
                    controller.driverName, 
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 28.sp),
                        onPressed: () {
                          context.push('/notification');
                        },
                      ),
                      Positioned(
                        right: 12, top: 12,
                        child: Container(
                          width: 8.w, height: 8.w,
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        ),
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.account_circle_outlined, color: Colors.white, size: 28.sp),
                    onPressed: () {
                      context.push('/drive_profile_screen');
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _buildOnlineToggle(context, controller),
          SizedBox(height: 10.h), 
        ],
      ),
      // 2. Bottom Navigation Bar added
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: controller.currentNavbarIndex,
        onTap: (index) => controller.setNavbarIndex(index), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsSection(controller),
          SizedBox(height: 20.h),

          _buildPostRideButton(context),
          SizedBox(height: 25.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ride Requests (2)", 
                style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE), 
                  borderRadius: BorderRadius.circular(10.r) // More rectangular radius
                ),
                child: Text("New", style: GoogleFonts.inter(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.rideRequests.length,
            itemBuilder: (context, index) => _buildRequestCard(controller.rideRequests[index], index, controller),
          ),
        ],
      ),
    );
  }

  // --- Refined Helper Widgets for Exact Match ---

  Widget _buildOnlineToggle(BuildContext context, DriverHomeController controller) {
    // Dynamic color variations depending on online status properties
    final isOnline = controller.isOnline;
    final containerColor = isOnline ? const Color(0xFFE8F9F1) : const Color(0xFFF2F4F7);
    final iconBgColor = isOnline ? const Color(0xFF00C853) : Colors.grey.shade400;
    final statusTitle = isOnline ? "You are Online" : "You are Offline";
    final statusSubtitle = isOnline ? "Accepting ride requests" : "Go online to receive requests";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: containerColor, 
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconBgColor, 
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12.r)
            ),
            child: SvgPicture.asset(
              'assets/icons/near_me.svg', 
              width: 18.sp,
              height: 18.sp,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statusTitle, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                Text(statusSubtitle, style: GoogleFonts.inter(color: Colors.black54, fontSize: 12.sp)),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8, 
            child: controller.isToggleLoading
            ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
            )
            : Switch(
              value: isOnline,
              onChanged: (v) => controller.toggleOnlineStatus(context, v),
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.grey.shade200,
              inactiveTrackColor: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(DriverHomeController controller) {
    return Row(
      children: [
        _buildStatBox(controller.driverRating.toStringAsFixed(1), "Rating", 'assets/icons/rating.svg'),
        SizedBox(width: 10.w),
        _buildStatBox(controller.totalTrips.toString(), "Trips", 'assets/icons/map_pin.svg'),
        SizedBox(width: 10.w),
        // The darker blue gradient box
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2B5CB3),
                  Color(0xFF000000),
                ], // Darker bottom right for depth
              ),
              borderRadius: BorderRadius.circular(
                18.r,
              ), // Slightly more rounded as per image
            ),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center, 
              children: [
                Row(
                  mainAxisAlignment:MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/tips.svg',
                      width: 18.sp,
                      height: 18.sp,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w,), 
                    Text(
                      "\$ ${controller.monthlyEarnings.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize:32.sp, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h), 
                Text(
                  "This Month • Tap\nto view",
                  textAlign: TextAlign.center, // Centered text alignment
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9,), 
                    fontSize: 13.sp, 
                    height: 1.2, 
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String value, String label, String iconPath) { 
  return Expanded(
    child: Container(
        height: 108.h,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 18.sp,
              width: 18.sp,
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }

//   Widget _buildPostRideButton(BuildContext context) {
//   return InkWell( 
//     onTap: () {
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true, 
//         backgroundColor: Colors.transparent, 
//         builder: (context) => Padding(
//           // Adjusts modal for keyboard visibility
//           padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: PostRideView(),
//         ),
//       );
//     },
//     borderRadius: BorderRadius.circular(12.r),
//     child: Container(
//       width: double.infinity,
//       height: 50.h,
//       decoration: BoxDecoration(
//         color: const Color(0xFF121212),
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           )
//         ],
//       ),
//       child: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add, color: Colors.white, size: 20.sp),
//             SizedBox(width: 8.w),
//             Text("Post New Ride", 
//               style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     ),
//   );
// }

  Widget _buildPostRideButton(BuildContext context) {

  final driverController = Provider.of<DriverHomeController>(context);
  return InkWell( 
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, 
        backgroundColor: Colors.transparent, 
        builder: (context) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: driverController.isStripeComplete
          ? const PostRideView() : _buildStripeOnboardingPopup(context, driverController),
        ),
      );
    },
    borderRadius: BorderRadius.circular(12.r),
    child: Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text("Post New Ride", 
              style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ),
  );
}

Widget _buildStripeOnboardingPopup(BuildContext context, DriverHomeController controller) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    padding: EdgeInsets.all(24.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Setup Payout Options",
          style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 8.h),
        Text(
          "To post new active ride shares, connect your identity profile using Stripe's secure registration panel.",
          style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade600, height: 1.4),
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context), // Skip logic close action
                style: TextButton.styleFrom(minimumSize: Size(double.infinity, 50.h)),
                child: Text("Skip", style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 16.sp, fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isStripeLoading 
                ? null : () => controller.startStripeOnboarding(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF121212),
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: controller.isStripeLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text("Connect Stripe", style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
  Widget _buildRequestCard(dynamic request, int index, dynamic controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), 
            blurRadius: 15, 
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: const Color(0xFF1A1A1A),
                child: Text(request.initial, style: GoogleFonts.inter(color: Colors.white)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.passengerName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    Text("★ ${request.rating} • ${request.pickupTimeAgo}", 
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${request.price.toInt()}", 
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20.sp)),
                  Text("${request.seats} seats", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                ],
              )
            ],
          ),
          _buildLocationTimeline(request.pickupLocation, request.dropoffLocation),
          request.status == "pending"
          ? Row(
            children: [
              Expanded(
                child: GestureDetector(
                  // FIXED: Passes "accept" action string to the unified handler
                      onTap: () => controller.handleRideRequest(index, "accept"),
                      child: _buildBtn(
                        "Accept",
                        Colors.black,
                        Colors.white,
                        'assets/icons/accept_icon.svg',
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                        // FIXED: Passes "reject" action string to the unified handler
                    onTap: () => controller.handleRideRequest(index, "reject"),
                    child: _buildBtn(
                      "Decline",
                      Colors.white,
                      Colors.black,
                    'assets/icons/decline_icon.svg',
                    hasBorder: true,
                  ),
                ),
              ),
            ],
          )
          : Container(
            width: double.infinity,
            height: 45.h, // Matches height constraints of _buildBtn
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: request.status == "accepted" ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE), // Soft Red background tint
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: request.status == "accepted" ? Colors.green : Colors.red,
                width: 1.5,
              ),
            ),
            child: Text(
              request.status == "accepted" ? "Ride Accepted" : "Ride Declined",
              style: GoogleFonts.inter(
                color: request.status == "accepted" ? Colors.green[800] : Colors.red[800],
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn(String label, Color bg, Color text, String icon, {bool hasBorder = false}) {
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
          SvgPicture.asset(
            icon,
            width: 18.sp,
            height: 18.sp,
            colorFilter: ColorFilter.mode(text, BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
          Text(label, style: GoogleFonts.inter(color: text, fontWeight: FontWeight.bold, fontSize: 14.sp)),
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
            Text(pickup, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500))
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
            Text(dropoff, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500))
          ]),
        ],
      ),
    );
  }
}