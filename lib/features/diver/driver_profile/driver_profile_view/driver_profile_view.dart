import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/diver/driver_profile/driver_profile_controller/driver_profile_controller.dart';

class DriverProfileView extends StatelessWidget {
  const DriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverProfileController>();
    final profile = controller.profile;

    return BaseScaffold(
      title: "Profile",
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () => controller.navigateToEdit(context),
        ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Avatar
            CircleAvatar(
              radius: 45.r,
              backgroundColor: const Color(0xFF1E283A),
              child: Text(profile.initials, style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 15.h),
            Text(profile.name, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            Text(profile.email, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
            SizedBox(height: 12.h),

            // Verification Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(color: const Color(0xFFF3F8F3), borderRadius: BorderRadius.circular(20.r)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined, color: Colors.green, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text("Verified Passenger", style: TextStyle(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            // Stat Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(Icons.location_on_outlined, "${profile.totalTrips}", "Trips"),
                _buildStatItem(Icons.star_outline, "${profile.rating}", "Rating"),
              ],
            ),
            SizedBox(height: 30.h),

            // Vehicle Information Card
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_car_outlined, size: 24.sp, color: Colors.grey[700]),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.carModel, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                          Text(profile.plateNumber, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildVehicleDetail("Color", profile.color),
                      _buildVehicleDetail("Seats", "${profile.availableSeats} available"),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30.h),
            Align(alignment: Alignment.centerLeft, child: Text("Quick Actions", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold))),
            SizedBox(height: 15.h),

            // Quick Actions List
            _buildActionTile(Icons.access_time, "Trip History", () => controller.navigateToHistory(context)),
            _buildActionTile(Icons.star_outline, "Reviews", () => controller.navigateToReviews(context)),
            _buildActionTile(Icons.trending_up, "Earnings", () => controller.navigateToEarnings(context)),
            _buildActionTile(Icons.credit_card_outlined, "Payment Methods", () => controller.navigateToPayments(context)),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(color: Colors.grey[50]!, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.black, size: 24.sp),
        ),
        SizedBox(height: 8.h),
        Text(value, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVehicleDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
        Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1E283A)),
        title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, size: 20.sp, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}