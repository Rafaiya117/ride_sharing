import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/sharetrip/share_trip_controller/share_trip_controller.dart';


class ShareTripCard extends StatelessWidget {
  const ShareTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ShareTripController>(context);

    const cardBackgroundColor = const Color(0xFF1E1E1E); 
    const textColorPrimary = Colors.white;
    const textColorSecondary = Colors.grey; 

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 35.h),
      padding: EdgeInsets.all(20.w), 
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20.r), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sharing trip details for",
                style: TextStyle(fontSize: 14.sp, color: textColorSecondary, fontWeight: FontWeight.w400),
              ),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: SvgPicture.asset('assets/icons/share.svg', width: 20.w, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            controller.trip.fromLocation,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: textColorPrimary),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: textColorSecondary, size: 16.r),
              SizedBox(width: 8.w),
              Text(
                controller.trip.toLocation, 
                style: TextStyle(fontSize: 14.sp, color: textColorSecondary),
              ),
            ],
          ),
          SizedBox(height: 25.h), 
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildDynamicInfoRow(
                    'assets/icons/clock.svg',
                    "Departure",
                    controller.trip.departureTime,
                    controller.trip.departureDate,
                    textColorPrimary, textColorSecondary,
                  ),
                ),
                const VerticalDivider(thickness: 1, color: textColorSecondary, indent: 5, endIndent: 5), // standard grey divider fits design
                Expanded(
                  child: _buildDynamicInfoRow(
                    'assets/icons/car.svg',
                    "Driver",
                    controller.trip.driverName,
                    controller.trip.driverCar,
                    textColorPrimary, textColorSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildDynamicInfoRow(String iconPath, String label, String valueText, String subValueText, Color textColorPrimary, Color textColorSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(iconPath, width: 16.w, colorFilter: ColorFilter.mode(textColorSecondary, BlendMode.srcIn)), // standard softer grey standard
            SizedBox(width: 8.w),
            Text(label, style: TextStyle(fontSize: 12.sp, color: textColorSecondary, fontWeight: FontWeight.w400)),
          ],
        ),
        SizedBox(height: 8.h),
        Text(valueText, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: textColorPrimary)),
        SizedBox(height: 4.h),
        Text(subValueText, style: TextStyle(fontSize: 12.sp, color: textColorSecondary, fontWeight: FontWeight.w400)),
      ],
    );
  }
}