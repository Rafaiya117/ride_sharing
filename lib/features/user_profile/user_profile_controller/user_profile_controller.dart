import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/user_profile/user_profile_model/user_profile_model.dart';

class ProfileController extends ChangeNotifier {
  // FIXED: Initialized with a default model configuration instance to support view loading states
  ProfileModel _profile = ProfileModel(
    name: "Loading...",
    email: "...",
    initials: "",
    totalTrips: 0,
    rating: 0.0,
    availableCredits: 0.0,
    isVerified: false,
  );
  
  ProfileModel get profile => _profile;

  final TextEditingController promoCodeController = TextEditingController();
  bool _isPromoInputValid = false;
  bool get isPromoInputValid => _isPromoInputValid;

  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProfileController() {
    fetchProfileData(); // FIXED: Triggers backend request instantly when active
  }

  // FIXED: Fetch real profile information from the API
  Future<void> fetchProfileData() async {
    final String? token = TokenStorage.accessToken;
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

      final response = await _dio.get(
        '$baseUrl/api/v1/driver/profile/', 
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final profileData = response.data['data'];
        _profile = ProfileModel.fromJson(profileData);
      }
    } catch (e) {
      debugPrint("Exception caught retrieving profile datasets: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onPromoInputChanged(String value) {
    _isPromoInputValid = value.trim().isNotEmpty;
    notifyListeners(); 
  }

  void redeemPromoCode(BuildContext context) {
    String code = promoCodeController.text.trim();
    if (code.isNotEmpty) {
      debugPrint("Redeeming promo code dynamically: $code...");
      promoCodeController.clear();
      _isPromoInputValid = false;
      notifyListeners();
    }
  }

  void navigateToEditProfile(BuildContext context) {
    debugPrint("Navigating dynamically to edit profile...");
    GoRouter.of(context).push('/edit_profile', extra: _profile);
  }

  void viewCreditHistory(BuildContext context) {
    debugPrint("Navigating dynamically to credit history...");
    GoRouter.of(context).push('/creditHistory');
  }

  void navigateToTripHistory(BuildContext context) {
    debugPrint("Navigating dynamically to trip history...");
    GoRouter.of(context).push('/my_trip_history');
  }

  void navigateToReviews(BuildContext context) {
    debugPrint("Navigating dynamically to user reviews...");
    GoRouter.of(context).push('/review_user');
  }

  void navigateToPaymentMethods(BuildContext context) {
    debugPrint("Navigating dynamically to payment methods...");
    GoRouter.of(context).push('/payment');
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }
}