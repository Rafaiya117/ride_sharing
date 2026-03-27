import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/driver_homepage/model/driver_homepage_model.dart';

class DriverHomeController extends ChangeNotifier {
  // Mock Driver Data matching the UI
  String driverName = "Safi";
  double driverRating = 4.9;
  int totalTrips = 156;
  double monthlyEarnings = 2000.0;
  int unreadNotifications = 2;

  // Toggle state
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  // Live requests
  final List<RideRequestModel> _rideRequests = [
    RideRequestModel(
      passengerName: "Michael Chen", initial: "M", rating: 4.8, 
      pickupTimeAgo: "2 mins ago", price: 90.0, seats: 2,
      pickupLocation: "Downtown NYC", dropoffLocation: "Boston Common",
    ),
    RideRequestModel(
      passengerName: "Emma Williams", initial: "E", rating: 4.9, 
      pickupTimeAgo: "5 mins ago", price: 45.0, seats: 1,
      pickupLocation: "Brooklyn", dropoffLocation: "Cambridge, MA",
    ),
  ];
  List<RideRequestModel> get rideRequests => _rideRequests;

  // --- Actions ---
  void toggleOnlineStatus(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  void postNewRide() => debugPrint("Trigger dynamic post ride popup");
  void acceptRequest(int index) => debugPrint("Accepting dynamic request $index");
  void declineRequest(int index) {
    _rideRequests.removeAt(index);
    notifyListeners();
  }
}