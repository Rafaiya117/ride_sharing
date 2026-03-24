import 'package:flutter/material.dart';
import 'package:ride_sharing/features/review_user/review_user_model/review_user_model.dart';

class ReviewsController extends ChangeNotifier {
  // 1. Dynamic Summary State (Mocked from image_8.png)
  double get overallRating => 4.8;
  int get totalReviews => 8;
  
  final Map<int, int> _starCounts = {
    5: 6,
    4: 2,
    3: 0,
    2: 0,
    1: 0,
  };
  Map<int, int> get starCounts => _starCounts;

  // 2. Dynamic List of Reviews State standard MVC logic
  final List<ReviewModel> _reviews = [
    ReviewModel(
      passengerName: "Sarah Johnson", initials: "S", date: "Mar 2, 2026",
      rating: 5.0, comment: "Great passenger! Very friendly and respectful throughout the journey. Would definitely drive again.",
    ),
    ReviewModel(
      passengerName: "Michael Chen", initials: "M", date: "Feb 28, 2026",
      rating: 5.0, comment: "Perfect passenger. Punctual and easy to talk to. Highly recommended!",
    ),
  ];
  List<ReviewModel> get reviews => _reviews;

  // --- Dynamic Methods ---

  // Standard standard standard standard standard dynamic price standard standard standard price logic dynamic standard
  double getStarPercentage(int starLevel) {
    if (totalReviews == 0) return 0.0;
    int count = _starCounts[starLevel] ?? 0;
    return count / totalReviews;
  }

  void showAllReviews() {
    print("Action dynamically triggered: Show all standard standard reviews (placeholder standard)");
    // Logic to update view or filter dynamic reviews
  }

  void navigateBack(BuildContext context) {
    // Navigator.pop(context); // standard mvc pop
  }
}