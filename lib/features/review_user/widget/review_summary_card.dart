import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/review_user/review_user_controller/review_user_controller.dart';

class ReviewsSummaryCard extends StatelessWidget {
  const ReviewsSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ReviewsController>(context);
    const starIcon = Icons.star_rounded;

    // Shared decoration for both containers
    final cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

    return Column(
      children: [
        // 1. --- Overall Rating Container ---
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20.h),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            // Matching the deep blue/dark gradient from the image
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E4AB0), Color(0xFF0D1B3E)],
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Overall Rating",
                        style: TextStyle(fontSize: 16.sp, color: Colors.white70, fontWeight: FontWeight.w400),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            controller.overallRating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 56.sp, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            " / 5.0",
                            style: TextStyle(fontSize: 20.sp, color: Colors.white60),
                          ),
                        ],
                      ),
                      // Adding the star row from the image
                      Row(
                        children: List.generate(5, (index) => Icon(
                          Icons.star_rounded,
                          color: index < controller.overallRating.floor() ? Colors.amber : Colors.white24,
                          size: 24.r,
                        )),
                      ),
                    ],
                  ),
                  // "Excellent" badge from the top right of the image
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.trending_up_rounded, color: Colors.greenAccent, size: 32.r),
                        SizedBox(height: 8.h),
                        Text("Excellent", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 24.h),
              // Bottom Grid for Total and 5-Star Reviews
              Row(
                children: [
                  Expanded(child: _buildStatBox("Total Reviews", controller.totalReviews.toString())),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildStatBox("5-Star Reviews", "6")), // Static '6' per image req
                ],
              ),
            ],
          ),
        ),

        // 2. --- Rating Breakdown Container ---
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 25.h),
          padding: EdgeInsets.all(20.w),
          decoration: cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row with Show All button moved here
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rating Breakdown",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
                  ),
                  GestureDetector(
                    onTap: controller.showAllReviews,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), 
                        borderRadius: BorderRadius.circular(15.r) // More rounded per image
                      ),
                      child: Text(
                        "Show All", 
                        style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _buildBreakdownRow(5, controller, starIcon),
              _buildBreakdownRow(4, controller, starIcon),
              _buildBreakdownRow(3, controller, starIcon),
              _buildBreakdownRow(2, controller, starIcon),
              _buildBreakdownRow(1, controller, starIcon),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(int starLevel, ReviewsController controller, IconData starIcon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h), // Increased vertical spacing per image
      child: Row(
        children: [
          // Star Label
          SizedBox(
            width: 35.w,
            child: Row(
              children: [
                Text("$starLevel", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(width: 4.w),
                Icon(Icons.star_rounded, color: Colors.grey, size: 18.r),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          // Updated Progress Bar colors to match design
          Expanded(
            child: LinearProgressIndicator(
              value: controller.getStarPercentage(starLevel),
              backgroundColor: const Color(0xFFF0F0F0), // Light grey track
              color: Colors.black, // Black indicator per image
              minHeight: 10.h,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 20.w),
          // Count Label
          SizedBox(
            width: 20.w,
            child: Text(
              (controller.starCounts[starLevel] ?? 0).toString(),
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildStatBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
          SizedBox(height: 8.h),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}