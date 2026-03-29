import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/components/custom_text_field.dart';
import 'package:ride_sharing/core/components/reusable_google_signin_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/auth/signup/sign_up_controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the controller via Provider
    final controller = context.watch<SignUpController>();

    return BaseScaffold(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // This empty box balances the space taken by the back button on the left
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Mirror the leading icon's width here
          SizedBox(width: 48.w),
        ],
      ),
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      child: Column(
        children: [
          // Top Logo and Connecting Line
          Image.asset(
            'assets/images/logo_small.png',
            height: 80.h,
          ),
          SizedBox(height: 20.h),
          // Main Title
          Text(
            "Create account",
            style: GoogleFonts.inter(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF001524),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Sign up to continue",
            style: GoogleFonts.inter(fontSize: 18.sp, color: const Color(0xFF757575)),
          ),
          SizedBox(height: 20.h),

          // --- INPUT FIELDS ---
          
          _buildLabel("Full Name"),
          CustomTextField(
            controller: controller.nameController,
            hintText: "Enter your name",
            prefixIconPath: 'assets/icons/email.svg', 
          ),
          SizedBox(height: 10.h),

          _buildLabel("Email"),
          CustomTextField(
            controller: controller.emailController,
            hintText: "your@email.com",
            prefixIconPath: 'assets/icons/lock.svg', 
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10.h),

          _buildLabel("Phone Number"),
          CustomTextField(
            controller: controller.phoneController,
            hintText: "+1 (555) 000-0000",
            prefixIconPath: 'assets/icons/phone.svg',
            keyboardType: TextInputType.phone,
          ),

          SizedBox(height: 20.h),

          // --- CREATE ACCOUNT BUTTON ---
          CustomButton(
            text: "Create account",
            onTap: () => controller.createAccount(context),
          ),

          SizedBox(height: 20.h),

          // OR Divider
           Row(
            children: [
              Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 1.5)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("OR", style: GoogleFonts.inter(color: Color(0xFFE0E0E0), fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 1.5)),
            ],
          ),
          SizedBox(height: 20.h),

          // --- GOOGLE SIGN-UP BUTTON ---
          GoogleSignInButton(
            onTap: () => controller.signUpWithGoogle(context),
          ),
          SizedBox(height: 20.h),
          // Footer Signup Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: GoogleFonts.inter(color: Color(0xFF757575), fontSize: 16),
              ),
              GestureDetector(
                onTap: () => controller.navigateToSignIn(context),
                child: Text(
                  "Sign In",
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  // Helper for input labels
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}