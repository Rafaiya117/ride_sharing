import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/chat/chat_controller/chat_controller.dart';


class TripContextWidget extends StatelessWidget {
  const TripContextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller dynamically
    final controller = context.watch<ChatController>();
    const iconColor = Colors.grey;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 30.h), 
      padding: EdgeInsets.all(20.w), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r), 
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05), 
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/location_marker.svg', width: 20.w, colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(controller.pickup, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: SvgPicture.asset('assets/icons/arrow_right.svg', width: 14.w, colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
                    ),
                    Text(controller.dropoff, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(controller.date, style: TextStyle(fontSize: 14.sp, color: iconColor)),
              Text(
                "\$${controller.pricePerSeat.toStringAsFixed(0)}/seat", 
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}