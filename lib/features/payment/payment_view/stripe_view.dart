import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/reusable_primary_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/payment/payment_controller/payment_controller.dart';

class StripeCardBottomSheet extends StatelessWidget {
  const StripeCardBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding to lift content above keyboard
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Hug content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Back icon and Title
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.keyboard_arrow_left, size: 28.sp),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              "Add card",
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),

            // Card Information Section
            _buildSectionLabel("Card information"),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  _buildStripeField("Card number", showIcons: true),
                  const Divider(height: 1, thickness: 1),
                  Row(
                    children: [
                      Expanded(child: _buildStripeField("MM / YY")),
                      Container(width: 1, height: 50.h, color: Colors.grey.shade300),
                      Expanded(child: _buildStripeField("CVC")),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Billing Address Section
            _buildSectionLabel("Billing address"),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                   DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: "United States",
                      items: const [DropdownMenuItem(value: "United States", child: Text("United States"))],
                      onChanged: (v) {},
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "ZIP",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),

            // Checkbox Row
            Row(
              children: [
                SizedBox(
                  height: 24.w,
                  width: 24.w,
                  child: Checkbox(value: true, activeColor: const Color(0xFF007AFF), onChanged: (v) {}),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    "Save this card for future powdur payments",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),

            // Main Pay Button
            ReusablePrimaryButton(
              // Assuming your controller has the amount
              text: "Pay \$135.00", 
              onTap: () {
                Navigator.pop(context); // Close sheet
                context.read<PaymentController>().completeStripePayment(context);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
    );
  }

  Widget _buildStripeField(String hint, {bool showIcons = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          suffixIcon: showIcons ? Icon(Icons.credit_card, size: 20.sp, color: Colors.grey) : null,
        ),
      ),
    );
  }
}