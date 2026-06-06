import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/post_new_ride/model/post_new_ride_model.dart';

class PostRideController extends ChangeNotifier {
  // Instance of the model
  final PostRideModel ride = PostRideModel();

  // Text Controllers
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
    // Read directly from text controllers to catch user inputs dynamically
    final String pickupText = pickupLocationController.text.trim();
    final String dropoffText = dropoffLocationController.text.trim();
    final String dateText = dateController.text.trim();
    final String timeText = timeController.text.trim();
    
    final int seatsInput = int.tryParse(availableSeatsController.text) ?? 1;
    final double priceInput = double.tryParse(priceController.text) ?? 45.0;
    final double pickupChargeInput = double.tryParse(pickupChargesController.text) ?? 0.0;

    debugPrint("Posting Ride: $pickupText to $dropoffText");

    // 1. Structural input validation check against UI inputs
    if (pickupText.isEmpty || dropoffText.isEmpty) {
      _showSnackBar(context, "Please enter both pickup and drop-off locations", isError: true);
      return;
    }

    final token = TokenStorage.accessToken;
    if (token == null) {
      _showSnackBar(context, "Authentication session missing. Please sign in again.", isError: true);
      return;
    }

    _setLoading(true);

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/rides/'; 

      // 2. Parse date/time strings from text fields safely
      String formattedDateTime = DateTime.now().toUtc().toIso8601String(); 
      if (dateText.isNotEmpty && timeText.isNotEmpty) {
        try {
          formattedDateTime = Uri.decodeComponent("${dateText}T${timeText}:00.000Z");
        } catch (_) {}
      }

      // 3. Post dynamic tracking map matching your exact payload sample structure
      final response = await _dio.post(
        url,
        data: {
          "pickup_location": pickupText,
          "pickup_lat": "0.000000", 
          "pickup_lng": "0.000000",
          "drop_location": dropoffText,
          "drop_lat": "0.000000",
          "drop_lng": "0.000000",
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
    // Fixed: Properly dispose all newly initialized input text handlers to clear system memory
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