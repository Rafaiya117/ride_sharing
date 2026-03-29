import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusablePrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final String iconPath;
  final ButtonStyle? style; // Add this
  final TextStyle? textStyle; // Add this

  const ReusablePrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.iconPath = 'assets/icons/chevron_right.svg',
    this.backgroundColor = const Color(0xFF555555),
    this.textColor = Colors.white,
    this.style, // Initialize this
    this.textStyle, // Initialize this
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        // Use the passed style if available, otherwise use default
        style: style ?? ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                // Use the passed textStyle if available, otherwise use default
                style: textStyle ?? GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}