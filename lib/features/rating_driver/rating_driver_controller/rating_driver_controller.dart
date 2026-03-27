// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:ride_sharing/features/rating_driver/rating_driver_model/rating_driver_model.dart';

class RatingController extends ChangeNotifier {
  RatingDriverData _driver = RatingDriverData(name: "Jennifer Lee", initials: "J");
  RatingTripDetails _trip = RatingTripDetails(route: "Boston, MA → New York, NY", dateTime: "Feb 22, 2026 at 11:00 AM");

  RatingDriverData get driver => _driver;
  RatingTripDetails get trip => _trip;

  int _selectedRating = 0; 

  int get selectedRating => _selectedRating;
  final TextEditingController commentsController = TextEditingController();

  // --- Methods ---

  // standardized mapping for rating labels per design standard
  final Map<int, String> ratingLabels = {
    1: "😔 Poor",
    2: "😐 Fair",
    3: "😊 Good",
    4: "😁 Very Good",
    5: "🤩 Excellent",
  };

  void updateRating(int newRating) {
    if (newRating >= 1 && newRating <= 5) {
      _selectedRating = newRating;
      notifyListeners(); 
      print("Dynamic rating update: $newRating (${ratingLabels[newRating]})");
    }
  }

  void submitRating(BuildContext context) {
    if (_selectedRating == 0) {
      // Show dynamic error validation
      print("Validation Error: No rating selected.");
      return;
    }
    
    String comments = commentsController.text.trim();
    print("Submitting dynamically: Rating $_selectedRating with comments: '$comments'");
    // GoRouter.of(context).push('/home'); // Or Success page
  }

  void navigateBack(BuildContext context) {
    // GoRouter.of(context).go('/home'); // Or specific go back
  }

  @override
  void dispose() {
    commentsController.dispose();
    super.dispose();
  }
}