// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/home/model/home_model.dart';

// class HomeController extends ChangeNotifier {
//   // 1. Dynamic User Data (Mocked)
//   String _userName = "Safi";
//   UserStats _stats = UserStats(trips: 24, rating: 4.8, upcoming: 1);
//   UpcomingTrip _nextTrip = UpcomingTrip(
//     pickup: "New York, NY", dropoff: "Boston, MA", 
//     date: "Mar 6, 2026", time: "09:00 AM", pricePerSeat: 45.0, 
//     driverName: "Sarah Johnson", carModel: "Honda Accord 2022"
//   );

//   // 2. Planning Inputs
//   final TextEditingController pickupController = TextEditingController();
//   final TextEditingController dropoffController = TextEditingController();
  
//   // 3. Navbar State
//   int _currentNavbarIndex = 0;
//   int get currentNavbarIndex => _currentNavbarIndex;
//   // Getters
//   String get userName => _userName;
//   UserStats get stats => _stats;
//   UpcomingTrip get nextTrip => _nextTrip;
  

//   // --- Methods ---
  
//   void setNavbarIndex(int index) {
//     _currentNavbarIndex = index;
//     notifyListeners();
//   }

//   // void searchRides(BuildContext context) {
//   //   String from = pickupController.text.trim();
//   //   String to = dropoffController.text.trim();
//   //   print("Searching rides from $from to $to...");
//   //   GoRouter.of(context).push('/search_ride_screen');
//   // }

//   void searchRides(BuildContext context) {
//     String from = pickupController.text.trim();
//     String to = dropoffController.text.trim();
//     String date = "2026-06-19"; 
//     int seats = 1;

//     if (from.isEmpty || to.isEmpty) return;
//     print("Searching rides from $from to $to...");
//     context.push('/search_ride_screen?pickup_location=$from&drop_location=$to&date=$date&seats=$seats');
//   }

//   void trackTrip(BuildContext context, UpcomingTrip trip) {
//     print("Tracking trip: ${trip.pickup} to ${trip.dropoff} with ${trip.driverName}...");
//     GoRouter.of(context).push('/ride_tracking');
//   }

//   void shareTripWithFamily(BuildContext context) {
//     print("Sharing trip details...");
//     // Implement share dialog
//   }

//   void openNotifications(BuildContext context) {
//     print("Opening notifications...");
//     // GoRouter.of(context).push('/notifications');
//   }

//   void openProfile(BuildContext context) {
//     print("Opening profile...");
//     GoRouter.of(context).push('/profile_screen');
//   }

//   @override
//   void dispose() {
//     pickupController.dispose();
//     dropoffController.dispose();
//     super.dispose();
//   }
// }

// class HomeController extends ChangeNotifier {
//   String get userName => TokenStorage.userData?['name'] ?? "User";
  
//   UserStats get stats => UserStats(
//     trips: TokenStorage.userData?['total_trips'] ?? 0,
//     rating: double.tryParse((TokenStorage.userData?['avg_rating'] ?? '0.0').toString()) ?? 0.0,
//     upcoming: 1, // Retained fallback design variable
//   );

//   UpcomingTrip _nextTrip = UpcomingTrip(
//     pickup: "New York, NY", dropoff: "Boston, MA", 
//     date: "Mar 6, 2026", time: "09:00 AM", pricePerSeat: 45.0, 
//     driverName: "Sarah Johnson", carModel: "Honda Accord 2022"
//   );

//   // 2. Planning Inputs
//   final TextEditingController pickupController = TextEditingController();
//   final TextEditingController dropoffController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController seatController = TextEditingController();
//   // 3. Navbar State
//   int _currentNavbarIndex = 0;
//   int get currentNavbarIndex => _currentNavbarIndex;
  
//   // Getters
//   UpcomingTrip get nextTrip => _nextTrip;

//   // --- Methods ---
//   void setNavbarIndex(int index) {
//     _currentNavbarIndex = index;
//     notifyListeners();
//   }

//   void searchRides(BuildContext context) {
//     String from = pickupController.text.trim();
//     String to = dropoffController.text.trim();
//     String rawDate = dateController.text.trim(); 
//     int seats = int.tryParse(seatController.text.trim()) ?? 1;

