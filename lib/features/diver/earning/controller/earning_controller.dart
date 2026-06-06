import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/earning/model/earning_model.dart';

class EarningsController extends ChangeNotifier {
  late EarningsModel _earningsData;
  EarningsModel get data => _earningsData;
  
  double withdrawalAmount = 0;
  int currentWithdrawalStep = 0; 
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Track the active string state parameter matching UI buttons
  String selectedPeriod = "Month"; 

  EarningsController() {
    // Initial empty construction to prevent null breaking the widget initialization layout pass
    _initializeEmptyData();
    _loadEarnings();
  }

  void _initializeEmptyData() {
    _earningsData = EarningsModel(
      totalEarnings: 0.0,
      pendingEarnings: 0.0,   
      availableEarnings: 0.0, 
      weeklyProgress: 0.0,
      weeklyData: [],
      avgPerTripText: "\$0", 
      totalTripsText: "0",
      trips: [],
    );
  }

  // --- Dynamic Method Triggered on Button Tap ---
  void changePeriod(String period) {
    selectedPeriod = period;
    notifyListeners(); // Immediate UI indicator highlight response
    _loadEarnings();   // Re-runs network query parameter update
  }

  Future<void> _loadEarnings() async {
    final token = TokenStorage.accessToken;
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/driver/earnings/'; // Replace with your explicit endpoint route

      final Dio dio = Dio();

      // Maps UI uppercase values ("Week", "Month", "Year") down to expected backend lower specs
      String queryParam = "monthly";
      if (selectedPeriod == "Week") queryParam = "weekly";
      if (selectedPeriod == "Year") queryParam = "yearly";

      final response = await dio.get(
        url,
        queryParameters: {
          "period": queryParam, 
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        final resData = responseData['data'];

        // Extract numbers from response payload stream safely 
        double total = (resData['total_earnings'] ?? 0.0).toDouble();
        double avg = (resData['avg_per_trip'] ?? 0.0).toDouble();
        int totalTripsCount = resData['total_trips'] ?? 0;
        double available = (resData['available_earnings'] ?? 0.0).toDouble();
        double pending = (resData['pending_earnings'] ?? 0.0).toDouble();

        _earningsData = EarningsModel(
          totalEarnings: total,
          pendingEarnings: pending,   
          availableEarnings: available, 
          weeklyProgress: 0.75,
          weeklyData: [40, 70, 50, 90, 60, 80, 45],
          avgPerTripText: "\$${avg.toStringAsFixed(0)}", 
          totalTripsText: totalTripsCount.toString(),
          
          // Keeps your existing mock trip array logic intact for visual timeline display
          trips: _earningsData.trips.isEmpty ? _getMockTrips() : _earningsData.trips,
        );
      }
    } catch (e) {
      debugPrint("Error loading driver earnings metric data payload: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<TripHistory> _getMockTrips() {
    return [
      TripHistory(date: "Mar 1, 2026", time: "10:30 AM", amount: 100.0, status: "Completed", pickup: "New York", dropoff: "Boston", passengers: 2),
      TripHistory(date: "Feb 28, 2026", time: "02:15 PM", amount: 45.0, status: "Completed", pickup: "Brooklyn", dropoff: "Cambridge, MA", passengers: 1),
      TripHistory(date: "Feb 26, 2026", time: "09:00 AM", amount: 150.0, status: "Completed", pickup: "Downtown NYC", dropoff: "Philadelphia", passengers: 3),
      TripHistory(date: "Feb 25, 2026", time: "06:45 PM", amount: 65.0, status: "Completed", pickup: "Queens", dropoff: "Jersey City", passengers: 2),
    ];
  }

  void navigateToWithdraw(BuildContext context) {
    context.push('/drive_withdrawal_screen');
  }

  void setAmount(double amt) {
    withdrawalAmount = amt;
    notifyListeners();
  }

  void nextStep(BuildContext context) {
    currentWithdrawalStep = 1;
    context.push('/drive_confirmwithdrawal_screen');
  }
}