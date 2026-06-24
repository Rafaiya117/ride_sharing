import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/drive_trip/driver_trip_model/driver_trip_model.dart';

// class DriverTripController extends ChangeNotifier {
//   int _currentNavbarIndex = 0;
//   int get currentNavbarIndex => _currentNavbarIndex;

//   PostedRideModel? postedRide = PostedRideModel(
//     id: '123',
//     from: "Dhaka",
//     to: "Khulna",
//     date: "Mar 10, 2026",
//     time: "22:52",
//     pricePerSeat: "50",
//     seats: "1/1",
//     postedDate: "Mar 9, 2026",
//   );

//   ActiveTripModel? activeTrip = ActiveTripModel(
//     id: '456',
//     date: "Mar 6, 2026",
//     pickup: "New York, NY",
//     destination: "Boston, MA",
//     passengerName: "Sarah Johnson",
//     rating: 4.9,
//     price: 45,
//     duration: "4h 30m",
//   );

//   void setNavbarIndex(int index) {
//     _currentNavbarIndex = index;
//     notifyListeners();
//   }
// }

class DriverTripController extends ChangeNotifier {
  int _currentNavbarIndex = 0;
  int get currentNavbarIndex => _currentNavbarIndex;

  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasFetched = false;

  PostedRideModel? postedRide;
  ActiveTripModel? activeTrip;

  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }

  // FIXED: Safe network implementation extracting and matching statuses dynamically
  Future<void> fetchDriverTrips({String? status}) async {
    if (_isLoading || _hasFetched) return;
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }

      // Handle optional query filters cleanly
      final Map<String, dynamic> queryParameters = {};
      if (status != null && status.trim().isNotEmpty) {
        queryParameters['status'] = status;
      }

      final String? token = TokenStorage.accessToken;
      final response = await _dio.get(
        '$baseUrl/api/v1/rides/', 
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final Map<String, dynamic> dataMap = response.data['data'] is Map ? response.data['data'] : {};
        final List rawResults = dataMap['results'] ?? [];

        if (rawResults.isNotEmpty) {
          debugPrint('!--------- driver\'s trip $rawResults-------------!');
          final firstItem = rawResults.first;
          postedRide = PostedRideModel.fromJson(firstItem);
          
          if (firstItem['timeline_status'] == 'ongoing') {
            activeTrip = ActiveTripModel.fromJson(firstItem);
          }
        }
        _hasFetched = true;
      }
    } catch (e) {
      debugPrint("Error loading driver trip data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> cancelRide(BuildContext context, String rideId) async {
    _isLoading = true;
    notifyListeners();

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }

      final String? token = TokenStorage.accessToken;
      final response = await _dio.delete(
        '$baseUrl/api/v1/rides/$rideId/', 
        data: {},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        debugPrint("SUCCESS: ${response.data['data']['message']}");
        
        postedRide = null;
        activeTrip = null;
        _hasFetched = false; 
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.data['data']['message'] ?? "Ride cancelled successfully.")),
          );
        }
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        debugPrint("400 Server Error Details: ${e.response?.data}");
      } else {
        debugPrint("Error cancelling ride: $e");
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to cancel ride. Please try again.")),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}