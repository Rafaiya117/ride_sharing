import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/driver_profile/driver_profile_model/driver_profile_model.dart';

class DriverProfileController extends ChangeNotifier {
  late DriverProfileModel _profile;
  DriverProfileModel get profile => _profile;

  DriverProfileController() {
    _mockInitialData();
  }

  void _mockInitialData() {
    _profile = DriverProfileModel(
      name: "John Doe",
      email: "safimahmud1412@gmail.com",
      initials: "J",
      totalTrips: 45,
      rating: 4.8,
      isVerified: true,
      carModel: "Honda Accord 2022",
      plateNumber: "ABC-123",
      color: "Black",
      availableSeats: 4,
    );
  }

  // Navigation methods
  void navigateToEdit(BuildContext context) => debugPrint("Edit Profile");
  void navigateToHistory(BuildContext context) => debugPrint("Trip History");
  void navigateToReviews(BuildContext context) => debugPrint("Reviews");
  void navigateToEarnings(BuildContext context) => debugPrint("Earnings");
  void navigateToPayments(BuildContext context) => debugPrint("Payments");
}