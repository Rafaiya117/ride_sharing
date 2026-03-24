import 'package:flutter/material.dart';
import 'package:ride_sharing/features/user_profile/user_profile_model/user_profile_model.dart';

class ProfileController extends ChangeNotifier {
  late ProfileModel _profile;
  ProfileModel get profile => _profile;

  // 2. Dynamic Input State for Promo Code
  final TextEditingController promoCodeController = TextEditingController();
  bool _isPromoInputValid = false;
  bool get isPromoInputValid => _isPromoInputValid;

  ProfileController() {
    _mockInitialData(); 
  }

  void _mockInitialData() {
    _profile = ProfileModel(
      name: "John Doe",
      email: "safimahmud1412@gmail.com",
      initials: "J",
      totalTrips: 45,
      rating: 4.8,
      availableCredits: 15.0,
      isVerified: true, 
    );
  }

  // --- Dynamic Methods ---

  void onPromoInputChanged(String value) {
    _isPromoInputValid = value.trim().isNotEmpty;
    notifyListeners(); 
  }

  void redeemPromoCode(BuildContext context) {
    String code = promoCodeController.text.trim();
    if (code.isNotEmpty) {
      print("Redeeming promo code dynamically: $code...");
      // Show dynamic success dialogue standard
      promoCodeController.clear();
      _isPromoInputValid = false;
      notifyListeners();
    }
  }

  void navigateToEditProfile(BuildContext context) {
    print("Navigating dynamically to edit profile...");
    // GoRouter.of(context).push('/editProfile', extra: _profile);
  }

  void viewCreditHistory(BuildContext context) {
    print("Navigating dynamically to credit history...");
    // GoRouter.of(context).push('/creditHistory');
  }

  void navigateToTripHistory(BuildContext context) {
    print("Navigating dynamically to trip history...");
    // GoRouter.of(context).push('/tripHistory');
  }

  void navigateToReviews(BuildContext context) {
    print("Navigating dynamically to user reviews...");
    // GoRouter.of(context).push('/userReviews');
  }

  void navigateToPaymentMethods(BuildContext context) {
    print("Navigating dynamically to payment methods...");
    // GoRouter.of(context).push('/paymentMethods');
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }
}