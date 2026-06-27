import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/driver_review/driver_review_model/driver_review_model.dart';

class DriveReviewsController extends ChangeNotifier {
  final Dio _dio = Dio(); 
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  final List<DriverReviewModel> _reviews = [
    DriverReviewModel(
      passengerName: "Sarah Johnson", initials: "S", date: "Mar 2, 2026",
      rating: 5.0, comment: "Great passenger! Very friendly and respectful throughout the journey. Would definitely drive again.",
    ),
    DriverReviewModel(
      passengerName: "Michael Chen", initials: "M", date: "Feb 28, 2026",
      rating: 5.0, comment: "Perfect passenger. Punctual and easy to talk to. Highly recommended!",
    ),
  ];
  List<DriverReviewModel> get reviews => _reviews;

  double getStarPercentage(int starLevel) {
    if (totalReviews == 0) return 0.0;
    int count = _starCounts[starLevel] ?? 0;
    return count / totalReviews;
  }

  // FIXED: Added function to submit a ride review to the backend
  Future<void> submitReview(BuildContext context, {required String rideId, required int rating, required String reviewText}) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final String? token = TokenStorage.accessToken;
    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

    try {
      final Map<String, dynamic> requestBody = {
        "rating": rating,
        "review": reviewText,
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/rides/$rideId/rate/', // Adjust endpoints path pattern if needed
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        debugPrint("Review submitted successfully: ${response.data}");
        if (context.mounted) {
          Navigator.of(context).pop(); // Go back after successful submission
        }
      }
    } catch (e) {
      debugPrint("Error posting driver review: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void showAllReviews() {
    print("Action dynamically triggered: Show all standard standard reviews (placeholder standard)");
  }

  void navigateBack(BuildContext context) {}
}