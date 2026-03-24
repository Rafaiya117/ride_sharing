import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/features/review_user/review_user_model/review_user_model.dart';

class ReviewTileWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewTileWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    const goldStarColor = const Color(0xFFFFC107); 
    const softerGreyText = Colors.black54; 

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h), 
      padding: EdgeInsets.all(18.w), 
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3), 
        borderRadius: BorderRadius.circular(15.r), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Color(0xFF1E1E1E), shape: BoxShape.circle), // standard near-black readability
                child: Text(
                  review.initials,
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.passengerName,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      review.date,
                      style: TextStyle(fontSize: 14.sp, color: softerGreyText, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: goldStarColor, 
                    size: 18.r, 
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 15.h), 
          // dynamic standard passenger standard dynamic dynamic logic standard standard price
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black.withOpacity(0.85), 
              fontWeight: FontWeight.w400,
              height: 1.4, 
            ),
          ),
        ],
      ),
    );
  }
}