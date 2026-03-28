import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverCardModular extends StatelessWidget {
  final String name;
  final String rating;
  final String trips;
  final String carModel;
  final String plateNumber;

  const DriverCardModular({
    super.key,
    required this.name,
    required this.rating,
    required this.trips,
    required this.carModel,
    required this.plateNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your Driver", 
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.black)),
              Row(
                children: [
                  // Matches the circular outlined chat icon in the image
                  _circularIcon(Icons.chat_bubble_outline_rounded),
                  SizedBox(width: 10.w),
                  // Matches the circular outlined phone icon in the image
                  _circularIcon(Icons.phone_outlined),
                ],
              )
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _avatarPlaceholder(name[0]),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, 
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black)),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      // Black rating badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A), 
                          borderRadius: BorderRadius.circular(20.r)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 14.r, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text(rating, 
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Text("  •  $trips trips", 
                        style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13.sp)),
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 16.h),
          _vehicleSubCard(),
        ],
      ),
    );
  }

  Widget _vehicleSubCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Very light grey background
        borderRadius: BorderRadius.circular(12.r)
      ),
      child: Column(
        children: [
          Row(
            children: [
              // White circular car icon background
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.directions_car_outlined, size: 20.r, color: Colors.black),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(carModel, 
                    style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(plateNumber, 
                    style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
          // Subtle thin divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          Row(
            children: [
              // Green shield icon for "Verified"
              Icon(Icons.shield_outlined, color: const Color(0xFF27AE60), size: 18.r),
              SizedBox(width: 8.w),
              Text("Verified Driver & Vehicle", 
                style: GoogleFonts.inter(
                  color: const Color(0xFF27AE60), 
                  fontWeight: FontWeight.w500, 
                  fontSize: 13.sp
                )),
            ],
          )
        ],
      ),
    );
  }

  Widget _avatarPlaceholder(String initial) {
    return Container(
      width: 55.w,
      height: 55.w,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), 
        borderRadius: BorderRadius.circular(14.r),
        // Slight shadow to lift the avatar like in the image
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Center(
        child: Text(initial, 
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp))
      ),
    );
  }

  Widget _circularIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5), // Light grey circle
        shape: BoxShape.circle
      ),
      child: Icon(icon, size: 22.r, color: Colors.black),
    );
  }
}