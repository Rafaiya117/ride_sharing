import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/driver_homepage/model/driver_homepage_model.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Timer? _locationTimer;

  void refreshHomeData() {
    notifyListeners(); 
  }

  bool _isOnline = true;
  bool get isOnline => _isOnline;
  bool _isToggleLoading = false;
  bool get isToggleLoading => _isToggleLoading;

  String rideStatus = "pending";
  final Dio _dio = Dio();

  // final List<RideRequestModel> _rideRequests = [
  //   RideRequestModel(
  //     passengerName: "Michael Chen", initial: "M", rating: 4.8, 
  //     pickupTimeAgo: "2 mins ago", price: 90.0, seats: 2,
  //     pickupLocation: "Downtown NYC", dropoffLocation: "Boston Common", bookingId: '',
  //   ),
  //   RideRequestModel(
  //     passengerName: "Emma Williams", initial: "E", rating: 4.9, 
  //     pickupTimeAgo: "5 mins ago", price: 45.0, seats: 1,
  //     pickupLocation: "Brooklyn", dropoffLocation: "Cambridge, MA", bookingId: '',
  //   ),
  // ];
  // List<RideRequestModel> get rideRequests => _rideRequests;

  final List<RideRequestModel> _rideRequests = [];
  List<RideRequestModel> get rideRequests => _rideRequests;

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
  
  // void acceptRequest(int index) {
  //   _rideRequests[index].status = "accepted";
  //   notifyListeners();
  // }
  
  // void declineRequest(int index) {
  //   _rideRequests[index].status = "declined";
  //   notifyListeners();
  //   Future.delayed(const Duration(milliseconds: 800), () {
  //     if (index < _rideRequests.length) {
  //       _rideRequests.removeAt(index);
  //       notifyListeners();
  //     }
  //   });
  // }

  Future<void> fetchRideRequests() async {
    final String? token = TokenStorage.accessToken;
    if (token == null) return;

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

      final response = await _dio.get(
        '$baseUrl/api/v1/driver/requests/', 
        // FIXED: Removed the restrictive queryParameters filter to load ALL statuses (booked, pending, confirmed)
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // Print raw response body data immediately to diagnose connection or format mishaps
      debugPrint('!///////// ride request response data ////////// ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final List dynamicList = response.data['data']['results'] ?? [];
        
        _rideRequests.clear();
        for (var item in dynamicList) {
          _rideRequests.add(
            RideRequestModel(
              bookingId: item['id'].toString(), 
              passengerName: item['passenger_name'] ?? 'Passenger',
              initial: (item['passenger_name'] as String?)?.trim().isNotEmpty == true 
              ? item['passenger_name'].trim()[0].toUpperCase() : 'P',
              rating: double.tryParse(item['passenger_rating']?.toString() ?? '0.0') ?? 0.0,
              pickupTimeAgo: "New Request", 
              // FIXED: If negotiated_price is null, fallback to 0.0 without triggering dynamic parsing failures
              price: double.tryParse(item['negotiated_price']?.toString() ?? '') ?? 0.0,
              seats: item['seats_booked'] ?? 1,
              pickupLocation: item['pickup_location'] ?? '',
              dropoffLocation: item['drop_location'] ?? '',
            )..status = item['status'] == 'booked' ? 'pending' : (item['status'] ?? 'pending'),
          );
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching driver ride requests: $e");
    }
  }

  Future<void> handleRideRequest(int index, String action) async {
    if (index >= _rideRequests.length) return;
    
    final targetRide = _rideRequests[index];
    final String bookingId = targetRide.bookingId;
    final String? token = TokenStorage.accessToken;

    final String previousStatus = targetRide.status;

    targetRide.status = action == "accept" ? "accepted" : "declined";
    notifyListeners();

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }

      final response = await _dio.post(
        '$baseUrl/api/v1/driver/requests/$bookingId/respond/', // api/v1/driver/requests/1/respond/'
        data: {
          "action": action, 
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        debugPrint("SUCCESS: Server confirmed $action -> ${response.data['data']['message']}");
        
        // If the action was a rejection, wait a brief moment then remove it from the dashboard list
        if (action == "reject") {
          await Future.delayed(const Duration(milliseconds: 800));
          if (index < _rideRequests.length) {
            _rideRequests.removeAt(index);
            notifyListeners();
          }
        }
      } else {
        // Rollback state cleanly if backend rejects the validation rules
        targetRide.status = previousStatus;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error processing ride request ($action): $e");
      targetRide.status = previousStatus;
      notifyListeners();
    }
  }

  //!------------ location updation --------------! //

  void startLocationTracking(BuildContext context) {
    if (_locationTimer != null) return; 

    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_isOnline) return; 

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          _showLocationWarningDialog(context);
        }
        return; 
      }

      // FIXED: Verify runtime location tracking permissions cleanly
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return; // Block execution loop if explicit permission is missing
        }
      }

      final String? token = TokenStorage.accessToken;
      if (token == null) return;

      try {
        String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
        if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

        // FIXED: Dynamically pulls actual coordinates from device GPS stream instead of mock values
        Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high
        );

        final response = await _dio.post(
          '$baseUrl/api/v1/driver/location/', 
          data: {
            "latitude": position.latitude.toString(),
            "longitude": position.longitude.toString(),
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.data != null && response.data['success'] == true) {
          debugPrint("Location synced dynamically: [${position.latitude}, ${position.longitude}]");
        }
      } catch (e) {
        debugPrint("Error pushing background location telemetry packet: $e");
      }
    });
  }

  // FIXED: Clean non-blocking reminder overlay demanding driver interaction
  void _showLocationWarningDialog(BuildContext context) {
    // Avoid layering duplicate alerts over each other if already visible
    if (ModalRoute.of(context)?.isCurrent == false) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Location Service Required", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text("You must enable high-accuracy device location tracking to accept and drive client requests properly."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings(); // Drops down phone notification overlay settings automatically
            },
            child: Text("Turn On", style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}