import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/rating_info_card.dart';
import 'package:ride_sharing/core/components/reusable_primary_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/rating_driver/rating_driver_controller/rating_driver_controller.dart';
import 'package:ride_sharing/features/rating_driver/widget/rating_input_widget.dart';


class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RatingController>();
    const iconColor = Colors.grey;

    return BaseScaffold(
      // --- CURVED BLACK HEADER ---
      title: "Rate Your Trip", 
      titleAlign: TextAlign.center, 
      isCurved: true, 
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.navigateBack(context),
      ),
      
      // --- BODY CONTENT ---
      child: Column(
        children: [
          SizedBox(height: 10.h), 
          // 1. --- Dynamic Driver Initial Avatar per image_7.png ---
          Container(
            width: 80.r,
            height: 80.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Color(0xFF1E1E1E), shape: BoxShape.circle), // standard near-black readability
            child: Text(
              controller.driver.initials,
              style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 25.h),
          // 2. --- dynamic Title per design standard ---
          Text(
            "How was your trip?",
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
          ),
          SizedBox(height: 10.h),
          Text(
            "Rate your experience with ${controller.driver.name}",
            style: TextStyle(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 35.h), // standard large section spacing

          // 3. --- Dynamic Star Rating Info Card ---
          const RatingInfoCard(child: RatingInputWidget()),

          // 4. --- Complex Dynamic Comments Section per image_7.png design standard ---
          _buildSectionTitle("Additional Comments (Optional)"),
          SizedBox(height: 15.h),
          
          // Comments TextField matching design standard (rounded rect, multi-line)
          RatingInfoCard(
            padding: EdgeInsets.zero, // no padding inside card for input
            child: TextField(
              controller: controller.commentsController,
              maxLines: 6, // standard height from design
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              decoration: InputDecoration(
                hintText: "Share more details about your experience...",
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[700]), 
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18.w), 
              ),
            ),
          ),
          SizedBox(height: 15.h), 

          // 5. --- REUSABLE PRIMARY SOLID BLACK BUTTON per image_7.png design standard ---
          ReusablePrimaryButton(
            text: "Submit Rating",
            onTap: () => controller.submitRating(context),
          ),
          SizedBox(height: 35.h), // standard large section spacing

          // 6. --- Dynamic Trip Details Section per image_7.png design standard ---
          _buildSectionTitle("Trip Details"),
          SizedBox(height: 15.h),
          
          // Reusable standard grey card for complex details
          _buildTripDetailsCard(controller, iconColor),
          SizedBox(height: 10.h), // Bottom spacing
        ],
      ),
    );
  }

  // --- Helpers for consistent Complex Layouts ---

  // Helper method for standard grey card to strictly match image_7.png
  Widget _buildTripDetailsCard(RatingController controller, Color iconColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3), 
        borderRadius: BorderRadius.circular(15.r), 
      ),
      child: Column(
        children: [
          _buildDetailRow('assets/icons/calendar.svg', controller.trip.dateTime, iconColor),
          SizedBox(height: 15.h),
          _buildDetailRow('assets/icons/location_marker.svg', controller.trip.route, iconColor),
        ],
      ),
    );
  }

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

  // Helper method for Trip Details row per design standard
  Widget _buildDetailRow(String iconPath, String text, Color iconColor) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, width: 20.w, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)), // Assuming calendar/marker SVGs standard readability
        SizedBox(width: 15.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}