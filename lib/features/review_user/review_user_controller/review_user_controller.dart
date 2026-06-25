import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/review_user/review_user_model/review_user_model.dart';

// class ReviewsController extends ChangeNotifier {
//   // 1. Dynamic Summary State (Mocked from image_8.png)
//   double get overallRating => 4.8;
//   int get totalReviews => 8;
  
//   final Map<int, int> _starCounts = {
//     5: 6,
//     4: 2,
//     3: 0,
//     2: 0,
//     1: 0,
//   };
//   Map<int, int> get starCounts => _starCounts;

//   // 2. Dynamic List of Reviews State standard MVC logic
//   final List<ReviewModel> _reviews = [
//     ReviewModel(
//       passengerName: "Sarah Johnson", initials: "S", date: "Mar 2, 2026",
//       rating: 5.0, comment: "Great passenger! Very friendly and respectful throughout the journey. Would definitely drive again.",
//     ),
//     ReviewModel(
//       passengerName: "Michael Chen", initials: "M", date: "Feb 28, 2026",
//       rating: 5.0, comment: "Perfect passenger. Punctual and easy to talk to. Highly recommended!",
//     ),
//   ];
//   List<ReviewModel> get reviews => _reviews;

//   // --- Dynamic Methods ---

//   // Standard standard standard standard standard dynamic price standard standard standard price logic dynamic standard
//   double getStarPercentage(int starLevel) {
//     if (totalReviews == 0) return 0.0;
//     int count = _starCounts[starLevel] ?? 0;
//     return count / totalReviews;
//   }

//   void showAllReviews() {
//     print("Action dynamically triggered: Show all standard standard reviews (placeholder standard)");
//     // Logic to update view or filter dynamic reviews
//   }

//   void navigateBack(BuildContext context) {
//     // Navigator.pop(context); // standard mvc pop
//   }
// }

class ReviewsController extends ChangeNotifier {
  // 1. Dynamic Summary State (Mocked from image_8.png)
  double get overallRating => 4.8;
  int get totalReviews => _reviews.length; 
  
  final Map<int, int> _starCounts = {
    5: 6,
    4: 2,
    3: 0,
    2: 0,
    1: 0,
  };
  Map<int, int> get starCounts => _starCounts;
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
  final Dio _dio = Dio();
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;
  Future<bool> submitReview({required int rideId, required int rating, required String reviewText}) async {
    final String? token = TokenStorage.accessToken;
    if (token == null) return false;

    _isSubmitting = true;
    notifyListeners();

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      final response = await _dio.post(
        '$baseUrl/api/v1/rides/$rideId/rate/', 
        data: {
          "rating": rating,
          "review": reviewText,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'];
        
        String formattedDate = DateFormat('MMM d, yyyy').format(DateTime.now());
        if (data['created_at'] != null) {
          try {
            formattedDate = DateFormat('MMM d, yyyy').format(DateTime.parse(data['created_at']));
          } catch (_) {}
        }

        final newReview = ReviewModel(
          passengerName: "You", 
          initials: "Y",
          date: formattedDate,
          rating: double.tryParse(data['rating']?.toString() ?? '5.0') ?? 5.0,
          comment: data['review'] ?? "",
        );

        _reviews.insert(0, newReview); 
        
        int parsedRatingInt = int.tryParse(data['rating']?.toString() ?? '5') ?? 5;
        _starCounts[parsedRatingInt] = (_starCounts[parsedRatingInt] ?? 0) + 1;

        _isSubmitting = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Review transmission request layer exception dropped: $e");
    }

    _isSubmitting = false;
    notifyListeners();
    return false;
  }

  double getStarPercentage(int starLevel) {
    if (totalReviews == 0) return 0.0;
    int count = _starCounts[starLevel] ?? 0;
    return count / totalReviews;
  }

  void showAllReviews() {
    print("Action dynamically triggered: Show all standard standard reviews (placeholder standard)");
  }

  void navigateBack(BuildContext context) {
    // Navigator.pop(context);
  }
}