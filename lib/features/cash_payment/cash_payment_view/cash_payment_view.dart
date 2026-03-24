import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/cash_payment/cash_payment_controller/cash_payment_controller.dart';

class CashPaymentScreen extends StatelessWidget {
  const CashPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CashPaymentController>();
    final isCashSelected = controller.selectedMethod == 'cash';

    return Scaffold(
      backgroundColor: const Color(0x00fff8f8), 
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment",
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.h),
          child: Padding(
            padding: EdgeInsets.only(bottom:15.h),
            child: Text(
              "Secure checkout",
              style: TextStyle(color: Colors.white70, fontSize: 13.sp),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Payment Method", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 15.h),

            // --- Dynamic Cash Payment Card ---
            GestureDetector(
              onTap: () => controller.selectMethod('cash'),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isCashSelected ? Colors.black : Colors.transparent, 
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF2FF), // Soft blue bg from image_8.png
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.payments_outlined, color: Colors.blue, size: 28.r),
                    ),
                    SizedBox(width: 15.w),
                    // Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cash Payment", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                          Text("Pay with cash", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                          SizedBox(height: 5.h),
                          // Specific Cash instruction from image_8.png
                          Text(
                            "\$  Pay directly to driver", 
                            style: TextStyle(color: Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    // Radio indicator
                    Icon(
                      isCashSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isCashSelected ? Colors.black : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 30.h),
            
            // --- Price Breakdown Section ---
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _buildPriceRow("Ride fare (1 seat)", "\$45"),
                  _buildPriceRow("Service fee", "\$5"),
                  const Divider(),
                  _buildPriceRow("Total", "\$50", isTotal: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.w),
        child: ElevatedButton(
          onPressed: () => controller.processCashPayment(context, 50.0),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: Size(double.infinity, 55.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: Text(
            "Confirm Cash Payment",
            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15.sp, color: isTotal ? Colors.black : Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 22.sp : 16.sp, 
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}