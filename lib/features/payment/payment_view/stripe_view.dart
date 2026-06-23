import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/reusable_primary_button.dart';
import 'package:ride_sharing/features/home/home_controller/home_controller.dart';
import 'package:ride_sharing/features/payment/payment_controller/payment_controller.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentMethodType, PaymentMethodData;
import 'package:stripe_platform_interface/stripe_platform_interface.dart' as stripe_platform_interface;

class StripeCardBottomSheet extends StatefulWidget {
  const StripeCardBottomSheet({super.key});

  @override
  State<StripeCardBottomSheet> createState() => _StripeCardBottomSheetState();
}

class _StripeCardBottomSheetState extends State<StripeCardBottomSheet> {
  final CardFormEditController _cardFormController = CardFormEditController();
  bool _isSuccess = false; 

  @override
  void dispose() {
    _cardFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentController = context.watch<PaymentController>();

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
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
              style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            _buildSectionLabel("Card & Billing information"),
            SizedBox(
              height: 240.h,
              child: CardFormField(
                controller: _cardFormController,
                style: CardFormStyle(
                  borderColor: const Color(0xFF007AFF),
                  borderWidth: 1,
                  borderRadius: 12,
                  textColor: Colors.black,
                  backgroundColor: Colors.grey.shade50,
                  fontSize: 15.sp.toInt(),
                  placeholderColor: Colors.grey.shade400,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                SizedBox(
                  height: 24.w,
                  width: 24.w,
                  child: Checkbox(
                    value: true, 
                    activeColor: const Color(0xFF007AFF), 
                    onChanged: (v) {}),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Save this card for future payments",
                      style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            _isSuccess
              ? Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  padding: EdgeInsets.all(12.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1DB954),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 40.sp),
                  ),
                )
                : ReusablePrimaryButton(
                  text: paymentController.isPaying 
                    ? "Processing..." : "Pay \$${paymentController.payment.totalAmount.toStringAsFixed(2)}", 
                    onTap: paymentController.isPaying 
                      ? () {} 
                      : () async {
                        if (_cardFormController.details.complete == true) {
                          final cardParams = PaymentMethodParams.card(
                            paymentMethodData: stripe_platform_interface.PaymentMethodData());
                              // Trigger operations pipeline
                              bool success = await paymentController.confirmCustomCardPayment(context, cardParams);                              
                              if (success && context.mounted) {
                                setState(() {
                                  _isSuccess = true;
                                });                      
                                // Keep checkmark visible briefly before final screen routing transition execution
                                await Future.delayed(const Duration(milliseconds: 1000));
                                if (context.mounted) {
                                  context.read<HomeController>().clearInputs();
                                  Navigator.pop(context); // Dismiss sheet safely
                                  GoRouter.of(context).push('/user_home_screen'); // Direct navigation route handling
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter complete card and billing details first."),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
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
      child: Text(text, style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade600)),
    );
  }
}