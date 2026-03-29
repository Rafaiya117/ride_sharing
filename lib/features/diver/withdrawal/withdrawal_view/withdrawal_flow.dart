import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/earning/controller/earning_controller.dart';

class WithdrawalFlowView extends StatelessWidget {
  const WithdrawalFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EarningsController>();
    bool isAmountStep = controller.currentWithdrawalStep == 0;

    return BaseScaffold(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isAmountStep ? "Withdrawal Amount" : "Payment Method",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.white),
          ),
          Text(
            isAmountStep 
                ? "Available: \$${controller.data.availableEarnings.toInt()}"
                : "Withdrawing \$${controller.withdrawalAmount.toInt()}",
            style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.white70, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (isAmountStep) {
            Navigator.pop(context);
          } else {
            controller.currentWithdrawalStep = 0;
          }
        },
      ),
      child: Column(
        children: [
          // Removed Expanded and internal SingleChildScrollView to fix the layout crash
          Padding(
            padding: EdgeInsets.all(20.r),
            child: isAmountStep ? _buildAmountStep(controller) : _buildPaymentStep(controller),
          ),
          // Added a fixed Spacer or SizedBox to maintain layout without crashing
          SizedBox(height: 40.h), 
          _buildContinueButton(controller,context),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // --- STEP 1: Amount Selection ---
  Widget _buildAmountStep(EarningsController controller) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Enter Amount", style: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp)),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(15.r)),
            child: Row(
              children: [
                Text("\$", style: GoogleFonts.inter(fontSize: 32.sp, color: Colors.grey)),
                SizedBox(width: 10.w),
                Text("${controller.withdrawalAmount.toInt()}", 
                  style: GoogleFonts.inter(fontSize: 32.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [50, 100, 200, 'All'].map((val) {
              bool isSelected = (val is int && controller.withdrawalAmount == val.toDouble()) || 
                               (val == 'All' && controller.withdrawalAmount == 441);
              return GestureDetector(
                onTap: () => controller.setAmount(val == 'All' ? 441 : (val as int).toDouble()),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(val.toString(), 
                    style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- STEP 2: Payment Selection ---
  // --- STEP 2: Payment Selection (Dynamic) ---
  Widget _buildPaymentStep(EarningsController controller) {
    // In a real app, you might have a list of methods. For now, we use a boolean.
    bool isCardSelected = controller.currentWithdrawalStep == 1; 

    return GestureDetector(
      onTap: () => controller.notifyListeners(), // Logic to select this method
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          // Highlight border if selected
          border: Border.all(color: isCardSelected ? Colors.black : Colors.grey.shade100, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: const BoxDecoration(color: Color(0xFFF3F4F6), shape: BoxShape.circle),
              child: SvgPicture.asset('assets/icons/credit.svg', width: 24.sp,colorFilter:ColorFilter.mode(Colors.black, BlendMode.srcIn),),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Card Payment", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  Text("Withdrawal to Stripe", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp)),
                ],
              ),
            ),
            // Dynamic Radio Button
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCardSelected ? Colors.black : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isCardSelected 
                ? Center(
                    child: Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                    ),
                  )
                : null,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(EarningsController controller,BuildContext context) {
    bool canContinue = controller.withdrawalAmount > 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        width: double.infinity,
        height: 55.h,
        child: ElevatedButton(
          onPressed: canContinue ? () => controller.nextStep(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canContinue ? Colors.black : Colors.grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            elevation: 0,
          ),
          child: Text("Continue", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}