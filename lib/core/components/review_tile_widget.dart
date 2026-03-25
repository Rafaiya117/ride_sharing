import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/features/review_user/review_user_model/review_user_model.dart';

class ReviewTileWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewTileWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r), // Softer radius per image
        border: Border.all(color: const Color(0xFFF0F0F0)), // Light border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. --- Avatar ---
              Container(
                width: 50.r,
                height: 50.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E), 
                  shape: BoxShape.circle
                ),
                child: Text(
                  review.initials,
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 15.w),
              
              // 2. --- Name, Date, and Verified Icon ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.passengerName,
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Spacer(),
                        // Verified Checkmark
                        Icon(Icons.check_circle_outline_rounded, color: const Color(0xFF43A047), size: 18.r),
                        SizedBox(width: 8.w),
                        // 3. --- Stars (Placed in same row as name) ---
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
                      review.date,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600], fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // 4. --- Comment Text ---
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}