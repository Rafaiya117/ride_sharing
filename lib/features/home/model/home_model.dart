class UserStats {
  final int trips;
  final double rating;
  final int upcoming;
  UserStats({required this.trips, required this.rating, required this.upcoming});
}

class UpcomingTrip {
  final int rideId; // FIXED: Tracks specific backend ride ID instead of layout index
  final String pickup;
  final String dropoff;
  final String date;
  final String time;
  final double pricePerSeat;
  final String driverName;
  final String carModel;
  final String status;          
  final String timelineStatus;  

  UpcomingTrip({
    required this.rideId, // FIXED: Required identifier initialization
    required this.pickup, 
    required this.dropoff, 
    required this.date, 
    required this.time, 
    required this.pricePerSeat, 
    required this.driverName, 
    required this.carModel,
    required this.status,
    required this.timelineStatus,
  });
}