import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewTileWidget extends StatelessWidget {
  final dynamic review; // Using dynamic to allow any model type

  const ReviewTileWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final String displayName = review.passengerName ?? review.name ?? "User";
    final String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : "?";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50.r,
                height: 50.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E), 
                  shape: BoxShape.circle
                ),
                child: Text(
                  initial, // Dynamic initial from name
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          displayName, // Dynamic Name
                          style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          'assets/icons/check.svg', 
                          width: 18.r,
                          height: 18.r,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF43A047),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: const Color(0xFFFFC107), 
                              size: 20.r, 
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      review.date ?? "",
                      style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            review.comment ?? "",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.black.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}