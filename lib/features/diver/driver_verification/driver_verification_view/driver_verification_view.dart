import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_verification/driver_verification_controller/driver_verification_controller.dart';

class DriverVerificationScreen extends StatelessWidget {
  const DriverVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverVerificationController>();

    return BaseScaffold(
      title: Row(
    children: [
      // 1. The Expanded text takes up all middle space
      Expanded(
        child: Text(
          "Driver Verification",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // 2. Invisible spacer to balance the back button's 48px width
      const SizedBox(width: 48), 
    ],
  ),
  titleAlign: TextAlign.center,
  isCurved: true,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
      child: SingleChildScrollView(
        //padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text("Driver Verification", 
                    style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF131D33))),
                  SizedBox(height: 5.h),
                  Text("Complete verification to start offering rides", 
                    style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[600])),
                ],
              ),
            ),
            SizedBox(height: 25.h),

            // Car Details Section
            Text("Car Details", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 15.h),
            _buildLabel("Car Model"),
            _buildTextField(controller.modelController, "e.g., Toyota Camry"),
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildLabel("Year"),
                  _buildTextField(controller.yearController, "2022"),
                ])),
                SizedBox(width: 15.w),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildLabel("Color"),
                  _buildTextField(controller.colorController, "Black"),
                ])),
              ],
            ),

            SizedBox(height: 30.h),
            Text("Required Documents", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 15.h),

            // Document Items
            _buildDocItem(
              title: "Selfie Verification",
              subtitle: controller.isSelfieCaptured ? "1/1 photos Captured" : "Take a live selfie (no uploads)",
              iconPath: 'assets/icons/selfie_icon.svg',
              iconColor: Colors.blue,
              isCaptured: controller.isSelfieCaptured,
              onTap: () => controller.toggleVerification('selfie'),
            ),
            _buildDocItem(
              title: "Car Photo",
              subtitle: controller.isCarPhotoCaptured ? "4/4 photos Captured" : "Capture car photo (no uploads)",
              iconPath: 'assets/icons/car_icon.svg',
              iconColor: Colors.green,
              isCaptured: controller.isCarPhotoCaptured,
              multiPhotoCount: 4,
              onTap: () => controller.toggleVerification('car'),
            ),
            _buildDocItem(
              title: "Number Plate",
              subtitle: controller.isNumberPlateCaptured ? "1/1 photos Captured" : "Capture plate photo (no uploads)",
              iconPath: "assets/icons/number_plate_icon.svg",
              iconColor: Colors.orange,
              isCaptured: controller.isNumberPlateCaptured,
              onTap: () => controller.toggleVerification('plate'),
            ),
            _buildDocItem(
              title: "Driving License",
              subtitle: controller.isLicenseCaptured ? "1/1 photos Captured" : "Capture or upload license",
              iconPath: 'assets/icons/license_icon.svg',
              iconColor: Colors.purple,
              isCaptured: controller.isLicenseCaptured,
              showUpload: true,
              onTap: () => controller.toggleVerification('license'),
            ),

            // Security Box
            if (!controller.isAllVerified) ...[
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F0),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFFFE5D9)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, color: const Color(0xFFE67E22), size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Strong Security Verification", 
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF873600), fontSize: 14.sp)),
                          SizedBox(height: 4.h),
                          Text(
                            "We require live camera captures (not gallery uploads) for selfie, car, and number plate to prevent fake accounts and ensure passenger safety.",
                            style: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF873600)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 30.h),

            // Main Action Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: controller.isAllVerified ? () => controller.submitVerification(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isAllVerified ? Colors.black : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text("Complete Verification", 
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // --- Helper UI Components ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.bold, color: const Color(0xFF131D33))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }

  Widget _buildDocItem({
    required String title,
    required String subtitle,
    required String iconPath,
    required Color iconColor,
    required bool isCaptured,
    int multiPhotoCount = 1,
    bool showUpload = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                // Replaced Icon with SvgPicture.asset
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  width: 24.r,
                  height: 24.r,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              if (!isCaptured)
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.redAccent,
                  ),
                )
              else
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    fixedSize: Size(100.09.w, 36.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.w,), 
                  ),
                  child: Text(
                    "Change",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ), 
                  ),
                ),
            ],
          ),
          if (isCaptured) ...[
            SizedBox(height: 10.h),
            Row(
              children: List.generate(
                multiPhotoCount,
                (index) => Container(
                  width: 45.r,
                  height: 45.r,
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.green),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/check_circle.svg', 
                    colorFilter: const ColorFilter.mode(
                      Colors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
