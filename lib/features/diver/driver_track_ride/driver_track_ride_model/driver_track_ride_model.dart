class DriverTrackModel {
  final String passengerName;
  final String carModel;
  final String carPlate;
  final String estimatedArrival;
  final double progress; // e.g., 0.63 for 63%
  final String currentStatus; // e.g., "Approaching Hartford, CT"
  final String pickup;
  final String destination;
  final String distance;
  final String duration;
  final int price;

  DriverTrackModel({
    required this.passengerName,
    required this.carModel,
    required this.carPlate,
    required this.estimatedArrival,
    required this.progress,
    required this.currentStatus,
    required this.pickup,
    required this.destination,
    required this.distance,
    required this.duration,
    required this.price,
  });

  String get initials => passengerName.isNotEmpty ? passengerName[0].toUpperCase() : "?";
}