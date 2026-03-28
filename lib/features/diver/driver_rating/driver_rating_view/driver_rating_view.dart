import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_rating/driver_rating_controller/driver_rating_controller.dart';

class DriverRatingScreen extends StatelessWidget {
  const DriverRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverRatingController>();

    return BaseScaffold(
      title: "Rate Your Trip",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            
            // 1. Passenger Avatar
            CircleAvatar(
              radius: 45.r,
              backgroundColor: const Color(0xFF131D33),
              child: Text(
                controller.passengerInitial,
                style: GoogleFonts.inter(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // 2. Headings
            Text(
              "How was your trip?",
              style: GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              "Rate your experience with ${controller.passengerName}",
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[600]),
            ),

            SizedBox(height: 30.h),

            // 3. Interactive Rating Card
            _buildRatingInteractionCard(controller),

            SizedBox(height: 25.h),

            // 4. Additional Comments Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Additional Comments (Optional)",
                style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: controller.commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Share more details about your experience...",
                hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),

            SizedBox(height: 25.h),

            // 5. Submit Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => controller.submitRating(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  "Submit Rating",
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 25.h),

            // 6. Trip Details Summary
            _buildTripSummaryFooter(controller),
            
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingInteractionCard(DriverRatingController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              int starValue = index + 1;
              return IconButton(
                icon: Icon(
                  controller.selectedRating >= starValue ? Icons.star : Icons.star_border,
                  color: controller.selectedRating >= starValue ? Colors.amber : Colors.grey[300],
                  size: 42.r,
                ),
                onPressed: () => controller.updateRating(starValue),
              );
            }),
          ),
          if (controller.selectedRating > 0) ...[
            SizedBox(height: 8.h),
            Text(
              controller.currentLabel,
              style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildTripSummaryFooter(DriverRatingController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Trip Details", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.grey[600])),
          SizedBox(height: 12.h),
          Text(controller.route, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14.sp)),
          SizedBox(height: 4.h),
          Text(controller.dateTime, style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)),
        ],
      ),
    );
  }
}