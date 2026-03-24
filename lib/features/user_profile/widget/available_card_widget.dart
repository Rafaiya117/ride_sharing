import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/user_profile/user_profile_controller/user_profile_controller.dart';


class AvailableCreditsCard extends StatelessWidget {
  const AvailableCreditsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    // Colors per image_9.png reference
    const cardBackgroundColor = const Color(0xFF1E1E1E); 
    const textColorPrimary = Colors.white;
    const textColorSecondary = Colors.grey; 

    return GestureDetector(
      onTap: () => controller.viewCreditHistory(context),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 25.h), 
        padding: EdgeInsets.all(20.w), 
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(20.r), 
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/credits.svg', width: 18.w, colorFilter: const ColorFilter.mode(textColorPrimary, BlendMode.srcIn)),
                    SizedBox(width: 10.w),
                    Text(
                      "Available Credits",
                      style: TextStyle(fontSize: 14.sp, color: textColorPrimary, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                // Forward arrow implies navigation per dynamic layout requirements standard
                SvgPicture.asset('assets/icons/arrow_right.svg', width: 16.w, colorFilter: const ColorFilter.mode(textColorPrimary, BlendMode.srcIn)),
              ],
            ),
            SizedBox(height: 15.h),
            // Dynamic Amount Logic exactly like design reference
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Big Dynamic standard amount display standard
                Text(
                  "\$${controller.profile.availableCredits.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 32.sp, color: textColorPrimary, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Use on your next ride",
                  style: TextStyle(fontSize: 12.sp, color: textColorSecondary, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}