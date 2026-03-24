class RideResult {
  final String departureTime;
  final String departureDate;
  final String pickup;
  final String dropoff;
  final double price;
  final String duration;
  final String distance;
  final int seatsLeft;
  final String driverName;
  final String carModel;
  final double driverRating;
  final String? driverAvatarPath; 

  RideResult({
    required this.departureTime, required this.departureDate, required this.pickup, required this.dropoff,
    required this.price, required this.duration, required this.distance, required this.seatsLeft,
    required this.driverName, required this.carModel, required this.driverRating, this.driverAvatarPath
  });
}