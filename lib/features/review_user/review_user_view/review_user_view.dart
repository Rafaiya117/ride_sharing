import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/review_tile_widget.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/review_user/review_user_controller/review_user_controller.dart';
import 'package:ride_sharing/features/review_user/widget/review_summary_card.dart';

class ReviewsView extends StatelessWidget {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ReviewsController>(context);
    const iconColor = Colors.white;

    return BaseScaffold(
      title: "Reviews", 
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: iconColor),
        onPressed: () => controller.navigateBack(context),
      ),
      child: Column(
        children: [
          const ReviewsSummaryCard(),
          _buildSectionTitle("All Reviews"),
          // Removed the manual SizedBox here if your _buildSectionTitle already has one
          ListView.builder(
            padding: EdgeInsets
                .zero, // FIX: Removes the default top/bottom list padding
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.reviews.length,
            itemBuilder: (context, index) {
              final review = controller.reviews[index];
              return ReviewTileWidget(review: review);
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp, 
          fontWeight: FontWeight.bold, 
          color: const Color(0xFF1E1E1E),
        ),
      ),
    );
  }
}