import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/trip_card_container.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("${controller.completedTrips.length} trips completed"),
          ListView.builder(
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: controller.completedTrips.length,
            itemBuilder: (context, index) {
              final trip = controller.completedTrips[index];
              return HistoryTripCard(trip: trip);
            },
          ),
          SizedBox(height: 10.h), 
        ],
      ),
    );
  }

  // --- Header/Nav replicated precisely from image ---
  Widget _buildHeaderTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back", style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
            Text("Safi", style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            Stack(children: [
              Icon(Icons.notifications_none, color: Colors.white, size: 28.r),
              Positioned(right: 2, top: 2, child: Container(width: 8.r, height: 8.r, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
            ]),
            SizedBox(width: 15.w),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person_outline, color: Colors.white, size: 20.r),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700)),
    );
  }
}