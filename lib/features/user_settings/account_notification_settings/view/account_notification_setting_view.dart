import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_notification_container.dart';
import 'package:ride_sharing/core/components/custom_privacy_security_container.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/user_settings/account_notification_settings/account_notification_setting_controller.dart/account_notification_controller.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileSettingsController>();

    return BaseScaffold(
      // 1. --- Black Header with Back Button ---
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 24.r),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Profile Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 24.w), // Spacer to balance back button
        ],
      ),
      headerBackground: Opacity(
        opacity: 0.1,
        child: Image.asset('assets/images/pattern_bg.png', fit: BoxFit.cover),
      ),
      
      // 2. --- Body Content ---
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.notifications_none, "Notifications"),
          NotificationsGroupContainer(
            items: [
              NotificationItemModel(
                title: "Push Notifications",
                subtitle: "Receive push notifications on your device",
                isEnabled: controller.pushNotifications,
                onChanged: controller.togglePush,
              ),
              NotificationItemModel(
                title: "Email Notifications",
                subtitle: "Get updates via email",
                isEnabled: controller.emailNotifications,
                onChanged: controller.toggleEmail,
              ),
              NotificationItemModel(
                title: "SMS Notifications",
                subtitle: "Receive text message updates",
                isEnabled: controller.smsNotifications,
                onChanged: controller.toggleSms,
              ),
              NotificationItemModel(
                title: "Trip Reminders",
                subtitle: "Get reminded about upcoming trips",
                isEnabled: controller.tripReminders,
                onChanged: controller.toggleReminders,
              ),
              NotificationItemModel(
                title: "Promotional Offers",
                subtitle: "Receive special offers and discounts",
                isEnabled: controller.promotionalOffers,
                onChanged: controller.togglePromos,
              ),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          _buildSectionHeader(Icons.shield_outlined, "Privacy & Security"),
          PrivacySecurityContainer(
            children: [
              PrivacySecurityContainer.buildToggleRow(
                title: "Share Location",
                subtitle: "Allow location sharing during trips",
                value: controller.shareLocation,
                onChanged: controller.toggleLocation,
              ),
              PrivacySecurityContainer.buildToggleRow(
                title: "Show Profile",
                subtitle: "Make profile visible to others",
                value: controller.showProfile,
                onChanged: controller.toggleProfile,
              ),
              PrivacySecurityContainer.buildNavRow(
                icon: Icons.lock_outline,
                title: "Change Password",
                subtitle: "Update your password",
                onTap: () => print("Navigate to Change Password"),
              ),
            ],
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: Colors.black),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}