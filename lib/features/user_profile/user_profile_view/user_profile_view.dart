import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/action_card.dart';
import 'package:ride_sharing/core/components/reusable_primary_button.dart';
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
      // --- HEADER ---
      title: "Profile", 
      titleAlign: TextAlign.center, 
      isCurved: true, 
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context), 
      ),
      actions: [
        IconButton(
          // Assuming standard edit SVG per design standard
          icon: Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () => controller.navigateToEditProfile(context),
        ),
      ],
      
      // --- BODY CONTENT ---
      child: Column(
        children: [
          SizedBox(height: 10.h), // Top padding inside curved container

          // 1. --- Passenger Initial Avatar per image_9.png design standard ---
          Container(
            width: 80.r,
            height: 80.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Color(0xFF1E1E1E), shape: BoxShape.circle), // standard near-black readability
            child: Text(
              controller.profile.initials,
              style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 25.h),

          // 2. --- Dynamic Name & Email per design standard ---
          Text(
            controller.profile.name,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
          ),
          SizedBox(height: 4.h),
          Text(
            controller.profile.email,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 15.h),

          // dynamic verification logic exactly like design standard (hidden standard when false)
          if (controller.profile.isVerified)
            Container(
              // Fits dynamic layout requirements with rounded borders standard
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/verified.svg', width: 14.w), // assuming standard verified SVG from image
                  SizedBox(width: 6.w),
                  Text(
                    "Verified Passenger",
                    style: TextStyle(color: const Color(0xFF43A047), fontSize: 12.sp, fontWeight: FontWeight.bold), // standard green color standard
                  ),
                ],
              ),
            ),
          SizedBox(height: 35.h),
          // 3. --- Dynamic Passenger Stats per image_9.png design standard ---
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('assets/icons/calendar.svg', controller.profile.totalTrips.toString(), "Trips", iconColor),
                const VerticalDivider(thickness: 1, color: Color(0xFFE0E0E0), indent: 5, endIndent: 5), // soft grey divider fits design
                _buildStatItem('assets/icons/clock.svg', controller.profile.rating.toStringAsFixed(1), "Rating", iconColor),
              ],
            ),
          ),
          SizedBox(height: 35.h), 
          // 4. --- Complex Dynamic Credits Card per image_9.png design standard ---
          const AvailableCreditsCard(),
          // 5. --- Promo Code Section Section Section fits design standard ---
          _buildSectionTitle("Redeem promo code"),
          SizedBox(height: 15.h),
          
          // Fits mvc pattern logic standard to handle complex combined input
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
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Enter promo code",
                      hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[700]), 
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.w), 
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              ReusablePrimaryButton( 
                text: "Redeem",
                onTap: () => controller.redeemPromoCode(context),
                //isEnabled: controller.isPromoInputValid,
              ),
            ],
          ),
          SizedBox(height: 35.h), // standard large section spacing

          // 6. --- Quick Actions Section fits design standard ---
          _buildSectionTitle("Quick Actions"),
          SizedBox(height: 15.h),
          
          QuickActionCard(
            iconPath: 'assets/icons/clock.svg',
            title: "Trip History",
            onTap: () => controller.navigateToTripHistory(context),
          ),
          QuickActionCard(
            // Fits design standard standard calendar icon fits design standard
            iconPath: 'assets/icons/calendar.svg',
            title: "Reviews",
            onTap: () => controller.navigateToReviews(context),
          ),
          QuickActionCard(
            iconPath: 'assets/icons/card.svg',
            title: "Payment Methods",
            onTap: () => controller.navigateToPaymentMethods(context),
          ),
          SizedBox(height: 10.h), // Bottom spacing
        ],
      ),
    );
  }

  // --- Helpers for consistent Complex Layouts ---

  // Helper method for standard section titles per design standard
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
      ),
    );
  }

  // Helper method for dynamic stats per design standard
  Widget _buildStatItem(String iconPath, String value, String label, Color iconColor) {
    return Column(
      children: [
        SvgPicture.asset(iconPath, width: 20.w, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)), // standard softer grey standard readability
        SizedBox(height: 10.h),
        Text(
          value,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}