import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/components/custom_text_field.dart';
import 'package:ride_sharing/core/components/reusable_google_signin_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/auth/login/login_controller/login_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SignInController>();
    return BaseScaffold(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // This empty box balances the space taken by the back button on the left
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "Sign In",
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
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo_small.png',
            height: 80.h,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.directions_car, size: 80),
          ),
          SizedBox(height: 10.h),
          
          Text(
            "Welcome back",
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF001524),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Sign in to continue",
            style: GoogleFonts.inter(fontSize: 16.sp, color: const Color(0xFF757575)),
          ),
          SizedBox(height: 20.h),

          _buildLabel("Email"),
          CustomTextField(
            controller: controller.emailController,
            hintText: "your@email.com",
            prefixIconPath: 'assets/icons/email.svg',
          ),
          
          SizedBox(height: 10.h),
          _buildLabel("Phone Number"),
          CustomTextField(
            controller: controller.phoneController,
            hintText: "+1 (555) 000-0000",
            prefixIconPath: 'assets/icons/phone.svg',
          ),

          SizedBox(height: 10.h),
          _buildLabel("Password"),
          CustomTextField(
            controller: controller.passwordController,
            hintText: "Enter your password",
            prefixIconPath: 'assets/icons/lock.svg',
            isPassword: true,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/forgot_password'),
              child: Text("Forgot Password", style: GoogleFonts.inter(fontSize: 14.sp)),
            ),
          ),

          SizedBox(height: 15.h),
          CustomButton( 
            text: "Sign In",
            onTap: () => controller.signIn(context),
          ),

          SizedBox(height: 20.h),
           Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("OR", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          
          SizedBox(height: 10.h),
          GoogleSignInButton(onTap: () => controller.signInWithGoogle(context)),
          
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? "),
              GestureDetector(
                onTap: () => context.push('/sign_up'),
                child: Text("Sign Up", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

 