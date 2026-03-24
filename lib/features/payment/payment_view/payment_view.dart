import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/payment_info_card.dart';
import 'package:ride_sharing/core/components/payment_method_card.dart';
import 'package:ride_sharing/core/components/reusable_primary_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/payment/payment_controller/payment_controller.dart';
import 'package:ride_sharing/features/payment/payment_model/payment_model.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PaymentController>();
    return BaseScaffold(
      // --- HEADER ---
      title: "Payment", 
      titleAlign: TextAlign.center, 
      isCurved: false, 
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.navigateBack(context),
      ),
      // Header subtitle fits dynamic layout standard
      headerBackground: SafeArea(
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 20.h),
          child: Text(
            "Secure checkout",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8), // near-black readability standard
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      
      // --- BODY CONTENT ---
      child: Column(
        children: [
          SizedBox(height: 10.h), // Top padding inside curved container

          // 1. --- Dynamic Trip Summary Card ---
          PaymentInfoCard(
            title: "Trip Summary", // Section title above card fits design
            child: Column(
              children: [
                _buildSummaryTile("Route", controller.payment.route),
                _buildSummaryTile("Date & Time", controller.payment.date),
                _buildSummaryTile("Driver", controller.payment.driverName),
                _buildSummaryTile("Seats", "${controller.payment.seats} seat"), // assumed singular seat display standard
              ],
            ),
          ),

          // 2. --- Dynamic Payment Methods List ---
          PaymentInfoCard(
            title: "Payment Method",
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: ListView.builder(
                shrinkWrap: true, // required inside BaseScaffold scrolling
                physics: const NeverScrollableScrollPhysics(), // scrolling handled by base
                itemCount: controller.availableMethods.length,
                itemBuilder: (context, index) {
                  final method = controller.availableMethods[index];
                  // DYNAMIC SELECTION Logic exactly like design
                  final isSelected = method.type == controller.selectedMethod;
                  return PaymentMethodCard(
                    method: method,
                    isSelected: isSelected,
                    onSelect: (type) => controller.selectPaymentMethod(type),
                  );
                },
              ),
            ),
          ),

          // 3. --- Dynamic Price Breakdown Card ---
          PaymentInfoCard(
            title: "Price Breakdown",
            child: Column(
              children: [
                _buildBreakdownTile("Ride fare (${controller.payment.seats} seat)", controller.payment.rideFare, Colors.grey),
                _buildBreakdownTile("Service fee", controller.payment.serviceFee, Colors.grey),
                SizedBox(height: 10.h),
                const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                SizedBox(height: 10.h),
                _buildBreakdownTile("Total", controller.payment.totalAmount, Colors.black, isBold: true),
              ],
            ),
          ),

          SizedBox(height: 20.h), // spacing before standard primary button

          // 4. --- REUSABLE PRIMARY SOLID BLACK BUTTON ---
          ReusablePrimaryButton( 
            // DYNAMIC LABEL: "Pay... Now" for card, "Save" for others (Cash/Credits)
            text: controller.selectedMethod == PaymentMethodType.card
              ? "Pay \$${controller.payment.totalAmount.toStringAsFixed(0)} Now"
              : "Save",
            onTap: () => controller.processPayment(context),
          ),
          SizedBox(height: 20.h), // Bottom spacing
        ],
      ),
    );
  }

  // --- Helper Methods for Consistent Complex Layouts ---
  Widget _buildSummaryTile(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for Price Breakdown tiles per design standard
  // Change 'MaterialColor?' to 'Color?' here
  Widget _buildBreakdownTile(String label,double amount,Color? amountColor, {bool isBold = false,}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: isBold ? Colors.black : Colors.grey,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            "\$${amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: isBold ? 24.sp : 16.sp,
              color: amountColor ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
