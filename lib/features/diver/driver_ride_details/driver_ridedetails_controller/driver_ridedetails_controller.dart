// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/driver_ride_details/driver_ridedetails_model/driver_ridedetails_model.dart';

class DriverRideDetailsController extends ChangeNotifier {
  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  bool _isLocalStarted = false;
  bool get isLocalStarted => _isLocalStarted;

  DriverRideDetailsModel? _rideDetails;
  DriverRideDetailsModel? get ride => _rideDetails;

  Future<void> fetchRideDetails(String rideId) async {
    if (_isLoading) return; 
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }

      final String? token = TokenStorage.accessToken;
      final response = await _dio.get(
        '$baseUrl/api/v1/rides/$rideId/', 
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final Map<String, dynamic> dataObj = response.data['data'] is Map ? response.data['data'] : {};
        debugPrint('!------ Driver Ride details $dataObj');
        _rideDetails = DriverRideDetailsModel.fromJson(dataObj);
        
        // FIXED: Reset local lifecycle flags on fresh queries
        _isLocalStarted = false;
      }
    } catch (e) {
      debugPrint("Error loading ride profile details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startRide(BuildContext context, String rideId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();

    final String? token = TokenStorage.accessToken;
    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/rides/$rideId/start/', 
        data: {}, 
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json', 
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Ride status updated successfully on backend layer for ride ID: $rideId");
        
        // FIXED: Explicitly flip state flag tracker to hide widget before popping out
        _isLocalStarted = true;
        notifyListeners();

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      debugPrint("Error updating execution state machine transitions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> navigateToChat(BuildContext context, {required int targetUserId, int? targetRideId}) async {
    final router = GoRouter.of(context);
    
    _isLoading = true;
    notifyListeners();

    final baseUrl = dotenv.env['API_BASE_URL'];
    final String? token = TokenStorage.accessToken;

    try {
      final Map<String, dynamic> requestBody = {
        "user_id": targetUserId,
        if (targetRideId != null) "ride_id": targetRideId,
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/conversations/',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final resData = response.data['data'];
        if (resData != null && resData['id'] != null) {
          final int validConversationId = resData['id'];
          
          debugPrint("SUCCESS: Redirecting via captured router instances → ID: $validConversationId");
          router.push('/chat', extra: validConversationId);
        }
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        debugPrint("Server Validation Error Details: ${e.response?.data}");
      } else {
        debugPrint("Error initializing conversation room payload: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void callPassenger() => print("Calling passenger...");
  void messagePassenger() => print("Opening chat...");
  void shareRide() => print("Sharing ride link...");
}