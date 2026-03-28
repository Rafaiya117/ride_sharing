import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/rating_driver/rating_driver_controller/rating_driver_controller.dart';
class RatingInputWidget extends StatelessWidget {
  const RatingInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RatingController>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            int starNumber = index + 1;
            bool isFilled = starNumber <= controller.selectedRating;
            
            return GestureDetector(
              onTap: () => controller.updateRating(starNumber),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: SvgPicture.asset(
                  // Dynamic path based on state
                  isFilled ? 'assets/icons/star_filled.svg' : 'assets/icons/star_outline.svg',
                  width: 44.r,
                  height: 44.r,
                  // Apply dynamic color filter to the SVG
                  colorFilter: ColorFilter.mode(
                    isFilled ? const Color(0xFFFFC107) : const Color(0xFFD0D0D0),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 15.h),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: controller.selectedRating == 0
            ? const SizedBox.shrink()
            : Text(
                controller.ratingLabels[controller.selectedRating]!,
                style: GoogleFonts.inter(
                  fontSize: 16.sp, 
                  color: Colors.grey, 
                  fontWeight: FontWeight.w400,
                ),
              ),
        ),
      ],
    );
  }
}