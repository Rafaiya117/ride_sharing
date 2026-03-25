import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomTextField extends StatelessWidget {
  final String hintText;
  final String prefixIconPath;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Widget? suffixIcon; // 1. Added this line

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIconPath,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.suffixIcon, // 2. Added this line
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
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 16.sp, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14.sp, color: iconColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: SvgPicture.asset(
              prefixIconPath,
              //colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn),
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