import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/auth/verify_otp/verify_otp_controller/verify_otp_controller.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OtpController>();
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4A4A), // Dark grey color from image_e03d7d.png
        borderRadius: BorderRadius.circular(8.r), // Slightly rounded corners
      ),
    );

    return BaseScaffold(
      // --- HEADER ---
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "OTP",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Mirror the leading icon's width here
          const SizedBox(width: 48),
        ],
      ),
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      // --- BODY CONTENT ---
      child: Column(
        children: [
          SizedBox(height: 20.h), 
          // 1. Top Logo (from image)
          Image.asset(
            'assets/images/logo_small.png',
            height: 100.h,
          ),
          SizedBox(height: 30.h),
          // 2. Main Title Description
          Text(
            "Verify OTP",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E1E), 
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "We have sent a 4-digit code to your email",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF7A7A7A), 
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 40.h),
          // 3. --- INDIVIDUAL PIN INPUTS (IMPLEMENTING AUTO-FOCUS) ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(controller.pinControllers.length, (index,
              ) {
                // Use the actual list length to prevent RangeError
                return Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: Pinput(
                        length: 1,
                        controller: controller.pinControllers[index],
                        focusNode: controller.focusNodes[index],
                        defaultPinTheme: defaultPinTheme,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            controller.onPinChanged(context, value, index),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 40.h),
          // 4. REUSABLE PRIMARY BLACK BUTTON
          CustomButton(
            text: "Send OTP",
            onTap: () => context.push('/reset_password'),
            //controller.verifyOtp(context),
          ),
          SizedBox(height: 30.h),
          // 5. --- DYNAMIC RESEND TIMER/LINK ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive code? ",
                style: TextStyle(
                  color: const Color(0xFF7A7A7A), // Soft grey
                  fontSize: 14.sp,
                ),
              ),
              GestureDetector(
                onTap: controller.canResend ? controller.resendOtp : null,
                child: Text(
                  controller.canResend ? "Resend" : "Resend in ${controller.start}s",
                  style: TextStyle(
                    color: controller.canResend ? Colors.black : const Color(0xFF7A7A7A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h), 
        ],
      ),
    );
  }
}