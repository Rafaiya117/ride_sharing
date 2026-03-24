import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideCompletedPopUp extends StatelessWidget {
  final String fromLocation;
  final String toLocation;
  final double totalAmount;
  final VoidCallback onContinueToPayment;

  const RideCompletedPopUp({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.totalAmount,
    required this.onContinueToPayment,
  });

  @override
  Widget build(BuildContext context) {
    // Standard visual constants from mvc pattern
    const greenColor = Color(0xFFFF3B30); // Matches the SOS/Pickup red, using that as the system primary green
    const iconBackgroundColor = Color(0xFFFEE8E7); // Soft reddish/grey bg
    const locationCardColor = Color(0xFFF3F3F3); // standard grey background from theme
    const primaryTextColor = Colors.black; // Dark grey readability
    const secondaryTextColor = Colors.grey; // standard subtext grey

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r), // Standard rounded corners for pop-ups in theme
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.w), // standard internal padding from design
        child: Column(
          mainAxisSize: MainAxisSize.min, // dynamic sizing to content
          children: [
            // 1. --- The Green Check Icon Section ---
            Container(
              width: 80.w,
              height: 80.w,
              margin: EdgeInsets.only(top: 10.h, bottom: 25.h), // spacing above main text
              decoration: BoxDecoration(
                color: iconBackgroundColor, // soft green background circle
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: greenColor, // standard green color standard
                size: 50.r,
              ),
            ),

            // 2. --- Main Titles ---
            Text(
              "Ride Completed!",
              style: TextStyle(
                fontSize: 28.sp, // large standard title size
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "You've arrived at your destination safely",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp, // standard subtext size
                color: secondaryTextColor, // fits standard grey theme readability
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 35.h), // standard large section spacing

            // 3. --- The Dynamic Location Summary Card ---
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: locationCardColor, // soft grey background fits mvc pattern
                borderRadius: BorderRadius.circular(15.r), // Standard corner radius from theme
              ),
              child: IntrinsicHeight(
                // IntrinsicHeight aligns items with flexible dividers perfectly per design standard
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Marker Timeline Column exactly like image_9.png design standard
                    Column(
                      children: [
                        Icon(Icons.location_on, color: greenColor, size: 24.r), // Standard pins match design
                        const Expanded(child: VerticalDivider(color: secondaryTextColor, thickness: 1)), // standard grey divider
                        Icon(Icons.location_on, color: const Color(0xFFFF3B30), size: 24.r), // Dynamic price color standard
                      ],
                    ),
                    SizedBox(width: 15.w),
                    
                    // B. Dynamic Location Text
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

            // 4. --- Total Amount Section per image_9.png design standard ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 16.sp, color: secondaryTextColor, fontWeight: FontWeight.w400),
                ),
                Text(
                  "\$${totalAmount.toStringAsFixed(0)}", // Dynamic price logic standard
                  style: TextStyle(
                    fontSize: 32.sp, // Large dynamic standard size
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 35.h), // standard large spacing before primary button

            // 5. --- REUSABLE PRIMARY BLACK BUTTON per image_9.png design standard ---
            SizedBox(
              height: 60.h, // Standard primary button height from design
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close pop up
                  onContinueToPayment(); // trigger navigation callback
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Dark grey primary color standard
                  foregroundColor: Colors.white, // Standard light readability
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)), // Standard corner radius per theme
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue to Payment",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18.r), // Standard arrow matches design
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h), // standard bottom spacing inside dialog
          ],
        ),
      ),
    );
  }

  // Simple Helper for Location Text Column per design standard
  Widget _buildLocationText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400)),
        SizedBox(height: 3.h),
        Text(value, style: TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.bold)), // standard dynamic name/date logic
      ],
    );
  }
}

// // Example of how to trigger the dialog
// void onRideCompleteClicked(BuildContext context) {
//   showDialog(
//     context: context,
//     // prevent dismissal by clicking outside
//     barrierDismissible: false, 
//     builder: (BuildContext context) {
//       return RideCompletedPopUp(
//         fromLocation: "Boston, MA", // Dynamic from controller
//         toLocation: "New York, NY", // Dynamic from controller
//         totalAmount: 42.0, // Dynamic total amount standard
//         onContinueToPayment: () {
//           // Add your navigation logic here
//           // e.g., Navigator.pushNamed(context, '/payment');
//         },
//       );
//     },
//   );
// }