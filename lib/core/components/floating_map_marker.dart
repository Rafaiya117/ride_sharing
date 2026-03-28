import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingMapMarker extends StatelessWidget {
  final bool isPickup;
  final String locationName;

  const FloatingMapMarker({
    super.key,
    required this.isPickup,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, color: isPickup ? Colors.grey : Colors.black, size: 30.r), // Standard icons match design
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
          child: Text(locationName, style: GoogleFonts.inter(color: Colors.black, fontSize: 12.sp)),
        ),
      ],
    );
  }
}