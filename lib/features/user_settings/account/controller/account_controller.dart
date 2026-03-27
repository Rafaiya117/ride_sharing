import 'package:flutter/material.dart';


class AccountController extends ChangeNotifier {
  bool _pushNotifications = true;
  bool _rideUpdates = true;
  bool _promotionalOffers = false;
  bool _emailNotifications = true;
  bool _shareAutomatically = false;

  // Getters
  bool get pushNotifications => _pushNotifications;
  bool get rideUpdates => _rideUpdates;
  bool get promotionalOffers => _promotionalOffers;
  bool get emailNotifications => _emailNotifications;
  bool get shareAutomatically => _shareAutomatically;

  // Setters
  void togglePush(bool val) { _pushNotifications = val; notifyListeners(); }
  void toggleRide(bool val) { _rideUpdates = val; notifyListeners(); }
  void togglePromo(bool val) { _promotionalOffers = val; notifyListeners(); }
  void toggleEmail(bool val) { _emailNotifications = val; notifyListeners(); }
  void toggleShare(bool val) { _shareAutomatically = val; notifyListeners(); }
}