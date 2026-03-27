enum NotificationType { ride, reminder, offer, message, rating }

class NotificationModel {
  final String title;
  final String description;
  final String time;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}