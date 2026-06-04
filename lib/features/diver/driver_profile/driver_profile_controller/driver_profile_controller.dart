import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/driver_profile/driver_profile_model/driver_profile_model.dart';

class DriverProfileController extends ChangeNotifier {
  DriverProfileModel? _profile; // Changed to nullable to check against initial empty states
  DriverProfileModel get profile => _profile ?? _fallbackProfile();

  final Dio _dio = Dio();
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DriverProfileController() {
    getProfileData();
  }

  Future<void> getProfileData() async {
    _isLoading = true;
    notifyListeners();

    final token = TokenStorage.accessToken;
    if (token == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final profileUrl = '$baseUrl/api/v1/driver/profile/';
      final vehicleUrl = '$baseUrl/api/v1/driver/vehicle/'; // Your separate vehicle API endpoint

      // Execute both requests concurrently for fast network performance
      final responses = await Future.wait([
        _dio.get(profileUrl, options: Options(headers: {'Authorization': 'Bearer $token'})),
        _dio.get(vehicleUrl, options: Options(headers: {'Authorization': 'Bearer $token'})),
      ]);

      final profileResponse = responses[0].data;
      final vehicleResponse = responses[1].data;

      if (profileResponse != null && profileResponse['success'] == true) {
        final profileData = profileResponse['data'] as Map<String, dynamic>;
        
        // Merge vehicle data safely into the model initialization map if it succeeded
        if (vehicleResponse != null && vehicleResponse['success'] == true) {
          final vehicleData = vehicleResponse['data'] as Map<String, dynamic>;
          profileData.addAll(vehicleData);
        }

        _profile = DriverProfileModel.fromJson(profileData);
      }
    } catch (e) {
      debugPrint("Error fetching driver data endpoints: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Backup fallback profile blueprint model used prior to network load executions
  DriverProfileModel _fallbackProfile() {
    return DriverProfileModel(
      name: "Loading...",
      email: "...",
      initials: "",
      totalTrips: 0,
      rating: 0.0,
      isVerified: false,
      carModel: "",
      plateNumber: "",
      color: "",
      availableSeats: 0,
    );
  }

  // Navigation methods remain completely untouched
  void navigateToEdit(BuildContext context) => debugPrint("Edit Profile");
  void navigateToHistory(BuildContext context) => context.push('/drive_triphistory');
  void navigateToReviews(BuildContext context) => context.push('/drive_review_screen');
  void navigateToEarnings(BuildContext context) => context.push('/drive_earning_screen');
  void navigateToPayments(BuildContext context) => debugPrint("Payments");
}