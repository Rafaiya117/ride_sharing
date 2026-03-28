import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/user_settings/account/controller/account_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AccountController>();

    return BaseScaffold(
      // 1. --- Custom Header Title ---
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome back", 
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 14.sp)),
              Text("Safi", 
                style: GoogleFonts.inter(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              _buildNotificationIcon(),
              SizedBox(width: 15.w),
              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person_outline, color: Colors.white, size: 20.r),
              ),
            ],
          ),
        ],
      ),

      // 2. --- Header Background Pattern ---
      headerBackground: Opacity(
        opacity: 0.1,
        child: Image.asset(
          'assets/images/pattern_bg.png', 
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),

      // 3. --- Body Content ---
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDriverModeBanner(),
          SizedBox(height: 25.h),
          
          _sectionLabel("ACCOUNT"),
          _buildGroupedCard([
            _buildListTile(Icons.person_outline, "Profile Settings"),
            _buildListTile(Icons.credit_card_outlined, "Payment Methods"),
          ]),

          _sectionLabel("NOTIFICATIONS"),
          _buildGroupedCard([
            _buildSwitchTile("Push Notifications", controller.pushNotifications, controller.togglePush),
            _buildSwitchTile("Ride Updates", controller.rideUpdates, controller.toggleRide),
            _buildSwitchTile("Promotional Offers", controller.promotionalOffers, controller.togglePromo),
            _buildSwitchTile("Email Notifications", controller.emailNotifications, controller.toggleEmail),
          ]),

          _sectionLabel("SAFETY & SECURITY"),
          _buildGroupedCard([
            _buildListTile(Icons.phone_outlined, "Emergency Contacts"),
            _buildSwitchTile("Share Trip Automatically", controller.shareAutomatically, controller.toggleShare),
          ]),

          _sectionLabel("SUPPORT"),
          _buildGroupedCard([
            _buildListTile(Icons.description_outlined, "Terms of Service"),
            _buildListTile(Icons.lock_outline, "Privacy Policy"),
          ]),

          SizedBox(height: 30.h),
          _buildLogoutButton(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  // --- UI Components Replicated from Image ---

  Widget _buildDriverModeBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF2B58A1), Color(0xFF142850)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, color: Colors.white, size: 22.r),
          SizedBox(width: 12.w),
          Text("Switch to Driver Mode", 
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
          const Spacer(),
          CircleAvatar(
            radius: 12.r,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 14.r),
          )
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 10.h, top: 5.h),
      child: Text(text, 
        style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 0.5)),
    );
  }

  Widget _buildGroupedCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom:20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index != children.length - 1) 
                Divider(height: 1, indent: 50.w, color: Colors.grey.shade100),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22.r),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 14.r, color: Colors.grey.shade400),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      onTap: () {},
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(
        title.contains("Notifications") || title.contains("Updates") ? Icons.notifications_none : Icons.shield_outlined, 
        color: Colors.black87, size: 22.r
      ),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value, 
        onChanged: onChanged,
        activeColor: Colors.black,
        activeTrackColor: Colors.black12,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text("Log Out", 
          style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16.sp)),
        style: TextButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.h)),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        Icon(Icons.notifications_none, color: Colors.white, size: 28.r),
        Positioned(
          right: 2, top: 2,
          child: Container(
            width: 8.r, height: 8.r,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
        )
      ],
    );
  }
}