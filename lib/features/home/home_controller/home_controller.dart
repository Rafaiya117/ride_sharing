// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/home/model/home_model.dart';

class HomeController extends ChangeNotifier {
  // 1. Dynamic User Data (Mocked)
  String _userName = "Safi";
  UserStats _stats = UserStats(trips: 24, rating: 4.8, upcoming: 1);
  UpcomingTrip _nextTrip = UpcomingTrip(
    pickup: "New York, NY", dropoff: "Boston, MA", 
    date: "Mar 6, 2026", time: "09:00 AM", pricePerSeat: 45.0, 
    driverName: "Sarah Johnson", carModel: "Honda Accord 2022"
  );

  // 2. Planning Inputs
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  
  // 3. Navbar State
  int _currentNavbarIndex = 0;

  // Getters
  String get userName => _userName;
  UserStats get stats => _stats;
  UpcomingTrip get nextTrip => _nextTrip;
  int get currentNavbarIndex => _currentNavbarIndex;

  // --- Methods ---
  
  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }

  void searchRides(BuildContext context) {
    String from = pickupController.text.trim();
    String to = dropoffController.text.trim();
    print("Searching rides from $from to $to...");
    GoRouter.of(context).push('/search_ride_screen');
  }

  void trackTrip(BuildContext context, UpcomingTrip trip) {
    print("Tracking trip: ${trip.pickup} to ${trip.dropoff} with ${trip.driverName}...");
    // GoRouter.of(context).push('/trackingMap');
  }

  void shareTripWithFamily(BuildContext context) {
    print("Sharing trip details...");
    // Implement share dialog
  }

  void openNotifications(BuildContext context) {
    print("Opening notifications...");
    // GoRouter.of(context).push('/notifications');
  }

  void openProfile(BuildContext context) {
    print("Opening profile...");
    // GoRouter.of(context).push('/profile');
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    super.dispose();
  }
}