import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/diver/driver_booking_confirm/driver_bookingconfirm_controller/driver_bookingconfirm_controller.dart';


class BookingConfirmScreen extends StatelessWidget {
  const BookingConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<BookingConfirmController>(); 
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        context.go('/drive_home_screen'); 
      }
    });
    
    return Scaffold(
    
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.h), 
            
            // 1. Success Checkmark Icon
            Container(
              width: 100.r,
              height: 100.r,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/success_icon.svg', 
                  width: 50.r,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF00C853), // Success green
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 40.h),

            // 2. Main Title
            Text(
              "Withdrawal Successful!",
              style: GoogleFonts.inter(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 15.h),

            // 3. Amount Section
            Text(
              "Your withdrawal of",
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              "\$50.00",
              style: GoogleFonts.inter(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "is being processed",
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 16.sp),
            ),

            SizedBox(height: 40.h),

            // 4. Details Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow("Payment Method", "Bank Account"),
                  SizedBox(height: 20.h),
                  _buildDetailRow("Transaction ID", "TXN-2026-701"),
                ],
              ),
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14.sp),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}