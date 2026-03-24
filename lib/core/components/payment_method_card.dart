import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    // Colors from image_10.png reference
    const selectedBorderColor = const Color(0xFF1E1E1E); 
    const badgeColor = Colors.black;
    const badgeTextColor = Colors.white;

    return GestureDetector(
      onTap: () => onSelect(method.type),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h), 
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
            // 1. --- Icon (Using a placeholder standard asset call) ---
            Container(
              width: 50.w, height: 50.w, 
              decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(12.r)),
              alignment: Alignment.center,
              child: SvgPicture.asset(method.iconPath, width: 24.w, height: 24.w), 
            ),
            SizedBox(width: 15.w),
            // 2. --- Text Information ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    method.subtitle,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]), // soft grey readability
                  ),
                  
                  // DYNAMIC SUB-SUBTITLE Logic from design
                  if (method.subSubtitle != null)
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: method.isSecure
                        ? Container(
                        // Special Black Badge style for "Secure" options per design standard
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(10.r)),
                        child: Text(method.subSubtitle!, style: TextStyle(color: badgeTextColor, fontSize: 11.sp)),
                        )
                      : Text(method.subSubtitle!, style: TextStyle(color: Colors.grey[700], fontSize: 14.sp)),
                    ),
                  ],
                ),
              ),
            // 3. --- Standard Flutter Radio Button (Matches design standard) ---
            SizedBox(
              width: 24.w,
              child: Radio<PaymentMethodType>(
                value: method.type,
                // ignore: deprecated_member_use
                groupValue: isSelected ? method.type : null, 
                activeColor: selectedBorderColor, 
                // ignore: deprecated_member_use
                onChanged: (_) => onSelect(method.type),
              ),
            ),
          ],
        ),
      ),
    );
  }
}