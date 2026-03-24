import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/review_user/review_user_controller/review_user_controller.dart';

class ReviewsSummaryCard extends StatelessWidget {
  const ReviewsSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller dynamically
    final controller = Provider.of<ReviewsController>(context);
    const starIcon = Icons.star_rounded; 

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 25.h), 
      padding: EdgeInsets.all(20.w), 
      decoration: BoxDecoration(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Overall Rating",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              GestureDetector(
                onTap: controller.showAllReviews, 
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10.r)),
                  child: Text("Show All", style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                controller.overallRating.toStringAsFixed(1),
                style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold, color: const Color(0xFFFFC107)), // standardised amber dynamic readability
              ),
              Text(
                " / 5.0",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              _buildLargeCountItem("${controller.totalReviews} total reviews"),
            ],
          ),
          SizedBox(height: 25.h), 
          Text(
            "Rating Breakdown",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)), // standardize dark blue standard readability
          ),
          SizedBox(height: 15.h),
          Column(
            children: [
              _buildBreakdownRow(5, controller, starIcon),
              _buildBreakdownRow(4, controller, starIcon),
              _buildBreakdownRow(3, controller, starIcon),
              _buildBreakdownRow(2, controller, starIcon),
              _buildBreakdownRow(1, controller, starIcon),
            ],
          ),
        ],
      ),
    );
  }

  // standardized MVC helper for complex breakdowns fits design patterns standard standard
  Widget _buildBreakdownRow(int starLevel, ReviewsController controller, IconData starIcon) {
    // standardized dynamic price standard linear dynamic display standard dynamic readability dynamic
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            child: Text("$starLevel★", style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: LinearProgressIndicator(
              value: controller.getStarPercentage(starLevel), 
              backgroundColor: const Color(0xFFF3F3F3), 
              color: const Color(0xFF43A047),
              minHeight: 8.h,
              borderRadius: BorderRadius.circular(5.r), 
            ),
          ),
          SizedBox(width: 15.w),
          // dynamic mvc dynamic standard count standard standard
          SizedBox(
            width: 25.w,
            child: Text(
              (controller.starCounts[starLevel] ?? 0).toString(),
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // simple helper for standardized MVC large count display standard fits design patterns standard readability standard
  Widget _buildLargeCountItem(String labelText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "6", 
          style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E)),
        ),
        Text(
          "5-Star Reviews", 
          style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}