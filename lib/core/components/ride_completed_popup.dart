import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideCompletedPopUp extends StatelessWidget {
  final String fromLocation;
  final String toLocation;
  final double totalAmount;
  final bool isCash; // New: To toggle button text
  final VoidCallback onContinueToPayment;

  const RideCompletedPopUp({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.totalAmount,
    required this.isCash, // Required in constructor
    required this.onContinueToPayment,
  });

  @override
  Widget build(BuildContext context) {
    const greenColor = Color.fromARGB(255, 86, 231, 42); 
    const iconBackgroundColor = Color.fromARGB(255, 206, 235, 205); 
    const locationCardColor = Color(0xFFF3F3F3); 
    const primaryTextColor = Colors.black; 
    const secondaryTextColor = Colors.grey; 

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Check Icon
            Container(
              width: 80.w,
              height: 80.w,
              margin: EdgeInsets.only(top: 10.h, bottom: 25.h),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outlined,
                color: greenColor,
                size: 50.r,
              ),
            ),

            // 2. Titles
            Text(
              "Ride Completed!",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "You've arrived at your destination safely",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: secondaryTextColor, 
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 35.h), 

            // 3. Location Summary Card
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: locationCardColor, 
                borderRadius: BorderRadius.circular(15.r), 
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.location_on_outlined, color: greenColor, size: 24.r),
                        const Expanded(child: VerticalDivider(color: secondaryTextColor, thickness: 1)),
                        Icon(Icons.location_on_outlined, color: const Color(0xFFFF3B30), size: 24.r),
                      ],
                    ),
                    SizedBox(width: 15.w),                     
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLocationText("From", fromLocation),
                          const Spacer(),
                          _buildLocationText("To", toLocation),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),

            // 4. Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 16.sp, color: secondaryTextColor, fontWeight: FontWeight.w400),
                ),
                Text(
                  "\$${totalAmount.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 35.h), 

            // 5. Dynamic Primary Button
            SizedBox(
              height: 60.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onContinueToPayment(); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white, 
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // Ternary logic for the button text
                      isCash ? "Continue to Payment" : "Continue",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18.r), 
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400)),
        SizedBox(height: 3.h),
        Text(value, style: TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}