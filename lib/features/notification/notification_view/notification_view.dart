import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/notification/notification_controller/notification_controller.dart';
import 'package:ride_sharing/features/notification/notification_model/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NotificationsController>();

    return BaseScaffold(
      // Move both title and subtitle into a Column within the title parameter
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Notifications",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${controller.unreadCount} new notifications",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      titleAlign: TextAlign.left,
      isCurved: true,
      actions: [
        TextButton(
          onPressed: () => controller.markAllAsRead(),
          child: Text(
            "Mark all read",
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ),
      ],
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        itemCount: controller.notifications.length,
        itemBuilder: (context, index) {
          return _NotificationTile(notification: controller.notifications[index]);
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: notification.isRead ? Colors.grey.shade100 : Colors.black,
          width: notification.isRead ? 1 : 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic Icon
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: _getIconColor(notification.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(notification.type), 
                 color: _getIconColor(notification.type), size: 20.sp),
          ),
          SizedBox(width: 15.w),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.description,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700], height: 1.4),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      notification.time,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.ride: return Icons.check_circle_outline;
      case NotificationType.reminder: return Icons.access_time;
      case NotificationType.offer: return Icons.local_offer_outlined;
      case NotificationType.message: return Icons.chat_bubble_outline;
      case NotificationType.rating: return Icons.chat_bubble_outline;
    }
  }

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.ride: return Colors.green;
      case NotificationType.reminder: return Colors.blue;
      case NotificationType.offer: return Colors.purple;
      case NotificationType.message: return Colors.grey;
      case NotificationType.rating: return Colors.grey;
    }
  }
}