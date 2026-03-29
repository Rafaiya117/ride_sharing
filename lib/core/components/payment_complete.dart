import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingSuccessPopUp extends StatelessWidget {
  const RatingSuccessPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Green Checkmark Circle
            Container(
              width: 100.r,
              height: 100.r,
              decoration: const BoxDecoration(
                color: Color(0xFFE2FBE9), 
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/check.svg',
                  width: 60.r,
                  height: 60.r,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF00B14F),
                    BlendMode.srcIn,
                  ), // Success green
                ),
              ),
            ),
            SizedBox(height: 30.h),
            
            // "All Done!" Title
            Text(
              "All Done!",
              style: GoogleFonts.inter(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            
            // Success Message
            Text(
              "Rating submitted successfully",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}