//     if (from.isEmpty || to.isEmpty) return;
//     String formattedDate = rawDate;
//     if (rawDate.isNotEmpty && rawDate.contains('/')) {
//       final parts = rawDate.split('/');
//       if (parts.length == 3) {
//         formattedDate = "${parts[2]}-${parts[0]}-${parts[1]}";
//       }
//     }

//     print("Searching rides from $from to $to on date: $formattedDate...");
//     context.push('/search_ride_screen?pickup_location=$from&drop_location=$to&date=$formattedDate&seats=$seats');
//   }

//   void trackTrip(BuildContext context, UpcomingTrip trip) {
//     print("Tracking trip: ${trip.pickup} to ${trip.dropoff} with ${trip.driverName}...");
//     GoRouter.of(context).push('/ride_tracking');
//   }

//   void shareTripWithFamily(BuildContext context) {
//     print("Sharing trip details...");
//   }

//   void openNotifications(BuildContext context) {
//     print("Opening notifications...");
//   }

//   void openProfile(BuildContext context) {
//     print("Opening profile...");
//     GoRouter.of(context).push('/profile_screen');
//   }

//   @override
//   void dispose() {
//     pickupController.dispose();
//     dropoffController.dispose();
//     super.dispose();
//   }
// }

class HomeController extends ChangeNotifier {
  String get userName => TokenStorage.userData?['name'] ?? "User";
  
  UserStats get stats => UserStats(
    trips: TokenStorage.userData?['total_trips'] ?? 0,
    rating: double.tryParse((TokenStorage.userData?['avg_rating'] ?? '0.0').toString()) ?? 0.0,
    upcoming: 1, // Retained fallback design variable
  );

  UpcomingTrip _nextTrip = UpcomingTrip(
    pickup: "New York, NY", dropoff: "Boston, MA", 
    date: "Mar 6, 2026", time: "09:00 AM", pricePerSeat: 45.0, 
    driverName: "Sarah Johnson", carModel: "Honda Accord 2022"
  );

  // 2. Planning Inputs
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController seatController = TextEditingController();
  // 3. Navbar State
  int _currentNavbarIndex = 0;
  int get currentNavbarIndex => _currentNavbarIndex;
  
  // Getters
  UpcomingTrip get nextTrip => _nextTrip;

  // --- Methods ---
  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }

  // FIXED: Added method to cleanly erase input text memory values when required
  void clearInputs() {
    pickupController.clear();
    dropoffController.clear();
    dateController.clear();
    seatController.clear();
    notifyListeners();
  }

  void searchRides(BuildContext context) {
    String from = pickupController.text.trim();
    String to = dropoffController.text.trim();
    String rawDate = dateController.text.trim(); 
    int seats = int.tryParse(seatController.text.trim()) ?? 1;

    if (from.isEmpty || to.isEmpty) return;
    String formattedDate = rawDate;
    if (rawDate.isNotEmpty && rawDate.contains('/')) {
      final parts = rawDate.split('/');
      if (parts.length == 3) {
        formattedDate = "${parts[2]}-${parts[0]}-${parts[1]}";
      }
    }

    print("Searching rides from $from to $to on date: $formattedDate...");
    context.push('/search_ride_screen?pickup_location=$from&drop_location=$to&date=$formattedDate&seats=$seats');
  }

  void trackTrip(BuildContext context, UpcomingTrip trip) {
    print("Tracking trip: ${trip.pickup} to ${trip.dropoff} with ${trip.driverName}...");
    GoRouter.of(context).push('/ride_tracking');
  }

  void shareTripWithFamily(BuildContext context) {
    print("Sharing trip details...");
  }

  void openNotifications(BuildContext context) {
    print("Opening notifications...");
  }

  void openProfile(BuildContext context) {
    print("Opening profile...");
    GoRouter.of(context).push('/profile_screen');
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    // FIXED: Added remaining controllers to avoid memory leaks completely
    dateController.dispose();
    seatController.dispose();
    super.dispose();
  }
}