import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reusable_primary_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 


class OnboardingTemplate extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.currentIndex,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Bottom Watermark Image (The World Map)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.05, 
              child: Image.asset(
                'assets/images/world_map_vector.png', 
                fit: BoxFit.contain,
                width: 1.sw,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: Column(
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${currentIndex + 1} of 3", 
                        style: GoogleFonts.inter(color: Colors.grey, fontSize: 16.sp),
                      ),
                      GestureDetector(
                        onTap: onSkip,
                        child: Text(
                          "Skip", 
                          style: GoogleFonts.inter(color: Colors.grey, fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Central Content
                  Image.asset(
                    imagePath, 
                    height: 167.96.h, 
                    fit: BoxFit.contain, 
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: 250.w, 
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, 
                      style: GoogleFonts.inter(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                        height: 1.2.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: 310.w,
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      softWrap: true,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: const Color(0xFF757575),
                        height: 1.5.h,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: index == currentIndex ? 30.w : 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: index == currentIndex ? const Color(0xFF555555) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    )),
                  ),
                  SizedBox(height: 30.h),

                  // Reusable Button
                  ReusablePrimaryButton(
                    text: currentIndex == 2 ? "Get Started" : "Next",
                    onTap: onNext,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}