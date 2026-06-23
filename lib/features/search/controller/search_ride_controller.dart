import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/search/model/search_ride_model.dart';

// class SearchResultsController extends ChangeNotifier {
//   // 1. Dynamic Route Data
//   String get fromLocation => "New York";
//   String get toLocation => "Boston";

//   // 2. Mocked Results from image_7.png
//   final List<RideResult> _results = [
//     RideResult(
//       departureTime: "10:00 AM", departureDate: "Mar 7, 2026", pickup: "New York, NY", dropoff: "Washington, DC",
//       price: 38.0, duration: "4h 45m", distance: "225 miles", seatsLeft: 3,
//       driverName: "Lisa Martinez", carModel: "Audi A4 2023", driverRating: 4.9,
//     ),
//     RideResult(
//       departureTime: "11:30 AM", departureDate: "Mar 6, 2026", pickup: "New York, NY", dropoff: "Boston, MA",
//       price: 42.0, duration: "4h 45m", distance: "215 miles", seatsLeft: 2,
//       driverName: "James Wilson", carModel: "Toyota Camry 2021", driverRating: 4.7,
//     ),
//     RideResult(
//       departureTime: "09:00 AM", departureDate: "Mar 6, 2026", pickup: "New York, NY", dropoff: "Boston, MA",
//       price: 45.0, duration: "4h 30m", distance: "215 miles", seatsLeft: 3,
//       driverName: "Sarah Johnson", carModel: "Honda Accord 2022", driverRating: 4.9,
//     ),
//     RideResult(
//       departureTime: "08:00 AM", departureDate: "Mar 8, 2026", pickup: "Los Angeles, CA", dropoff: "San Francisco, CA",
//       price: 48.0, duration: "6h 15m", distance: "380 miles", seatsLeft: 2,
//       driverName: "David Chen", carModel: "Mercedes C-Class 2021", driverRating: 4.6,
//     ),
//     RideResult(
//       departureTime: "02:00 PM", departureDate: "Mar 6, 2026", pickup: "New York, NY", dropoff: "Boston, MA",
//       price: 52.0, duration: "4h 15m", distance: "215 miles", seatsLeft: 4,
//       driverName: "Emily Davis", carModel: "Tesla Model 3 2023", driverRating: 5.0,
//     ),
//     RideResult(
//       departureTime: "04:30 PM", departureDate: "Mar 8, 2026", pickup: "New York, NY", dropoff: "Boston, MA",
//       price: 55.0, duration: "4h 20m", distance: "215 miles", seatsLeft: 1,
//       driverName: "Michael Brown", carModel: "BMW 5 Series 2022", driverRating: 4.8,
//     ),
//   ];

//   List<RideResult> get results => _results;

//   // 3. Filter State
//   String _selectedFilter = "Lowest Price"; 

//   String get selectedFilter => _selectedFilter;

//   void setFilter(String filter) {
//     _selectedFilter = filter;
//     // --- Add dynamic sorting logic here ---
//     // if (filter == "Earliest") _results.sort((a,b) => a.departureTime.compareTo(b.departureTime));
//     notifyListeners();
//   }

//   void openRideDetails(BuildContext context, RideResult ride) {
//     print("Opening details for ride with ${ride.driverName} at ${ride.departureTime}...");
//     GoRouter.of(context).push('/ride_details', extra: ride);
//   }

//   void navigateBack(BuildContext context) {
//     // Navigator.pop(context); // Standard stack navigation
//     // GoRouter.of(context).go('/home'); // Or specific go back
//   }
// }

class SearchResultsController extends ChangeNotifier {
  final Dio _dio = Dio();
  
  List<RideResult> _results = [];
  List<RideResult> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedFilter = "Recent"; 
  String get selectedFilter => _selectedFilter;

  // Track coordinates locally for dynamic headers
  String _fromLocation = "";
  String _toLocation = "";
  String get fromLocation => _fromLocation;
  String get toLocation => _toLocation;


  Map<String, dynamic> _lastSearchParams = {};

  Future<void> fetchAvailableRides({
    required String pickup,
    required String drop,
    required String date,
    required int seats,
    String sortBy = 'recent',
  }) async {
    _fromLocation = pickup;
    _toLocation = drop;
    _isLoading = true;
    notifyListeners();

    _lastSearchParams = {
      'pickup_location': pickup,
      'drop_location': drop,
      'date': date,
      'seats': seats,
    };

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/passenger/rides/search/'; 
      
      final String? token = TokenStorage.accessToken;

      final response = await _dio.get(
        url,
        queryParameters: {
          ..._lastSearchParams,
          'sort_by': sortBy,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        debugPrint('!-------$response-------!');
        final List rawResults = response.data['data']['results'] ?? [];
        
        _results = rawResults.map((json) {
          final Map<String, dynamic> sanitizedJson = Map<String, dynamic>.from(json);
          final numericalKeys = [
            'driver_rating', 
            'price_per_seat', 
            'door_pickup_charge', 
            'distance_km',
            'price' 
          ];

          for (var key in numericalKeys) {
            if (sanitizedJson[key] is String) {
              sanitizedJson[key] = double.tryParse(sanitizedJson[key]) ?? 0.0;
            }
          }
          return RideResult.fromJson(sanitizedJson);
        }).toList();
      }
    } catch (e) {
      debugPrint("Error fetching rides: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    
    if (filter == "Lowest Price") {
      _results.sort((a, b) => a.price.compareTo(b.price));
      notifyListeners();
    } else {
      fetchAvailableRides(
        pickup: _lastSearchParams['pickup_location'] ?? '',
        drop: _lastSearchParams['drop_location'] ?? '',
        date: _lastSearchParams['date'] ?? '',
        seats: _lastSearchParams['seats'] ?? 1,
        sortBy: 'recent',
      );
    }
  }

  // void openRideDetails(BuildContext context, RideResult ride) {
  //   GoRouter.of(context).push('/ride_details', extra: ride);
  // }

  void openRideDetails(BuildContext context, RideResult ride) {
    debugPrint('Ride id==================${ride.id}');
    GoRouter.of(context).push('/ride_details', extra: ride.id);
  }

  void navigateBack(BuildContext context) {
    context.pop();
  }
}