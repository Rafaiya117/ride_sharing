import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';

class CashPaymentController extends ChangeNotifier {
  String _selectedMethod = 'cash'; 
  bool _isLoading = false;

  String get selectedMethod => _selectedMethod;
  bool get isLoading => _isLoading;

  final Dio _dio = Dio();

  void selectMethod(String method) {
    _selectedMethod = method;
    notifyListeners(); 
  }

  // FIXED: Runs sequential calls (Create Booking API first, then execute final Cash Checkout)
  Future<void> processCashPayment(BuildContext context, int rideId) async {
    _isLoading = true;
    notifyListeners();

    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    
    final String? token = TokenStorage.accessToken;

    try {
      // 1. RUN BOOKING PIPELINE FIRST WITH SEAT MAPPING LOGIC
      int? generatedBookingId;
      try {
        final bookingResponse = await _dio.post(
          '$baseUrl/api/v1/passenger/bookings/',
          data: {
            "ride_id": rideId,
            "payment_method": "cash",
            "seats_booked": 1
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          ),
        );

        if (bookingResponse.data != null && bookingResponse.data['success'] == true) {
          generatedBookingId = bookingResponse.data['data']['id'] ?? bookingResponse.data['data']['booking_id'];
        }
      } catch (e) {
        debugPrint("Error executing sequential cash booking core payload logic: $e");
      }

      if (generatedBookingId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to register cash ride booking instance."), backgroundColor: Colors.red),
          );
        }
        return;
      }

      // 2. RUN CASH CHECKOUT INJECTING THE RETURNED BOOKING_ID
      final Map<String, dynamic> requestBody = {
        "booking_id": generatedBookingId,
        "payment_method": "cash"
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/passenger/checkout/cash/',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final String message = response.data['message'] ?? "Cash payment confirmed successfully.";
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: const Color(0xFF1DB954), 
            ),
          );
          //GoRouter.of(context).push('/rating_screen');
          context.push('/user_home_screen');
        }
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      debugPrint("Backend 400 Validation Error Payload: $responseData");
      
      String errorMsg = "Payment syntax error";
      if (responseData is Map<String, dynamic>) {
        errorMsg = responseData['message'] ?? responseData.toString();
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint("Error confirming cash payment transaction request: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}