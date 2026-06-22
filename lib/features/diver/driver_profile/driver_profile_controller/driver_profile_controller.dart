import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/driver_profile/driver_profile_model/driver_profile_model.dart';

class DriverProfileController extends ChangeNotifier {
  DriverProfileModel? _profile; 
  DriverProfileModel get profile => _profile ?? _fallbackProfile();
  
  //!--------- to hold vehicle data for profile info -------------!
  final Map<String, dynamic> _aggregatedData = {};

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

      final response = await _dio.get(
        profileUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        _aggregatedData.addAll(responseData['data'] as Map<String, dynamic>);
        
        // Call the separate vehicle execution function sequentially
        await getVehicleData(token);
      }
    } catch (e) {
      debugPrint("Error fetching driver profile data: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  //!--------- gets vehicle data -------------!
  Future<void> getVehicleData(String token) async {
    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final vehicleUrl = '$baseUrl/api/v1/driver/verification/'; // Adjust tail context to your vehicle get path

      final response = await _dio.get(
        vehicleUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        _aggregatedData.addAll(responseData['data'] as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint("Error fetching driver vehicle data: ${e.toString()}");
    }
    _profile = DriverProfileModel.fromJson(_aggregatedData);
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
      stripeOnboardingComplete: false,
    );
  }

  // void navigateToEdit(BuildContext context) => context.push('/drive_edit_profile_screen');
  Future<void> navigateToEdit(BuildContext context) async {
    final mapUpdated = await context.push('/drive_edit_profile_screen');
    
    if (mapUpdated == true && context.mounted) {
      getProfileData(); 
    }
  }
  void navigateToHistory(BuildContext context) => context.push('/drive_triphistory');
  void navigateToReviews(BuildContext context) => context.push('/drive_review_screen');
  void navigateToEarnings(BuildContext context) => context.push('/drive_earning_screen');
  void navigateToPayments(BuildContext context) => debugPrint("Payments");
}