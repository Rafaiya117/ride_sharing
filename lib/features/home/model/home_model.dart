class UserStats {
  final int trips;
  final double rating;
  final int upcoming;
  UserStats({required this.trips, required this.rating, required this.upcoming});
}

class UpcomingTrip {
  final String pickup;
  final String dropoff;
  final String date;
  final String time;
  final double pricePerSeat;
  final String driverName;
  final String carModel;
  UpcomingTrip({
    required this.pickup, required this.dropoff, required this.date, 
    required this.time, required this.pricePerSeat, required this.driverName, required this.carModel
  });
}