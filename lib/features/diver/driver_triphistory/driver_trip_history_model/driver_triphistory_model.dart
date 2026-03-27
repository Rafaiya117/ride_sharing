class DriverTripHistoryModel {
  final String date;
  final String pickupLocation;
  final String dropoffLocation;
  final String passengerName;
  final double rating;
  final double price;
  final String duration;

  DriverTripHistoryModel({
    required this.date,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.passengerName,
    required this.rating,
    required this.price,
    required this.duration,
  });

  // Dynamically get the first letter of the name
  String get initials => passengerName.isNotEmpty ? passengerName[0].toUpperCase() : "?";
}