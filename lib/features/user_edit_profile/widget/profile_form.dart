import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/user_edit_profile/user_edit_profile_controller/user_edit_profile_controller.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller dynamically
    final controller = Provider.of<EditProfileController>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20.h, left: 5.w),
          child: Text(
            "Basic Information",
            style: TextStyle(
              fontSize: 18.sp, 
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E283A), 
            ),
          ),
        ),
        _buildProfileInputField(
          label: "Full Name",
          hint: "John Doe",
          prefixIcon: Icons.person_outline,
          controller: controller.fullNameController,
        ),
        _buildProfileInputField(
          label: "Email Address",
          hint: "safimahmud1412@gmail.com",
          prefixIcon: Icons.email_outlined,
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildProfileInputField(
          label: "Phone Number",
          hint: "+8801728583881",
          prefixIcon: Icons.phone_outlined,
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
        ),
        _buildProfileInputField(
          label: "Home Address",
          hint: "123 Main St, City, State",
          prefixIcon: Icons.location_on_outlined,
          controller: controller.addressController,
          isLast: true, 
        ),
      ],
    );
  }

  // --- Modular Input Field Builder ---
  Widget _buildProfileInputField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(prefixIcon, size: 18.r, color: Colors.black87), 
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp, 
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 60.h, 
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF), 
            borderRadius: BorderRadius.circular(12.r), 
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 16.sp, color: Colors.black54), 
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero, 
            ),
          ),
        ),
        if (!isLast) SizedBox(height: 18.h), 
      ],
    );
  }
}