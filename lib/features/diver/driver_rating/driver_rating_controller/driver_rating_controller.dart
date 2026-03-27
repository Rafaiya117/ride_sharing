import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/payment_complete.dart';
import 'package:ride_sharing/features/diver/platform_fee/platform_fee_controller/platform_fee_controller.dart';
import 'package:ride_sharing/features/diver/platform_fee/platform_fee_view/platform_fee_view.dart';

class DriverRatingController extends ChangeNotifier {
  // Data from Trip History
  final String passengerName = "Jennifer Lee";
  final String passengerInitial = "J";
  final String route = "Boston, MA → New York, NY";
  final String dateTime = "Feb 22, 2026 at 11:00 AM";

  int _selectedRating = 0;
  int get selectedRating => _selectedRating;

  final TextEditingController commentController = TextEditingController();

  // Mapping for dynamic labels based on design
  final Map<int, String> ratingLabels = {
    1: "😔 Poor",
    2: "😐 Fair",
    3: "😊 Good",
    4: "😁 Very Good",
    5: "🤩 Excellent",
  };

  String get currentLabel => ratingLabels[_selectedRating] ?? "";

  void updateRating(int rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  // void submitRating(BuildContext context) {
  //   if (_selectedRating > 0) {
  //     debugPrint("Rating $selectedRating submitted for $passengerName");
  //     Navigator.pop(context);
  //   }
  // }

  void submitRating(BuildContext context) {
  // 1. Show Success Popup
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const RatingSuccessPopUp(),
  );

  // 2. Chain Fee Required Popup after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pop(context); 
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => FeePaymentController(),
        child: const FeeRequiredPopup(),
      ),
    );
  });
}

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}