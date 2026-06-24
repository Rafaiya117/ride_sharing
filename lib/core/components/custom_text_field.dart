import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTextField extends StatelessWidget {
  final String hintText;
  final String prefixIconPath;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool showBorder; 
  final ValueChanged<String>? onChanged; // FIXED: Added callback listener

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIconPath,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.suffixIcon,
    this.showBorder = false, 
    this.onChanged, // FIXED
  });

  @override
  Widget build(BuildContext context) {
    const inputColor = Color(0xFFF3F3F3);
    const iconColor = Color(0xFF888888);

    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(15.r),
        border: showBorder ? Border.all(color: const Color(0xFFE0E0E0), width: 1) : null,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        onChanged: onChanged, // FIXED
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(fontSize: 14.sp, color: iconColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: SvgPicture.asset(
              prefixIconPath,
              width: 18.w,
              fit: BoxFit.scaleDown,
            ),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}