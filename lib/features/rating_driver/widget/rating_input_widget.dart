import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/rating_driver/rating_driver_controller/rating_driver_controller.dart';
class RatingInputWidget extends StatelessWidget {
  const RatingInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller dynamically
    final controller = context.watch<RatingController>();

    return Column(
      children: [
        // Star Interaction Row per design standard
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            int starNumber = index + 1;
            // DYNAMIC STAR FILL logic from design system
            bool isFilled = starNumber <= controller.selectedRating;
            
            return GestureDetector(
              onTap: () => controller.updateRating(starNumber),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w), // standard star padding
                child: Icon(
                  isFilled ? Icons.star : Icons.star_border,
                  color: isFilled ? const Color(0xFFFFC107) : const Color(0xFFD0D0D0), // Amber vs Light Grey standard readability
                  size: 48.r, // Large standard star size
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 15.h),
        // --- Dynamic Label per design standard (e.g., 😔 Poor) ---
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: controller.selectedRating == 0
            ? const SizedBox.shrink(): Text(
            controller.ratingLabels[controller.selectedRating]!,
            style: TextStyle(
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