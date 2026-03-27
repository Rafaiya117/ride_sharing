import 'package:flutter/material.dart';
import 'package:ride_sharing/features/notification/notification_model/notification_model.dart';

class NotificationsController extends ChangeNotifier {
  List<NotificationModel> notifications = [
    NotificationModel(
      title: "Ride Confirmed",
      description: "Your ride to Boston has been confirmed. Departure at 9:00 AM tomorrow.",
      time: "2 hours ago",
      type: NotificationType.ride,
      isRead: false,
    ),
    NotificationModel(
      title: "Trip Reminder",
      description: "Your ride to Boston starts in 24 hours. Make sure you're ready!",
      time: "5 hours ago",
      type: NotificationType.reminder,
      isRead: false,
    ),
    NotificationModel(
      title: "Special Offer",
      description: "Get 20% off your next 3 rides! Use code RIDE20",
      time: "1 day ago",
      type: NotificationType.offer,
      isRead: true,
    ),
    NotificationModel(
      title: "New Message",
      description: "Sarah Johnson sent you a message about pickup location.",
      time: "2 days ago",
      type: NotificationType.message,
      isRead: true,
    ),
    NotificationModel(
      title: "Rating Request",
      description: "How was your ride with Jennifer Lee? Rate your experience.",
      time: "1 week ago",
      type: NotificationType.rating,
      isRead: true,
    ),
  ];

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }
}