import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const SupportOptionTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10.r)),
        child: Icon(icon, color: iconColor, size: 22.r),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
      trailing: Icon(Icons.arrow_forward_ios, size: 14.r, color: Colors.grey),
      onTap: () {},
    );
  }
}