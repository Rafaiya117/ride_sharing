import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuickActionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colors per image_9.png reference
    const iconColor = Colors.black;
    const textColor = Colors.black;
    const arrowColor = Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 15.h), // standard spacing between items
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h), // standard content padding from design
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r), // Standard corner radius from theme
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Subtle shadow from image
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 20.w, colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp, color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
            SvgPicture.asset('assets/icons/arrow_right.svg', width: 14.w, colorFilter: const ColorFilter.mode(arrowColor, BlendMode.srcIn)),
          ],
        ),
      ),
    );
  }
}