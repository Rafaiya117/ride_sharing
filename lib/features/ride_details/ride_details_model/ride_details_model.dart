class RideDetailsModel {
  final double totalPrice;
  final String date;
  final String time;
  final String duration;
  final String distance;
  final int totalSeats;
  final String pickup;
  final String pickupTime;
  final String dropoff;
  final String estArrival;
  final String driverName;
  final String driverInitials;
  final double driverRating;
  final int driverTrips;
  final String carModel;
  final String carLicense;
  final String vehicleColor;

  RideDetailsModel({
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.duration,
    required this.distance,
    required this.totalSeats,
    required this.pickup,
    required this.pickupTime,
    required this.dropoff,
    required this.estArrival,
    required this.driverName,
    required this.driverInitials,
    required this.driverRating,
    required this.driverTrips,
    required this.carModel,
    required this.carLicense,
    required this.vehicleColor,
  });
}