import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/components/custom_text_field.dart';
import 'package:ride_sharing/core/components/upcoming_card.dart';
import 'package:ride_sharing/core/components/user_statcard.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/core/utils/bottom_nav.dart';
import 'package:ride_sharing/features/home/home_controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    return BaseScaffold(
      // --- CURVED BLACK HEADER ---
      title: Align(
        alignment: Alignment.centerLeft, // This pushes the actions to the right
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
            Text(
              "Safi",
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
      isCurved: false,
      actions: [
        // 1. Notification Stack
        Stack(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/notification_bell.svg',
                width: 24.w,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              onPressed: () => controller.openNotifications(context),
            ),
            Positioned(
              right: 12.w,
              top: 12.h,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        // 2. Profile Icon
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/user_icon.svg',
            width: 28.r,
            height: 28.r,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => controller.openProfile(context),
        ),
        SizedBox(width: 8.w),
      ],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: controller.currentNavbarIndex,
        onTap: (index) => controller.setNavbarIndex(index),
      ),
      // --- BODY CONTENT ---
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h), 
          // 1. --- User Stats Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserStatsCard(title: "Trips", value: "${controller.stats.trips}", iconPath: 'assets/icons/trips.svg'),
              UserStatsCard(title: "Rating", value: "${controller.stats.rating}", iconPath: 'assets/icons/rating.svg'),
              UserStatsCard(title: "Upcoming", value: "${controller.stats.upcoming}", iconPath: 'assets/icons/upcoming.svg'),
            ],
          ),
          SizedBox(height: 40.h),
          // 2. --- Plan Your Journey Section ---
          Container(
            decoration:BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200,width: 1.w),
            ) ,
            child: Padding(
              padding: EdgeInsets.all(20.0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Plan Your Journey",
                    style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
                  ),
                  SizedBox(height: 20.h),
                  
                  // Reusable input fields per image_3.png logic (rounded rect, prefix icon, hint)
                  _buildInputLabel("Pickup location"),
                  CustomTextField(
                    controller: controller.pickupController,
                    hintText: "Pickup location",
                    prefixIconPath: 'assets/icons/pickup_marker.svg',
                    showBorder: true,
                  ),
                  SizedBox(height: 15.h),
                  
                  _buildInputLabel("Drop-off location"),
                  CustomTextField(
                    controller: controller.dropoffController,
                    hintText: "Drop-off location",
                    prefixIconPath: 'assets/icons/dropoff_marker.svg',
                    showBorder: true,
                  ),
                  SizedBox(height: 15.h),
                  
                  // Date & Seats Row (Using slightly wider spacing for design)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Keeps label aligned
                          children: [
                            _buildInputLabel("Date"),
                            GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  // Update your controller or state here
                                  //controller.dateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
                                }
                              },
                              child: AbsorbPointer(
                                // Prevents the keyboard from popping up
                                child: CustomTextField(
                                  controller: TextEditingController(text: ""),
                                  hintText: "mm/dd/yyyy",
                                  prefixIconPath: 'assets/icons/calendar.svg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          children: [
                            _buildInputLabel("Seat"),
                            CustomTextField(
                              controller: TextEditingController(text: "1 Seat"), // Temporary controller for design, normally uses dynamic seat state
                              hintText: "1 Seat",
                              prefixIconPath: 'assets/icons/seats.svg',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  // Search Rides Button (Reusable primary button from image_3.png reference)
                  CustomButton(
                    text: "Search Rides",
                    onTap: () => controller.searchRides(context),
                    iconPath: 'assets/icons/search.svg', // Optional search icon for visual enhancement
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h),

          // 3. --- Upcoming Trips Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming Trips",
                style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
              ),
              GestureDetector(
                onTap: () {}, // View All Logic
                child: Text(
                  "View all",
                  style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Dynamic Upcoming Trip Card per MVC logic
          UpcomingTripCard(
            trip: controller.nextTrip,
            onTrackPressed: () => controller.trackTrip(context, controller.nextTrip),
          ),
          SizedBox(height: 25.h),
          // 4. --- Family Share Button ---
          OutlinedButton(
            onPressed: () => controller.shareTripWithFamily(context),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5), // Standard outline weight
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)), // Standard corner radius
              backgroundColor: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/share.svg', width: 20.w, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)), // Solid share icon assumed
                SizedBox(width: 10.w),
                Text(
                  "Share Trip with Family",
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h), // Bottom spacing
        ],
      ),
    );
  }

  // Simple Helper for input labels to match MVC theme consistently
  Widget _buildInputLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}