import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/components/custom_text_field.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/auth/reset_password/reset_passsword_controller/reset_passowrd_controller.dart';


class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller via Provider
    final controller = context.watch<ResetPasswordController>();

    return BaseScaffold(
      // --- HEADER ---
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // This empty box balances the space taken by the back button on the left
          const SizedBox(width: 48),
          Expanded(
            child: Text(
              "Reset Password",
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
          SizedBox(height: 20.h), 
          // 1. Top Logo (from image)
          Image.asset(
            'assets/images/logo_small.png', 
            height: 100.h,
          ),
          SizedBox(height: 30.h),

          // 2. Main Title and Description
          Text(
            "Create password",
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E1E), 
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Choose a strong password for your account",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              color: const Color(0xFF757575), 
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 40.h),
          // 3. --- INPUT FIELDS (DYNAMIC VISIBILITY) ---
          // Label: New Password
          _buildLabel("New Password"),
          CustomTextField(
            controller: controller.newPasswordController,
            hintText: "Enter password",
            prefixIconPath: 'assets/icons/lock.svg', 
            isPassword: controller.isNewPasswordObscured, 
            // Logic to add a visibility toggle (suffix icon)
            suffixIcon: IconButton(
              icon: Icon(
                controller.isNewPasswordObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => controller.toggleNewPasswordVisibility(),
            ),
          ),
          SizedBox(height: 15.h),
          // Label: Confirm Password
          _buildLabel("Confirm Password"),
          CustomTextField(
            controller: controller.confirmPasswordController,
            hintText: "Confirm password",
            prefixIconPath: 'assets/icons/lock.svg', 
            isPassword: controller.isConfirmPasswordObscured, 
            // Logic to add a visibility toggle (suffix icon)
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => controller.toggleConfirmPasswordVisibility(),
            ),
          ),
          SizedBox(height: 40.h),
          // 4. REUSABLE PRIMARY BLACK BUTTON
          CustomButton( 
            text: "Reset Password",
            onTap: () => controller.resetPassword(context),
          ),
          SizedBox(height: 30.h),
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

  // Helper method for input labels to match design consistently
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: Colors.grey[700], 
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}