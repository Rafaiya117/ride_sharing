import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentInfoCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showShadow;
  final bool titleInside;
  final bool isMainPadding; // New flag for internal padding

  const PaymentInfoCard({
    super.key,
    required this.child,
    this.title,
    this.showShadow = true,
    this.titleInside = false,
    this.isMainPadding = true, // Default to true to keep existing layouts
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && !titleInside)
          Padding(
            padding: EdgeInsets.only(bottom: 15.h, left: 5.w),
            child: Text(
              title!,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E1E),
              ),
            ),
          ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 15.h),
          // DYNAMIC PADDING: 20 if true, 0 if false
          padding: isMainPadding ? EdgeInsets.all(20.w) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null && titleInside) ...[
                Padding(
                  // Keep padding for title even if isMainPadding is false
                  padding: isMainPadding ? EdgeInsets.zero : EdgeInsets.all(20.w),
                  child: Text(
                    title!,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E1E),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
              child,
            ],
          ),
        ),
      ],
    );
  }
}