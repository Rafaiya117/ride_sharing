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
  final String status; // FIXED: Added parameter tracking for conditional UI rendering

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
    required this.status, // FIXED
  });

  String get initials => passengerName.isNotEmpty ? passengerName[0].toUpperCase() : "?";

  // FIXED: Handles dynamic structural parsing mappings straight from your API JSON response
  factory DriverTrackModel.fromJson(Map<String, dynamic> json) {
    final List passengersList = json['passengers'] ?? [];
    String pName = "Sarah Johnson"; 
    if (passengersList.isNotEmpty && passengersList.first is Map) {
      pName = passengersList.first['passenger_name'] ?? pName;
    }

    return DriverTrackModel(
      passengerName: pName,
      carModel: "Honda Accord 2022", 
      carPlate: "ABC 1234",
      estimatedArrival: json['journey_minutes'] != null ? "${json['journey_minutes']}m remaining" : "2h 45m",
      progress: 0.63, 
      currentStatus: json['timeline_status'] ?? "Approaching destination",
      pickup: json['pickup_location'] ?? '',
      destination: json['drop_location'] ?? '',
      distance: json['distance_km'] != null ? "${json['distance_km']} km" : "215 miles",
      duration: json['journey_minutes'] != null ? "${json['journey_minutes']} min" : "4h 30m",
      price: double.tryParse(json['price_per_seat']?.toString() ?? '45')?.toInt() ?? 45,
      status: json['status'] ?? 'active',
    );
  }
}