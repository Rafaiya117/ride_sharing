import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_info_card.dart';
import 'package:ride_sharing/core/components/journey_card.dart';
import 'package:ride_sharing/core/components/pick_option.dart';
import 'package:ride_sharing/core/components/ride_details_image_gallary.dart';
import 'package:ride_sharing/core/components/ride_top_card.dart';
import 'package:ride_sharing/core/components/support_option.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/ride_details/ride_details_controller/ride_details_controller.dart';
import 'package:ride_sharing/features/ride_details/widget/driver_card.dart';


class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RideDetailsController>();
    
    return BaseScaffold(
      title: "Ride Details",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/share.svg', width: 24.w, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          onPressed: () => controller.shareRideDetails(context),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RideTopCard(ride: controller.ride),
          SizedBox(height: 20.h,),
          JourneyRouteContainer(
            pickupLocation: 'New York, NY',
            pickupTime: '10:00 AM',
            dropoffLocation: 'Washington, DC',
            dropoffTime: 'Est. arrival time', 
          ),
          SizedBox(height: 20.h,),
          DriverCardModular(
            name: 'hhh', 
            rating: 'ghfhfh', 
            trips: 'ghfhg', 
            carModel: 'hfgh', 
            plateNumber: 'hgfhf',
          ),
          SizedBox(height: 20.h,),
          // 1. --- Driver Image Section ---
          _sectionTitle("Driver Image"),
          CustomInfoCard(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.asset('assets/images/driver_placeholder.png', fit: BoxFit.cover, height: 200.h),
            ),
          ),
          SizedBox(height: 10.h),
          VehicleImageGallery(imageUrls: controller.vehicleImages),
          SizedBox(height: 20.h,),
          // 2. --- Vehicle Information ---
          Row(
            children: [
              Expanded(child: _infoTile("Model", controller.ride.carModel)),
              SizedBox(width: 15.w),
              Expanded(child: _infoTile("Plate Number", controller.ride.carLicense)),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(child: _infoTile("Color", controller.ride.vehicleColor)),
              SizedBox(width: 15.w),
              Expanded(child: _infoTile("Total Seats", "${controller.ride.totalSeats} seats")),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            width: double
                .infinity, // Ensures perfect horizontal alignment with other cards
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              // APPLYING SAME FLOATING SHADOW AS SAFETY CARD
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15.r,
                  spreadRadius: 0,
                  offset: Offset(0, 4.h), // Matches directional offset
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MOVING TITLE INSIDE PER DESIGN RULE
                _sectionTitle("Pickup Options"),
                SizedBox(height: 12.h), // Consistent spacing after title
                PickupOptionTile(
                  title: "Meeting Point",
                  subtitle: "Meet at designated location",
                  trailing: "Included",
                  isSelected: controller.selectedPickupIndex == 0,
                  onTap: () => controller.setPickupOption(0),
                ),
                PickupOptionTile(
                  title: "Door Pickup",
                  subtitle: "Driver picks you up at your location",
                  trailing: "+\$10",
                  isSelected: controller.selectedPickupIndex == 1,
                  onTap: () => controller.setPickupOption(1),
                ),
              ],
            ),
          ),
          // view inside Column
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15.r,
                    spreadRadius: 0,
                    // Set offset to zero or a very small vertical-only offset to keep horizontal alignment perfect
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Safety & Support",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF101010),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SupportOptionTile(
                    icon: Icons.security_outlined,
                    title: "Live Trip Tracking",
                    subtitle: "Share location with family & friends",
                    iconColor: const Color(0xFF1DB954),
                    backgroundColor: const Color(0xFFE8F5E9),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 55.w),
                    child: Divider(color: const Color(0xFFF3F3F3), height: 1.h),
                  ),
                  SupportOptionTile(
                    icon: Icons.phone_in_talk_outlined,
                    title: "Emergency Support",
                    subtitle: "24/7 assistance & emergency contacts",
                    iconColor: const Color(0xFFE53935),
                    backgroundColor: const Color(0xFFFFEBEE),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          _buildBottomActions(context,controller),
          //SizedBox(height: 100.h),
        ],
      ),
    );
  }

  // --- Helper Methods defined inside the class to fix your error ---

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Text(
        title,
        style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF3F3F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey)),
          SizedBox(height: 4.h),
          Text(value, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, RideDetailsController controller) {
  final double verticalPadding = 20.h;
  final double horizontalPadding = 16.w;
  final double internalPadding = 20.h; 

  return Container(
    padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, internalPadding),
    decoration: BoxDecoration(
      color: Colors.white,
      border: const Border(
        top: BorderSide(
          color: Color(0xFFF3F3F3), 
          width: 1,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10.r,
          offset: Offset(0, -4.h), 
        )
      ],
    ),
    child: Row(
      children: [
        // 1. "Make an Offer" Button (Outlined)
        Expanded(
          child: OutlinedButton(
            onPressed: () => controller.makeOffer(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black, 
              side: const BorderSide(color: Color(0xFFE0E0E0)), 
              padding: EdgeInsets.symmetric(vertical: 16.h),
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r), 
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600, 
                color: Colors.black,
              ),
            ),
            child: const Text("Make an Offer"),
          ),
        ),
        SizedBox(width: 12.w), // Gap between buttons
        // 2. "Book Now" Button (Solid Black)
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.bookNow(context, controller.ride.totalPrice),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF131D33), // Dark blue-black color from image
              foregroundColor: Colors.white, // Text Color
              padding: EdgeInsets.symmetric(vertical: 16.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r), // Rounded edges
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700, // Bolder weight for dynamic pricing
                color: Colors.white,
              ),
            ),
            // Combining Text and Dynamic Data from controller
            child: Text("Book Now • \$${controller.ride.totalPrice.toInt()}"),
          ),
        ),
      ],
    ),
  );
}
}