import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/diver/earning/model/earning_model.dart';

class EarningsController extends ChangeNotifier {
  late EarningsModel _earningsData;
  EarningsModel get data => _earningsData;
  
  double withdrawalAmount = 0;
  int currentWithdrawalStep = 0; 

  EarningsController() {
    _loadEarnings();
  }

  void _loadEarnings() {
    _earningsData = EarningsModel(
      totalEarnings: 1240.50,
      pendingEarnings: 98.00,   
      availableEarnings: 441.00, 
      weeklyProgress: 0.75,
      weeklyData: [40, 70, 50, 90, 60, 80, 45],
      trips: [
        TripHistory(
          date: "Mar 1, 2026", 
          time: "10:30 AM", 
          amount: 100.0, 
          status: "Completed",
          pickup: "New York",    
          dropoff: "Boston",     
          passengers: 2,         
        ),
        // Added more TripHistory items
        TripHistory(
          date: "Feb 28, 2026", 
          time: "02:15 PM", 
          amount: 45.0, 
          status: "Completed",
          pickup: "Brooklyn",    
          dropoff: "Cambridge, MA",     
          passengers: 1,         
        ),
        TripHistory(
          date: "Feb 26, 2026", 
          time: "09:00 AM", 
          amount: 150.0, 
          status: "Completed",
          pickup: "Downtown NYC",    
          dropoff: "Philadelphia",     
          passengers: 3,         
        ),
        TripHistory(
          date: "Feb 25, 2026", 
          time: "06:45 PM", 
          amount: 65.0, 
          status: "Completed",
          pickup: "Queens",    
          dropoff: "Jersey City",     
          passengers: 2,         
        ),
      ],
    );
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
    //notifyListeners();
  }
}