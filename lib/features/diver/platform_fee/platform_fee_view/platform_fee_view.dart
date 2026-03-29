import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/diver/platform_fee/platform_fee_controller/platform_fee_controller.dart';

class FeeRequiredPopup extends StatelessWidget {
  const FeeRequiredPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FeePaymentController>();

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trip Completed!", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Text("Platform fee required", style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
                    ],
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              SizedBox(height: 15.h),

              // Green Earnings Card
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white, // Outer background is white
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFD4EFDF),
                    width: 1.5,
                  ), // Light green border
                ),
                child: Column(
                  children: [
                    Text(
                      "You Earned",
                      style: GoogleFonts.inter(
                        color: const Color(0xFF27AE60),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "\$${controller.tripEarnings.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        color: const Color(0xFF27AE60),
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "From this trip",
                      style: GoogleFonts.inter(
                        color: const Color(0xFF27AE60),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Inner Breakdown Card
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFF6FFF9,
                        ), // Very light green solid background
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          _buildFeeRow(
                            null,
                            "Trip Earnings",
                            "\$${controller.tripEarnings.toStringAsFixed(2)}",
                            Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(height: 12.h),
                          _buildFeeRow(
                            'assets/icons/percent.svg',
                            "Platform Fee (5%)",
                            "-\$${controller.platformFee.toStringAsFixed(2)}",
                            const Color(0xFFE67E22),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Divider(
                              color: const Color(0xFFD4EFDF).withOpacity(0.5),
                              thickness: 1,
                            ),
                          ),
                          _buildFeeRow(
                            null,
                            "Net Earnings",
                            "\$${controller.netEarnings.toStringAsFixed(2)}",
                            const Color(0xFF27AE60),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              // Warning Box
              Container(
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F0),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFFFE5D9)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error_outline, color: const Color(0xFFE67E22), size: 20.sp),
                        SizedBox(width: 8.w),
                        Text("Platform Fee Required", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF873600), fontSize: 15.sp)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "To continue using our platform and post new trips, please pay the 5% platform fee of \$${controller.platformFee.toStringAsFixed(2)}.",
                      style: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF873600)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              Text("Select Payment Method", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),

              // Payment Methods
              _buildPaymentTile(controller, 0, Icons.credit_card, "Stripe Payment", "Pay with card or bank account"),
              SizedBox(height: 10.h),
              _buildPaymentTile(controller, 1, Icons.phone_android, "Mobile Banking", "bKash, Nagad, Rocket"),

              SizedBox(height: 20.h),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => controller.handlePayment(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                  child: Text("Pay \$${controller.platformFee.toStringAsFixed(2)} Now", style:GoogleFonts.inter(color: Colors.white)),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, color: Colors.black, size: 18),
                      SizedBox(width: 8.w),
                      Text("Pay Later", style: GoogleFonts.inter(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeeRow(
    String? svgPath,
    String label,
    String value,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      children: [
        if (svgPath != null) ...[
          SvgPicture.asset(
            svgPath,
            width: 14.r,
            height: 14.r,
            colorFilter: ColorFilter.mode(valueColor, BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
        ],
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isBold ? 16.sp : 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? Colors.black : Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isBold ? 18.sp : 14.sp,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTile(FeePaymentController controller, int index, IconData icon, String title, String subtitle) {
    bool isSelected = controller.selectedMethod == index;
    return GestureDetector(
      onTap: () => controller.selectMethod(index),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8.r)),
              child: Icon(icon, color: Colors.black54),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  Text(subtitle, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.black),
          ],
        ),
      ),
    );
  }
}