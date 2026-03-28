import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/cash_payment/cash_payment_controller/cash_payment_controller.dart';

class CashPaymentScreen extends StatelessWidget {
  const CashPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CashPaymentController>();

    return BaseScaffold(
      title: "Cash Payment",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Header Row
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1FDF5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.payments_outlined, 
                          color: const Color(0xFF22C55E), 
                          size: 26.r
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cash Payment", 
                            style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold)
                          ),
                          Text("Pay directly to driver", 
                            style: GoogleFonts.inter(color: Colors.grey, fontSize: 15.sp)
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  // 2. Amount Card (Green Border)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Text("Amount to Pay in Cash", 
                          style: GoogleFonts.inter(color: const Color(0xFF166534), fontSize: 16.sp, fontWeight: FontWeight.w500)
                        ),
                        SizedBox(height: 8.h),
                        Text("\$42", 
                          style: GoogleFonts.inter(fontSize: 48.sp, fontWeight: FontWeight.bold, color: const Color(0xFF166534))
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.payments, color: const Color(0xFF22C55E), size: 18.r),
                            SizedBox(width: 6.w),
                            Text("Pay this amount to Jennifer Lee", 
                              style: GoogleFonts.inter(color: const Color(0xFF22C55E), fontSize: 14.sp, fontWeight: FontWeight.w500)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // 3. Confirmation Box (Orange Alert Style)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFFED7AA), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Please confirm:", 
                          style: GoogleFonts.inter(color: const Color(0xFF9A3412), fontSize: 16.sp, fontWeight: FontWeight.bold)
                        ),
                        SizedBox(height: 12.h),
                        _buildStepText("You have paid \$42 in cash to the driver"),
                        SizedBox(height: 8.h),
                        _buildStepText("The driver has confirmed receiving the payment"),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // 4. Confirm Button
                  ElevatedButton(
                    onPressed: () => controller.processCashPayment(context, 42.0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B14F), // Vibrant Green
                      minimumSize: Size(double.infinity, 58.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white, size: 20.r),
                        SizedBox(width: 10.w),
                        Text("Confirm Cash Payment", 
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Container(
            width: 5.w, 
            height: 5.w, 
            decoration: const BoxDecoration(color: Color(0xFF9A3412), shape: BoxShape.circle)
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(text, 
            style: GoogleFonts.inter(color: const Color(0xFF9A3412), fontSize: 14.sp, height: 1.4)
          )
        ),
      ],
    );
  }
}