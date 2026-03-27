enum TripStatus { completed, upcoming, active }

class TripHistoryModel {
  final String date;
  final String time;
  final String pickupLocation;
  final String dropoffLocation;
  final String driverName;
  final String driverInitial;
  final String carModel;
  final double rating;
  final String duration;
  final double price;
  final TripStatus status;

  TripHistoryModel({
    required this.date,
    required this.time,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.driverName,
    required this.driverInitial,
    required this.carModel,
    required this.rating,
    required this.duration,
    required this.price,
    this.status = TripStatus.completed,
  });

  // Getter to simplify rating formatting
  String get formattedRating => rating.toStringAsFixed(1);
}
