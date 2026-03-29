import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/filterpill_card.dart';
import 'package:ride_sharing/core/components/ride_result_card.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/search/controller/search_ride_controller.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the specific controller via Provider
    final controller = context.watch<SearchResultsController>();

    final filters = ["Lowest Price", "Earliest", "Top Rated"];

    return BaseScaffold(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Available Rides",
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "${controller.fromLocation} → ${controller.toLocation}",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.navigateBack(context),
      ),
      // --- BODY CONTENT ---
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. --- Dynamic Filter/Sort Pills ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: filters.map((filter) {
                return FilterPill(
                  text: filter,
                  isSelected: controller.selectedFilter == filter,
                  onTap: () => controller.setFilter(filter),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.h),

          // 2. --- Dynamic Rides Found Header ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${controller.results.length} rides found",
                style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              // Conditional dynamic filter text from image_7.png
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/thunder.svg', // Your SVG path
                    width: 14.r,
                    height: 14.r,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w), // Space between icon and text
                  Text(
                    "Live results",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: controller.results.length,
            itemBuilder: (context, index) {
              final ride = controller.results[index];
              return RideResultCard(
                ride: ride,
                onTap: () => controller.openRideDetails(context, ride),
              );
            },
          ),
          SizedBox(height: 10.h), 
        ],
      ),
    );
  }
}