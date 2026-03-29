import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';


class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      // --- Header Implementation ---
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Development",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Balances the width of the back button to keep title centered
          const SizedBox(width: 48), 
        ],
      ),
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      
      // --- Body Implementation ---
      child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Optional: You can add an icon or lottie animation here later
            Icon(
              Icons.construction_rounded,
              size: 80.sp,
              color: const Color(0xFF888888).withOpacity(0.5),
            ),
            SizedBox(height: 20.h),
            Text(
              "Development In Progress",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "We are working hard to bring this\nfeature to you soon!",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
              ),
            ),
          ],
        ), 
      ), 
    );
  }
}