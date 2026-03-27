class EarningsModel {
  final double totalEarnings;
  final double weeklyProgress; // 0.0 to 1.0 for the progress bar
  final List<double> weeklyData; // For the bar chart
  final List<TripHistory> trips;

  EarningsModel({
    required this.totalEarnings,
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

  TripHistory({required this.date, required this.time, required this.amount, required this.status});
}