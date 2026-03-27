import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacySecurityContainer extends StatelessWidget {
  final List<Widget> children;

  const PrivacySecurityContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFA2A2A2), // Requested Color
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index != children.length - 1)
                Divider(height: 1, color: Colors.white.withOpacity(0.2)),
            ],
          );
        }),
      ),
    );
  }

  // Helper for Toggle Rows (e.g., Share Location)
  static Widget buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13.sp)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF00D261),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }

  // Helper for Navigation Rows (e.g., Change Password)
  static Widget buildNavRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24.r),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13.sp)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.r),
          ],
        ),
      ),
    );
  }
}