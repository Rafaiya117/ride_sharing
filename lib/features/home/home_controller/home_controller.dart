// ignore_for_file: prefer_final_fields
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/home/model/home_model.dart';


class HomeController extends ChangeNotifier {
  String get userName => TokenStorage.userData?['name'] ?? "User";
  
  UserStats get stats => UserStats(
    trips: TokenStorage.userData?['total_trips'] ?? 0,
    rating: double.tryParse((TokenStorage.userData?['avg_rating'] ?? '0.0').toString()) ?? 0.0,
    upcoming: 1, 
  );

  UpcomingTrip _nextTrip = UpcomingTrip(
    pickup: "New York, NY", dropoff: "Boston, MA", 
    date: "Mar 6, 2026", time: "09:00 AM", pricePerSeat: 45.0, 
    driverName: "Sarah Johnson", carModel: "Honda Accord 2022"
  );

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController seatController = TextEditingController();
  
  int _currentNavbarIndex = 0;
  int get currentNavbarIndex => _currentNavbarIndex;
  UpcomingTrip get nextTrip => _nextTrip;

  final Dio _dio = Dio();

  // FIXED: Properties to hold coordinates and autocomplete suggestions
  String? pickupLat;
  String? pickupLng;
  String? dropoffLat;
  String? dropoffLng;

  List<dynamic> pickupSuggestions = [];
  List<dynamic> dropoffSuggestions = [];

  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }

  void clearInputs() {
    pickupController.clear();
    dropoffController.clear();
    dateController.clear();
    seatController.clear();
    pickupSuggestions = [];
    dropoffSuggestions = [];
    pickupLat = null;
    pickupLng = null;
    dropoffLat = null;
    dropoffLng = null;
    notifyListeners();
  }

  // FIXED: Autocomplete prediction lookup (API 1)
  Future<List<dynamic>> searchPlaces(String query, {required bool isPickup}) async {
    if (query.isEmpty) {
      if (isPickup) {
        pickupSuggestions = [];
      } else {
        dropoffSuggestions = [];
      }
      notifyListeners();
      return [];
    }
    
    final String? token = TokenStorage.accessToken;

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      
      final response = await _dio.get(
        '$baseUrl/api/v1/maps/places/', 
        queryParameters: {'query': query},
        options: Options(
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.data != null && response.data['success'] == true) {
        final List results = response.data['data'] ?? [];
        if (isPickup) pickupSuggestions = results; else dropoffSuggestions = results;
        notifyListeners();
        return results;
      }
    } catch (e) {
      debugPrint("User Autocomplete search exception: $e");
    }
    return [];
  }

  // FIXED: Detailed geometry coordinate extraction (API 2)
  Future<void> fetchPlaceDetails(String placeId, {required bool isPickup}) async {
    final String? token = TokenStorage.accessToken;

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

      final response = await _dio.get(
        '$baseUrl/api/v1/maps/place-details/', 
        queryParameters: {'place_id': placeId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'];
        if (isPickup) {
          pickupLat = data['lat']?.toString();
          pickupLng = data['lng']?.toString();
          pickupController.text = data['formatted_address'] ?? data['name'];
          pickupSuggestions = [];
        } else {
          dropoffLat = data['lat']?.toString();
          dropoffLng = data['lng']?.toString();
          dropoffController.text = data['formatted_address'] ?? data['name'];
          dropoffSuggestions = [];
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("User Details retrieval exception: $e");
    }
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

    // FIXED: Appends the precise verified geolocation lat/lng details to the query route parameters
    context.push(
      '/search_ride_screen?pickup_location=$from&drop_location=$to&date=$formattedDate&seats=$seats'
      '&pickup_lat=${pickupLat ?? ""}&pickup_lng=${pickupLng ?? ""}'
      '&drop_lat=${dropoffLat ?? ""}&drop_lng=${dropoffLng ?? ""}'
    );
  }

  void trackTrip(BuildContext context, UpcomingTrip trip) {
    GoRouter.of(context).push('/ride_tracking');
  }

  void shareTripWithFamily(BuildContext context) {}
  void openNotifications(BuildContext context) {}
  
  void openProfile(BuildContext context) {
    GoRouter.of(context).push('/profile_screen');
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    dateController.dispose();
    seatController.dispose();
    super.dispose();
  }
}