import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Driver Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Status Animation / Icon Unit
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F2F6),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70.r,
                    height: 70.r,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      strokeWidth: 3,
                    ),
                  ),
                  Icon(
                    Icons.hourglass_empty_rounded,
                    size: 36.sp,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // 2. Main Headline Status
            Text(
              "Under Review",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            // 3. Descriptive Subtitle Text Context
            Text(
              "Your vehicle details and documents have been submitted successfully. Please wait while our administrative team reviews your profile information.",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8E8E93),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),

            // 4. Status Indicator Alert Banner
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFFFE699)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.orange.shade700, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      "Review processes typically take between 24-48 business hours.",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60.h),

            // 5. Secondary Action Button (Optional Contact Support Anchor)
            OutlinedButton(
              onPressed: () {
                // Link your internal customer support chat framework logic here
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 54.h),
                side: const BorderSide(color: Colors.black, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "Contact Support",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}