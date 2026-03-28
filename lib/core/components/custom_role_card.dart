import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          // Background color transitions automatically
          color: isSelected ? const Color(0xFF1E1E1E) : Colors.black,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            // Left Icon Container
            Container(
              width: 55.w,
              height: 55.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(12.w),
              child: SvgPicture.asset(iconPath),
            ),
            SizedBox(width: 16.w),
            
            // Text Area
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFC0C0C0),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // --- ANIMATED ARROW (Stateless via TweenAnimationBuilder) ---
            TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 300),
              tween: ColorTween(
                begin: const Color(0xFFC0C0C0),
                end: isSelected ? Colors.green : const Color(0xFFC0C0C0),
              ),
              builder: (context, color, child) {
                return SvgPicture.asset(
                  'assets/icons/arrow_right.svg',
                  colorFilter: ColorFilter.mode(
                    color!,
                    BlendMode.srcIn,
                  ),
                  width: 20.w,
                  height: 20.h,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}