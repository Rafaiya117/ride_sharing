import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_edit_profile/driver_edit_profile_controller/driver_edit_profile_controller.dart';

class DriverEditView extends StatelessWidget {
  const DriverEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverEditController>();

    return BaseScaffold(
      title: "Edit Profile",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            
            // Profile Photo Section
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: const Color(0xFF4B5563),
                        child: Text("J", style: TextStyle(fontSize: 40.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)]),
                            child: Icon(Icons.camera_alt_outlined, size: 20.sp, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text("Tap to change photo", style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
                ],
              ),
            ),
            
            SizedBox(height: 30.h),
            Align(alignment: Alignment.centerLeft, child: Text("Basic Information", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold))),
            SizedBox(height: 20.h),

            // Form Fields
            _buildInputField(label: "Full Name", controller: controller.nameController, icon: Icons.person_outline),
            _buildInputField(label: "Email Address", controller: controller.emailController, icon: Icons.email_outlined),
            _buildInputField(label: "Phone Number", controller: controller.phoneController, icon: Icons.phone_outlined),
            _buildInputField(label: "Home Address", controller: controller.addressController, icon: Icons.location_on_outlined),

            SizedBox(height: 40.h),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => controller.saveChanges(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_outlined, color: Colors.white),
                    SizedBox(width: 10.w),
                    const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required TextEditingController controller, required IconData icon}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: Colors.black),
              SizedBox(width: 8.w),
              Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE5E7EB).withOpacity(0.5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            ),
          ),
        ],
      ),
    );
  }
}