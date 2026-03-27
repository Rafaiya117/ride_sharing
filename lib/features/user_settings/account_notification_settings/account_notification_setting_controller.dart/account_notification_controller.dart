import 'package:flutter/material.dart';

class ProfileSettingsController extends ChangeNotifier {
  // Notification States
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool smsNotifications = true;
  bool tripReminders = true;
  bool promotionalOffers = false;

  // Privacy States
  bool shareLocation = true;
  bool showProfile = true;

  void togglePush(bool val) { pushNotifications = val; notifyListeners(); }
  void toggleEmail(bool val) { emailNotifications = val; notifyListeners(); }
  void toggleSms(bool val) { smsNotifications = val; notifyListeners(); }
  void toggleReminders(bool val) { tripReminders = val; notifyListeners(); }
  void togglePromos(bool val) { promotionalOffers = val; notifyListeners(); }
  
  void toggleLocation(bool val) { shareLocation = val; notifyListeners(); }
  void toggleProfile(bool val) { showProfile = val; notifyListeners(); }
}