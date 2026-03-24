import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/user_edit_profile/user_edit_profile_controller/user_edit_profile_controller.dart';

class PhotoHeader extends StatelessWidget {
  const PhotoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller dynamically
    final controller = Provider.of<EditProfileController>(context);

    return Column(
      children: [
        SizedBox(height: 10.h),
        Stack(
          alignment: Alignment.center,
          children: [
            // Circular Avatar or Image per logic
            Container(
              width: 140.r,
              height: 140.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.initialsData['color'], // Dark grey
              ),
              alignment: Alignment.center,
              child: controller.currentUser.photoPath == null
                ? Text(
                  controller.initialsData['letter'], // 'J'
                    style: TextStyle(
                      fontSize: 64.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                  : ClipOval(
                    child: Image.network(
                      controller.currentUser.photoPath!, // network logic placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Floating Camera Icon Button
                Positioned(
                  bottom: 0,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: controller.changePhoto, 
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: Colors.white, // light bg
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ), // subtle black border
                      ),
                     child: Icon(
                      Icons.camera_alt_outlined,
                      size: 24.r,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Tap text fits dynamic layout standard standard dynamic price logic
        GestureDetector(
          onTap: controller.changePhoto, // standard mvc action
          child: Text(
            "Tap to change photo",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87, // softer black readability
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 35.h), // spacing before basic info section
      ],
    );
  }
}
