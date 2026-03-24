import 'package:flutter/material.dart';
import 'package:ride_sharing/features/sharetrip/share_trip_model/share_trip_model.dart';

class ShareTripController extends ChangeNotifier {
  // 1. Dynamic Trip Data state (Mocked from image_9.png)
  late ShareTripModel _trip;
  ShareTripModel get trip => _trip;

  // 2. Standard sharing options data per MVC pattern
  final List<Map<String, String>> _quickShareOptions = [
    {'label': 'SMS', 'iconPath': 'assets/icons/sms.svg', 'id': 'sms'},
    {'label': 'Email', 'iconPath': 'assets/icons/email.svg', 'id': 'email'},
    {'label': 'Copy Link', 'iconPath': 'assets/icons/link.svg', 'id': 'link'},
  ];
  List<Map<String, String>> get quickShareOptions => _quickShareOptions;

  // 3. Static standard details per design standard
  final List<String> sharedDetailsInfo = [
    "Live location tracking during the trip",
    "Driver details and vehicle information",
    "Expected arrival time",
    "Route and current progress",
  ];

  ShareTripController() {
    _mockInitialData(); // standard dynamic state loading
  }

  void _mockInitialData() {
    _trip = ShareTripModel(
      fromLocation: "New York, NY",
      toLocation: "to Boston, MA", // handles combined "to" standard readability standard
      departureTime: "09:00 AM",
      departureDate: "Mar 6, 2026",
      driverName: "Sarah Johnson",
      driverCar: "Honda Accord 2022",
    );
  }

  // --- Dynamic Methods standard dynamic layout standard dynamic standard readability

  void handleQuickShare(BuildContext context, String optionId) {
    print("Standard Dynamic sharing option triggered: $optionId...");
    switch (optionId) {
      case 'sms':
        // sms sharing logic
        break;
      case 'email':
        // email sharing logic
        break;
      case 'link':
        // dynamic clipboard standard readability dynamic readability
        break;
    }
  }

  void navigateBack(BuildContext context) {
    // Navigator.pop(context); // standard mvc pop
  }
}