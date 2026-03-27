import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/earning/model/earning_model.dart';

class EarningsController extends ChangeNotifier {
  late EarningsModel _earningsData;
  EarningsModel get data => _earningsData;

  EarningsController() {
    _loadEarnings();
  }

  void _loadEarnings() {
    _earningsData = EarningsModel(
      totalEarnings: 1240.50,
      weeklyProgress: 0.75,
      weeklyData: [40, 70, 50, 90, 60, 80, 45], // Representing Mon-Sun
      trips: [
        TripHistory(date: "Mar 24, 2026", time: "10:30 AM", amount: 45.0, status: "Completed"),
        TripHistory(date: "Mar 23, 2026", time: "02:15 PM", amount: 32.5, status: "Completed"),
        TripHistory(date: "Mar 22, 2026", time: "09:00 AM", amount: 58.0, status: "Completed"),
      ],
    );
  }

  void navigateToWithdraw(BuildContext context) {
    // Navigate using your preferred routing (GoRouter/Navigator)
  }
}