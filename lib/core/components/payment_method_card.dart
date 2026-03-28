import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_sharing/features/payment/payment_model/payment_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodData method;
  final bool isSelected;
  final Function(PaymentMethodType) onSelect;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onSelect,
  });

  @override

  Widget build(BuildContext context) {
    const selectedBorderColor = Color(0xFF1E1E1E);
    const badgeColor = Colors.black;
    const badgeTextColor = Colors.white;

    return GestureDetector(
      onTap: () => onSelect(method.type),
      child: Container(
        width: double.infinity, 
        margin: EdgeInsets.only(
          bottom: 10.h,
        ), 
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: isSelected
          ? Border.all(color: selectedBorderColor, width: 1.5)
          : Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: Row(
          children: [
            // 1. --- Icon Container ---
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: isSelected
                ? const Color(0xFF1E1E1E)
                : const Color(0xFF2B7FFF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                method.iconPath,
                width: 24.w,
                height: 24.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            // 2. --- Text Information ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    method.subtitle,
                    style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[700]),
                  ),
                  if (method.subSubtitle != null)
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: method.isSecure
                        ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            method.subSubtitle!,
                            style: GoogleFonts.inter(
                              color: badgeTextColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        )
                        : Text(
                          method.subSubtitle!,
                          style: GoogleFonts.inter(
                            color: Colors.grey[700],
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

            // 3. --- Radio Button ---
            SizedBox(
              width: 24.w,
              child: Radio<PaymentMethodType>(
                value: method.type,
                groupValue: isSelected ? method.type : null,
                activeColor: selectedBorderColor,
                onChanged: (_) => onSelect(method.type),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
