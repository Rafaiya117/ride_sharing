class DriverRideDetailsModel {
  final int totalPrice;
  final String date;
  final String time;
  final String duration;
  final String distance;
  final int seats;
  final String pickupLocation;
  final String pickupTime;
  final String dropoffLocation;
  final String estArrival;
  final String passengerName;
  final String passengerInitial;
  final double rating;
  final int totalTrips;

  DriverRideDetailsModel({
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.duration,
    required this.distance,
    required this.seats,
    required this.pickupLocation,
    required this.pickupTime,
    required this.dropoffLocation,
    required this.estArrival,
    required this.passengerName,
    required this.passengerInitial,
    required this.rating,
    required this.totalTrips,
  });
}
