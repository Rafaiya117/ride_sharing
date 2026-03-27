import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsGroupContainer extends StatelessWidget {
  final List<NotificationItemModel> items;

  const NotificationsGroupContainer({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFA2A2A2), // Requested Color
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[index].title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            items[index].subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: items[index].isEnabled,
                      onChanged: items[index].onChanged,
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF00D261), // Green from image
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFF4A4A4A), // Dark grey from image
                    ),
                  ],
                ),
              ),
              // Divider logic to match the image exactly
              if (index != items.length - 1)
                Divider(height: 1, color: Colors.white.withOpacity(0.2)),
            ],
          );
        }),
      ),
    );
  }
}

class NotificationItemModel {
  final String title;
  final String subtitle;
  final bool isEnabled;
  final Function(bool) onChanged;

  NotificationItemModel({
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    required this.onChanged,
  });
}