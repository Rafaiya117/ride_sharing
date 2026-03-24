import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      title: "Reset Password",
      isCurved: true,
      titleAlign: TextAlign.center, // Centered title, flexible per previous requirement
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.navigateBackToSignIn(context),
      ),
      // Set the mesh pattern SVG only for this page via headerBackground
      headerBackground: Opacity(
        opacity: 0.1,
        child: SvgPicture.asset(
          'assets/icons/mesh_pattern.svg', // Assumed path
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
      
      // --- BODY CONTENT ---
      child: Column(
        children: [
          SizedBox(height: 20.h), // Top padding within curved container

          // 1. Top Logo (from image)
          Image.asset(
            'assets/images/logo_small.png', // Ensure asset exists
            height: 100.h,
          ),
          SizedBox(height: 30.h),

          // 2. Main Title and Description
          Text(
            "Create password",
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E1E), // Near-black, standard readability
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Choose a strong password for your account",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF757575), // Soft grey, standard subtext color
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 40.h),

          // 3. --- INPUT FIELDS (DYNAMIC VISIBILITY) ---

          // Label: New Password
          _buildLabel("New Password"),
          // Reusable input field (using logic from image_3.png reference)
          CustomTextField(
            controller: controller.newPasswordController,
            hintText: "Enter password",
            prefixIconPath: 'assets/icons/lock.svg', // Assumed lock icon path
            isPassword: controller.isNewPasswordObscured, // Oberserved state
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
            prefixIconPath: 'assets/icons/lock.svg', // Assumed lock icon path
            isPassword: controller.isConfirmPasswordObscured, // Oberserved state
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
                style: TextStyle(
                  color: const Color(0xFF757575), // Soft grey
                  fontSize: 16.sp,
                ),
              ),
              GestureDetector(
                onTap: () => controller.navigateBackToSignIn(context),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.black, // Dark grey/black
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h), // Bottom spacing
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
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[700], // Soft grey label color
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}