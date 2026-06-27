// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/driver_track_ride/driver_track_ride_model/driver_track_ride_model.dart';

class DriverTrackController extends ChangeNotifier {
  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DriverTrackModel? _tripDetails;
  DriverTrackModel get trip => _tripDetails ?? DriverTrackModel(
    passengerName: "Sarah Johnson",
    carModel: "Honda Accord 2022",
    carPlate: "ABC 1234",
    estimatedArrival: "2h 45m",
    progress: 0.63,
    currentStatus: "Approaching Hartford, CT",
    pickup: "New York, NY",
    destination: "Boston, MA",
    distance: "215 miles",
    duration: "4h 30m",
    price: 45,
    status: "active",
  );

  Future<void> fetchRideDetails(String rideId) async {
    if (_isLoading) return;
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    final String? token = TokenStorage.accessToken;
    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

    try {
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
        _tripDetails = DriverTrackModel.fromJson(dataObj);
      }
    } catch (e) {
      debugPrint("Error fetching driver tracking details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> endRide(BuildContext context, String rideId) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final String? token = TokenStorage.accessToken;
    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/rides/$rideId/end/', 
        data: {},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        // Optimistically mutate local tracking structure fields to immediately hide actions cleanly
        _tripDetails = DriverTrackModel.fromJson({
          ...(response.data['data'] is Map ? response.data['data'] : {}),
          'status': 'completed'
        });

        if (context.mounted) {
          GoRouter.of(context).push('/drive_complateride_screen');
        }
      }
    } catch (e) {
      debugPrint("Error execution transition on ending ride segment: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void triggerSOS() => print("Emergency SOS activated!");
  void callPassenger() => print("Calling passenger...");
  void messagePassenger() => print("Opening chat...");
  void shareTrip() => print("Sharing trip with family...");
}