import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/post_new_ride/model/post_new_ride_model.dart';

class PostRideController extends ChangeNotifier {
  final PostRideModel ride = PostRideModel();

  final TextEditingController pickupLocationController = TextEditingController();
  final TextEditingController dropoffLocationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController availableSeatsController = TextEditingController(text: "1");
  final TextEditingController priceController = TextEditingController(text: "45");
  final TextEditingController pickupChargesController = TextEditingController();
  final TextEditingController dropoffChargesController = TextEditingController();

  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? pickupLat;
  String? pickupLng;
  String? dropoffLat;
  String? dropoffLng;

  // FIXED: Fields to hold calculated routing specifications from API 3
  double? routeDistanceKm;
  int? routeDurationMinutes;
  String? routePolyline;

  List<dynamic> pickupSuggestions = [];
  List<dynamic> dropoffSuggestions = [];

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
    
    final String? token = TokenStorage.accessToken; // Fetch session token

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      
      final response = await _dio.get(
        '$baseUrl/api/v1/maps/places/', 
        queryParameters: {'query': query},
        options: Options(
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token', // Injected protection header
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
      debugPrint("Autocomplete search exception: $e");
    }
    return [];
  }

  // inside class PostRideController ...
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
          pickupLocationController.text = data['formatted_address'] ?? data['name'] ?? data['description'] ?? '';
          pickupSuggestions = [];
        } else {
          dropoffLat = data['lat']?.toString();
          dropoffLng = data['lng']?.toString();
          dropoffLocationController.text = data['formatted_address'] ?? data['name'] ?? data['description'] ?? '';
          dropoffSuggestions = [];
        }
        notifyListeners();

        if (pickupLat != null && dropoffLat != null) {
          await calculateRoute();
        }
      }
    } catch (e) {
      debugPrint("Details retrieval exception: $e");
    }
  }

  // FIXED: New isolated function handling API 3 route calculation payloads
  Future<void> calculateRoute() async {
    final token = TokenStorage.accessToken;
    if (token == null) return;

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

      final response = await _dio.post(
        '$baseUrl/api/v1/maps/route/',
        data: {
          "origin_lat": double.tryParse(pickupLat ?? ''),
          "origin_lng": double.tryParse(pickupLng ?? ''),
          "dest_lat": double.tryParse(dropoffLat ?? ''),
          "dest_lng": double.tryParse(dropoffLng ?? '')
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
        final routeData = response.data['data'];
        routeDistanceKm = double.tryParse(routeData['distance_km']?.toString() ?? '');
        routeDurationMinutes = int.tryParse(routeData['duration_minutes']?.toString() ?? '');
        routePolyline = routeData['polyline'];
        
        debugPrint("API 3 Route Computed: $routeDistanceKm km, $routeDurationMinutes mins");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching route specifications from API 3: $e");
    }
  }

  void toggleDoorPickUp(bool value) {
    ride.isDoorPickUp = value;
    notifyListeners();
  }

  void toggleDoorDropOff(bool value) {
    ride.isDoorDropOff = value;
    notifyListeners();
  }

  Future<void> submitRide(BuildContext context) async {
    final String pickupText = pickupLocationController.text.trim();
    final String dropoffText = dropoffLocationController.text.trim();
    final String dateText = dateController.text.trim();
    final String timeText = timeController.text.trim();
    
    final int seatsInput = int.tryParse(availableSeatsController.text) ?? 1;
    final double priceInput = double.tryParse(priceController.text) ?? 45.0;
    final double pickupChargeInput = double.tryParse(pickupChargesController.text) ?? 0.0;

    if (pickupText.isEmpty || dropoffText.isEmpty) {
      _showSnackBar(context, "Please enter both pickup and drop-off locations", isError: true);
      return;
    }

    if (pickupLat == null || dropoffLat == null) {
      _showSnackBar(context, "Please select locations from the search dropdown lists.", isError: true);
      return;
    }

    final token = TokenStorage.accessToken;
    if (token == null) {
      _showSnackBar(context, "Authentication session missing. Please sign in again.", isError: true);
      return;
    }

    _setLoading(true);

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      final url = '$baseUrl/api/v1/rides/'; 

      String formattedDateTime = DateTime.now().toUtc().toIso8601String(); 
      if (dateText.isNotEmpty && timeText.isNotEmpty) {
        try {
          final String normalizedTime = timeText.split(':').length == 2 ? "$timeText:00" : timeText;
          final DateTime parsedDateTime = DateTime.parse("${dateText}T$normalizedTime");
          formattedDateTime = parsedDateTime.toUtc().toIso8601String();
        } catch (_) {}
      }

      final response = await _dio.post(
        url,
        data: {
          "pickup_location": pickupText,
          // FIXED: Explicitly parsed coordinates to numeric doubles to prevent server payload type mismatch
          "pickup_lat": double.tryParse(pickupLat!), 
          "pickup_lng": double.tryParse(pickupLng!),
          "drop_location": dropoffText,
          // FIXED: Explicitly parsed coordinates to numeric doubles to prevent server payload type mismatch
          "drop_lat": double.tryParse(dropoffLat!),
          "drop_lng": double.tryParse(dropoffLng!),
          "date_time": formattedDateTime,
          "available_seats": seatsInput,
          "price_per_seat": priceInput.toStringAsFixed(2),
          "door_pickup": ride.isDoorPickUp,
          "door_pickup_charge": pickupChargeInput.toStringAsFixed(2),
          "number_plate": "20223" 
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json', // FIXED: Declared explicit payload type
          },
        ),
      );

      final responseData = response.data;
      if (responseData != null && responseData['success'] == true) {
        _showSnackBar(context, "Ride posted successfully!");
        if (context.mounted) {
          context.push('/drive_home_screen');
        }
      } else {
        String errorMsg = responseData?['message'] ?? "Failed to post ride setup";
        _showSnackBar(context, errorMsg, isError: true);
      }

    } on DioException catch (e) {
      String errorMsg = e.response?.data?['message'] ?? "Server validation rejected this request";
      _showSnackBar(context, errorMsg, isError: true);
    } catch (e) {
      _showSnackBar(context, "An unexpected error occurred", isError: true);
    } finally {
      _setLoading(false);
    }
  }
  
  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    pickupLocationController.dispose();
    dropoffLocationController.dispose();
    dateController.dispose();
    timeController.dispose();
    availableSeatsController.dispose();
    priceController.dispose();
    pickupChargesController.dispose();
    dropoffChargesController.dispose();
    super.dispose();
  }
}