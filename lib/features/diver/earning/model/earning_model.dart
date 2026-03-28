class EarningsModel {
  final double totalEarnings;
  final double pendingEarnings;   
  final double availableEarnings; 
  final double weeklyProgress; 
  final List<double> weeklyData; 
  final List<TripHistory> trips;

  EarningsModel({
    required this.totalEarnings,
    required this.pendingEarnings,
    required this.availableEarnings,
    required this.weeklyProgress,
    required this.weeklyData,
    required this.trips,
  });
}

class TripHistory {
  final String date;
  final String time;
  final double amount;
  final String status;
  final String pickup;     
  final String dropoff;    
  final int passengers;   

  TripHistory({
    required this.date, 
    required this.time, 
    required this.amount, 
    required this.status,
    required this.pickup,
    required this.dropoff,
    required this.passengers,
  });
}