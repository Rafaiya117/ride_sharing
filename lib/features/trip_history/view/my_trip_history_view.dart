import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/trip_card_container.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/core/utils/bottom_nav.dart';
import 'package:ride_sharing/features/trip_history/controller/my_trip_history_controller.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer pattern to react to controller changes
    final controller = context.watch<TripHistoryController>();

    return BaseScaffold(
      title: _buildHeaderTitle(),
      headerBackground: Opacity(
        opacity: 0.1,
        child: Image.asset(
          'assets/images/pattern_bg.png', // The standard hex pattern
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
      // FIXED: Added the global custom navigation bar widget instance tracking state
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: controller.currentNavbarIndex,
        onTap: (index) => controller.setNavbarIndex(index),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("${controller.completedTrips.length} trips completed"),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: controller.completedTrips.length,
            itemBuilder: (context, index) {
              final trip = controller.completedTrips[index];
              return HistoryTripCard(trip: trip);
            },
          ),
          SizedBox(height: 20.h), 
        ],
      ),
    );
  }

  // --- Header Redesigned Precisely from Image ---
  // FIXED: Removed profile tiles to render the clean standalone bold "History" title
  Widget _buildHeaderTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        "History",
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // FIXED: Configured font styling configurations matching layout frame guidelines
  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
      child: Text(
        title, 
        style: GoogleFonts.inter(
          fontSize: 14.sp, 
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}