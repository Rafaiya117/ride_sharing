import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
              subtitle: controller.isSelfieCaptured? "1/1 photos Captured": "Take a live selfie (no uploads)",
              iconPath: 'assets/icons/selfie_icon.svg',
              iconColor: Colors.blue,
              isCaptured: controller.isSelfieCaptured,
              onTap: (path) =>controller.toggleVerification('selfie', filePath: path),
            ),
            _buildDocItem(
              title: "Car Photo",
              subtitle: controller.isCarPhotoCaptured? "4/4 photos Captured": "Capture car photo (no uploads)",
              iconPath: 'assets/icons/car_icon.svg',
              iconColor: Colors.green,
              isCaptured: controller.isCarPhotoCaptured,
              multiPhotoCount: 4,
              onTap: (path) => controller.toggleVerification('car', filePath: path),
            ),
            _buildDocItem(
              title: "Number Plate",
              subtitle: controller.isNumberPlateCaptured? "1/1 photos Captured": "Capture plate photo (no uploads)",
              iconPath: "assets/icons/number_plate_icon.svg",
              iconColor: Colors.orange,
              isCaptured: controller.isNumberPlateCaptured,
              onTap: (path) => controller.toggleVerification('plate', filePath: path),
            ),
            _buildDocItem(
              title: "Driving License",
              subtitle: controller.isLicenseCaptured? "1/1 photos Captured": "Capture or upload license",
              iconPath: 'assets/icons/license_icon.svg',
              iconColor: Colors.purple,
              isCaptured: controller.isLicenseCaptured,
              showUpload:true, // Triggers both custom action selection buttons inside row
              onTap: (path) =>controller.toggleVerification('license', filePath: path),
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
                          Text(
                            "Strong Security Verification", 
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
  bool showUpload = false,
  int multiPhotoCount = 1,
  required Function(String filePath) onTap,
}) {
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      onTap(image.path);
    }
  }

  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(14.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- TOP ROW: Always displays icon, text details, and action states ---
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              color: iconColor,
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            // --- ACTION TRIGGER LAYOUTS ---
            if (isCaptured) ...[
              // State 2: Show Gray "Change" button on the right when items are captured
              SizedBox(
                height: 32.h,
                child: ElevatedButton(
                  onPressed: () => showUpload ? pickImage(ImageSource.camera) : pickImage(ImageSource.camera), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text(
                    "Change",
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ] else if (showUpload) ...[
              // State 1 (License): Upload and Camera stack icons matching Image 1
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.file_upload_outlined, color: Colors.grey.shade400),
                    onPressed: () => pickImage(ImageSource.gallery),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.red.shade300),
                    onPressed: () => pickImage(ImageSource.camera),
                  ),
                ],
              ),
            ] else ...[
              // State 1 (Default): Single Red Circle Camera Action matching Image 1
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt_outlined, color: Colors.red.shade400, size: 18.sp),
                ),
                onPressed: () => pickImage(ImageSource.camera),
              ),
            ],
          ],
        ),

        // --- BOTTOM ROW: Conditionally rendered only when documents are Captured (Image 2) ---
        if (isCaptured) ...[
          SizedBox(height: 12.h),
          Row(
            children: List.generate(
              multiPhotoCount,
              (index) => Container(
                margin: EdgeInsets.only(right: 8.w),
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4FAF7),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFF2ECC71)),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF2ECC71),
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
