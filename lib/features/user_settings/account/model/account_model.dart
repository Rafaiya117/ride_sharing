class UserModel {
  final String name;
  final String subtitle;
  final bool isDriverMode;
  
  // Dynamic Map for the notification switches seen in the image
  final Map<String, bool> notificationSettings;

  UserModel({
    required this.name,
    required this.subtitle,
    this.isDriverMode = false,
    required this.notificationSettings,
  });
}