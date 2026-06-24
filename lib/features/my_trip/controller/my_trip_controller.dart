import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/my_trip/model/my_trip_model.dart';

// class MyTripsController extends ChangeNotifier {
//   int _currentNavbarIndex = 1;
//   int get currentNavbarIndex => _currentNavbarIndex;

//   void setNavbarIndex(int index) {
//     _currentNavbarIndex = index;
//     notifyListeners();
//   }
//   // Mock Data
//   final TripModel bookingTrip = TripModel(
//     driverName: "Sarah Johnson",
//     date: "Mar 6, 2026",
//     time: "09:00 AM",
//     pickup: "New York, NY",
//     dropoff: "Boston, MA",
//     price: "45",
//     durationOrCar: "4h 30m",
//     rating: 4.9,
//     isUpcoming: true,
//   );

//   final TripModel activeTrip = TripModel(
//     driverName: "Sarah Johnson",
//     date: "Mar 6, 2026",
//     time: "09:00 AM",
//     pickup: "New York, NY",
//     dropoff: "Boston, MA",
//     price: "45",
//     durationOrCar: "Honda Accord 2022",
//     rating: 4.9,
//   );

//   void cancelBooking() {
//     // Add cancellation logic
//     print("Booking Cancelled");
//   }

//   void trackTrip() {
//     // Add tracking navigation logic
//     print("Navigating to Tracking");
//   }
// }

class MyTripsController extends ChangeNotifier {
  int _currentNavbarIndex = 1;
  int get currentNavbarIndex => _currentNavbarIndex;

  final Dio _dio = Dio();
  List<TripModel> _allTrips = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasFetched = false;

  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }

  List<TripModel> get bookingTrips => _allTrips.where((trip) => trip.status == 'booked').toList();
  List<TripModel> get activeTrips => _allTrips.where((trip) => trip.status == 'accepted' && trip.timelineStatus == 'ongoing').toList();

  Future<void> fetchMyTrips() async {
    if (_isLoading || _hasFetched) return;
    
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }
      
      final String? token = TokenStorage.accessToken;
      final response = await _dio.get(
        '$baseUrl/api/v1/passenger/my-bookings/', 
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        debugPrint('!====== my trip ${response.data} ========!');
        final Map<String, dynamic> dataMap = response.data['data'] is Map 
        ? response.data['data'] : {};            
        final List rawList = dataMap['results'] ?? [];
        _allTrips = rawList.map((json) => TripModel.fromJson(json)).toList();
        
        _hasFetched = true; 
      }
    } catch (e) {
      debugPrint("Error loading passenger trip history lists: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void cancelBooking() {
    print("Booking Cancelled");
  }

  void trackTrip() {
    print("Navigating to Tracking");
  }
}