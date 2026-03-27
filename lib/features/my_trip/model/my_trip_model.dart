class TripModel {
  final String driverName;
  // final String initial; // Removed this
  final String date;
  final String time;
  final String pickup;
  final String dropoff;
  final String price;
  final String durationOrCar;
  final double rating;
  final bool isUpcoming;

  TripModel({
    required this.driverName,
    required this.date,
    required this.time,
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.durationOrCar,
    required this.rating,
    this.isUpcoming = false,
  });

  // Dynamic getter for the initial letter
  String get initial => driverName.isNotEmpty ? driverName[0].toUpperCase() : "?";
}