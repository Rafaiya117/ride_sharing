import 'package:flutter/material.dart';
import 'package:ride_sharing/features/ride_tracking/ride_tracking_model/ride_tracking_model.dart';

class TrackRideController extends ChangeNotifier {
  // 1. Dynamic Trip Data (Mocked from image_11.png)
  String get pickup => "New York, NY";
  String get dropoff => "Boston, MA";
  double get totalDistanceMiles => 215.0; 
  Duration get totalDuration => const Duration(hours: 4, minutes: 30);
  double get price => 45.0;
  
  // 2. Dynamic Status (from image_11.png)
  String get estimatedArrival => "2h 45m";
  double get percentageComplete => 0.63;
  String get currentStatusText => "Approaching Hartford, CT";

  // 3. Dynamic Driver Data
  // ignore: prefer_final_fields
  DriverModel _driver = DriverModel(
    name: "Sarah Johnson",
    avatarPath: "assets/images/sarah_avatar.png", 
    carModel: "Honda Accord 2022",
    carPlate: "ABC 1234",
    rating: 4.8,
  );
  DriverModel get driver => _driver;

  // --- Methods ---

  void triggerEmergencySOS(BuildContext context) {
    print("EMERGENCY SOS TRIGGERED! Calling emergency services and notifying platform...");
    // GoRouter.of(context).push('/emergencyContacts');
  }

  void openChatWithDriver(BuildContext context) {
    print("Opening chat with ${driver.name}...");
    // GoRouter.of(context).push('/chat', extra: driver);
  }

  void callDriver() {
    print("Calling ${driver.name} at placeholder number...");
  }

  void shareTripWithFamily(BuildContext context) {
    print("Sharing trip tracking link with family...");
  }

  void openNotifications(BuildContext context) {
    print("Opening notifications...");
  }

  void navigateBack(BuildContext context) {
    // Navigator.pop(context);
  }
}