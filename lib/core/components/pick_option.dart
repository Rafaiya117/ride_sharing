import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PickupOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final bool isSelected;
  final VoidCallback onTap;

  const PickupOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r), 
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE8E8E8), 
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Custom Radio Icon to match the rounded design in the image
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.black : const Color(0xFF101010), // Darker icon even when off
              size: 22.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700, 
                      fontSize: 16.sp, 
                      color: const Color(0xFF101010),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF757575), 
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              trailing,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800, 
                fontSize: 14.sp,
                color: const Color(0xFF101010),
              ),
            ),
          ],
        ),
      ),
    );
  }
}