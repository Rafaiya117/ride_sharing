import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/components/custom_text_field.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/auth/forgot_passowrd/forgot_password_controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller via Provider
    final controller = context.watch<ForgotPasswordController>();

    return BaseScaffold(
      // --- HEADER ---
      title: "Forgot Password",
      isCurved: true,
      titleAlign: TextAlign.center, // Centered title, flexible per previous fix
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.navigateBackToSignIn(context),
      ),
      // Set the optional mesh pattern from image_1.png only for this page
      headerBackground: Opacity(
        opacity: 0.1,
        child: SvgPicture.asset(
          'assets/icons/mesh_pattern.svg',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
      
      // --- BODY CONTENT ---
      child: Column(
        children: [
          // 1. Top Logo (from image)
          Image.asset(
            'assets/images/logo_small.png', 
            height: 100.h,
          ),
          SizedBox(height: 20.h),
          // 2. Main Title Description
          Text(
            "Enter your email address and we'll send you a verify code to reset your password.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              color: const Color(0xFF1E1E1E), 
              fontWeight: FontWeight.w400,
              height: 1.4, 
            ),
          ),
          SizedBox(height: 20.h),
          // 3. Label & REUSABLE INPUT FIELD (with SVG)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Email",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.grey[700], 
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CustomTextField(
            controller: controller.emailController,
            hintText: "your@email.com",
            prefixIconPath: 'assets/icons/email.svg', 
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 20.h),
          // 4. REUSABLE PRIMARY BLACK BUTTON
          CustomButton(
            text: "Request OTP",
            onTap: () => context.push('/otp_verification'),
          ),
          SizedBox(height: 20.h),
          // 5. Footer Navigation Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Back to ",
                style: GoogleFonts.inter(
                  color: const Color(0xFF757575), 
                  fontSize: 16.sp,
                ),
              ),
              GestureDetector(
                onTap: () => controller.navigateBackToSignIn(context),
                child: Text(
                  "Sign In",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16.sp,
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