import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/driver_homepage/model/driver_homepage_model.dart';
import 'package:url_launcher/url_launcher.dart';

// class DriverHomeController extends ChangeNotifier {
//   int _currentNavbarIndex = 0;
//   String _userRole = 'driver'; 

//   int get currentNavbarIndex => _currentNavbarIndex;
//   String get userRole => _userRole; 

//   // FIXED: Changed from absolute fields to dynamic getters pointing to TokenStorage
//   String get driverName => TokenStorage.userName;
//   double get driverRating => TokenStorage.avgRating;
//   int get totalTrips => TokenStorage.totalTrips;

//   double monthlyEarnings = 0.0;
//   int unreadNotifications = 2;

//   // This can now remain a simple notifier punch since getters read live memory
//   void refreshHomeData() {
//     notifyListeners(); 
//   }

//   // Toggle state
//   bool _isOnline = true;
//   bool get isOnline => _isOnline;
//   bool _isToggleLoading = false;
//   bool get isToggleLoading => _isToggleLoading;

//   String rideStatus = "pending";

//   final Dio _dio = Dio();

//   // Live requests
//   final List<RideRequestModel> _rideRequests = [
//     RideRequestModel(
//       passengerName: "Michael Chen", initial: "M", rating: 4.8, 
//       pickupTimeAgo: "2 mins ago", price: 90.0, seats: 2,
//       pickupLocation: "Downtown NYC", dropoffLocation: "Boston Common",
//     ),
//     RideRequestModel(
//       passengerName: "Emma Williams", initial: "E", rating: 4.9, 
//       pickupTimeAgo: "5 mins ago", price: 45.0, seats: 1,
//       pickupLocation: "Brooklyn", dropoffLocation: "Cambridge, MA",
//     ),
//   ];
//   List<RideRequestModel> get rideRequests => _rideRequests;

//   Future<void> toggleOnlineStatus(BuildContext context, bool value) async {
//     final token = TokenStorage.accessToken;
//     if (token == null) return;

//     _isToggleLoading = true;
//     notifyListeners();

//     try {
//       final baseUrl = dotenv.env['API_BASE_URL'];
//       final url = '$baseUrl/api/v1/driver/toggle-online/'; 

//       final response = await _dio.post(
//         url,
//         data: {
//           "is_online": value,
//         },
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       final responseData = response.data;

//       if (responseData != null && responseData['success'] == true) {
//         _isOnline = responseData['data']['is_online'] ?? value;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(_isOnline ? "You are online" : "You are offline now"),
//             backgroundColor: _isOnline ? Colors.green : Colors.grey.shade800,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint("Error updating online status: ${e.toString()}");
//     } finally {
//       _isToggleLoading = false;
//       notifyListeners();
//     }
//   }

//   void setNavbarIndex(int index) {
//     _currentNavbarIndex = index;
//     notifyListeners();
//   }

//   void setUserRole(String role) {
//     _userRole = role;
//     _currentNavbarIndex = 0; 
//     notifyListeners();
//   }

//   void postNewRide() => debugPrint("Trigger dynamic post ride popup");
//   void acceptRequest(int index) {
//     _rideRequests[index].status = "accepted";
//     notifyListeners();
//   }
//   void declineRequest(int index) {
//     _rideRequests[index].status = "declined";
//     notifyListeners();
//     Future.delayed(const Duration(milliseconds: 800), () {
//       if (index < _rideRequests.length) {
//         _rideRequests.removeAt(index);
//         notifyListeners();
//       }
//     });
//   }
// }

class DriverHomeController extends ChangeNotifier {
  int _currentNavbarIndex = 0;
  String _userRole = 'driver'; 

  int get currentNavbarIndex => _currentNavbarIndex;
  String get userRole => _userRole; 

  String get driverName => TokenStorage.userName;
  double get driverRating => TokenStorage.avgRating;
  int get totalTrips => TokenStorage.totalTrips;

  double monthlyEarnings = 0.0;
  int unreadNotifications = 2;

  // FIXED: Dynamic state mapping configuration reference tracking elements
  bool get isStripeComplete => TokenStorage.stripeOnboardingComplete;
  bool _isStripeLoading = false;
  bool get isStripeLoading => _isStripeLoading;

  void refreshHomeData() {
    notifyListeners(); 
  }

  bool _isOnline = true;
  bool get isOnline => _isOnline;
  bool _isToggleLoading = false;
  bool get isToggleLoading => _isToggleLoading;

  String rideStatus = "pending";
  final Dio _dio = Dio();

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

  // FIXED: Performs the GET request to query for the Stripe Connect onboarding verification flow link web reference
  Future<void> startStripeOnboarding(BuildContext context) async {
    final token = TokenStorage.accessToken;
    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    
    if (token == null) return;

    _isStripeLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        '$baseUrl/api/v1/earnings/stripe/onboard/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final String? stripeUrl = response.data['data']['url'];
        
        if (stripeUrl != null && stripeUrl.isNotEmpty) {
          final Uri uri = Uri.parse(stripeUrl);
          
          context.push('/drive_home_screen');
          
          final bool launched = await launchUrl(
            uri, 
            mode: LaunchMode.inAppBrowserView,
          );

          if (launched) {
            debugPrint("Stripe Onboarding overlay opened natively within the app layer.");
            // FIXED: Removed the invalid getProfileData() call to resolve the compiler error
          }
        }
      }
    } catch (e) {
      debugPrint("Error handling integrated browser setup execution: $e");
    } finally {
      _isStripeLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleOnlineStatus(BuildContext context, bool value) async {
    final token = TokenStorage.accessToken;
    if (token == null) return;

    _isToggleLoading = true;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/driver/toggle-online/'; 

      final response = await _dio.post(
        url,
        data: {
          "is_online": value,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        _isOnline = responseData['data']['is_online'] ?? value;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isOnline ? "You are online" : "You are offline now"),
            backgroundColor: _isOnline ? Colors.green : Colors.grey.shade800,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error updating online status: ${e.toString()}");
    } finally {
      _isToggleLoading = false;
      notifyListeners();
    }
  }

  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }

  void setUserRole(String role) {
    _userRole = role;
    _currentNavbarIndex = 0; 
    notifyListeners();
  }

  void postNewRide() => debugPrint("Trigger dynamic post ride popup");
  
  void acceptRequest(int index) {
    _rideRequests[index].status = "accepted";
    notifyListeners();
  }
  
  void declineRequest(int index) {
    _rideRequests[index].status = "declined";
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (index < _rideRequests.length) {
        _rideRequests.removeAt(index);
        notifyListeners();
      }
    });
  }
}