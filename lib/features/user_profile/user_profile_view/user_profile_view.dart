import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/action_card.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/user_profile/user_profile_controller/user_profile_controller.dart';
import 'package:ride_sharing/features/user_profile/widget/available_card_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    const iconColor = Colors.grey;

    return BaseScaffold(
      title: Row(
    children: [
      Expanded(
        child: Text(
          "Profile",
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
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
  actions: [
    IconButton(
      padding: EdgeInsets.only(right: 8.w),
      icon: SvgPicture.asset(
        'assets/icons/edit.svg', // Ensure this path is correct
        width: 22.w,
        height: 22.w,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      onPressed: () => controller.navigateToEditProfile(context),
    ),
  ],
      // Pass the navbar here to ensure it shows on the profile tab if needed
      // bottomNavigationBar: CustomBottomNavbar(
      //   currentIndex: 3, // Assuming Account is index 3
      //   onTap: (index) => context.read<HomeController>().setNavbarIndex(index),
      // ),
      child: Column(
        children: [
          SizedBox(height: 10.h), 

          Container(
            width: 80.r,
            height: 80.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Color(0xFF1E1E1E), shape: BoxShape.circle),
            child: Text(
              controller.profile.initials,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 25.h),

          Text(
            controller.profile.name,
            style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
          ),
          SizedBox(height: 4.h),
          Text(
            controller.profile.email,
            style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 15.h),

          if (controller.profile.isVerified)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/verified.svg', width: 14.w),
                  SizedBox(width: 6.w),
                  Text(
                    "Verified Passenger",
                    style: GoogleFonts.inter(color: const Color(0xFF43A047), fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          SizedBox(height: 35.h),

          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('assets/icons/calendar.svg', controller.profile.totalTrips.toString(), "Trips", iconColor),
                const VerticalDivider(thickness: 1, color: Color(0xFFE0E0E0), indent: 5, endIndent: 5),
                _buildStatItem('assets/icons/clock.svg', controller.profile.rating.toStringAsFixed(1), "Rating", iconColor),
              ],
            ),
          ),
          SizedBox(height: 35.h), 

          const AvailableCreditsCard(),

          _buildSectionTitle("Redeem promo code"),
          SizedBox(height: 15.h),
          
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h, 
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3), 
                    borderRadius: BorderRadius.circular(15.r), 
                  ),
                  child: TextField(
                    controller: controller.promoCodeController,
                    onChanged: (val) => controller.onPromoInputChanged(val), 
                    style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Enter promo code",
                      hintStyle: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey[700]), 
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.w), 
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              // FIX: SizedBox constrains the ReusablePrimaryButton's width within the Row
              SizedBox(
                width: 110.w, 
                child: CustomButton( 
                  text: "Redeem",
                  onTap: () => controller.redeemPromoCode(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 35.h),

          _buildSectionTitle("Quick Actions"),
          SizedBox(height: 15.h),
          
          QuickActionCard(
            iconPath: 'assets/icons/clock.svg',
            title: "Trip History",
            onTap: () => controller.navigateToTripHistory(context),
          ),
          QuickActionCard(
            iconPath: 'assets/icons/calendar.svg',
            title: "Reviews",
            onTap: () => controller.navigateToReviews(context),
          ),
          QuickActionCard(
            iconPath: 'assets/icons/credit.svg',
            title: "Payment Methods",
            onTap: () => controller.navigateToPaymentMethods(context),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
      ),
    );
  }

  Widget _buildStatItem(String iconPath, String value, String label, Color iconColor) {
    return Column(
      children: [
        SvgPicture.asset(iconPath, width: 20.w, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
        SizedBox(height: 10.h),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}