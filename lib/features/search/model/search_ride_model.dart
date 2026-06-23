// class RideResult {
//   final String departureTime;
//   final String departureDate;
//   final String pickup;
//   final String dropoff;
//   final double price;
//   final String duration;
//   final String distance;
//   final int seatsLeft;
//   final String driverName;
//   final String carModel;
//   final double driverRating;
//   final String? driverAvatarPath; 

//   RideResult({
//     required this.departureTime, required this.departureDate, required this.pickup, required this.dropoff,
//     required this.price, required this.duration, required this.distance, required this.seatsLeft,
//     required this.driverName, required this.carModel, required this.driverRating, this.driverAvatarPath
//   });
// }

class RideResult {
  final int id;
  final String departureTime;
  final String departureDate;
  final String pickup;
  final String dropoff;
  final double price;
  final int seatsLeft;
  final String driverName;
  final double driverRating;
  final String duration;
  final String distance;
  final String carModel;

  RideResult({
    required this.id, required this.departureTime, required this.departureDate,
    required this.pickup, required this.dropoff, required this.price,
    required this.seatsLeft, required this.driverName, required this.driverRating,
    required this.duration, required this.distance, required this.carModel,
  });

  factory RideResult.fromJson(Map<String, dynamic> json) {
    // FIXED: Safely parse potential String/int mix-ups to numbers before evaluation
    final int minutes = json['journey_minutes'] is int 
        ? json['journey_minutes'] 
        : (int.tryParse(json['journey_minutes']?.toString() ?? '0') ?? 0);

    final double km = json['distance_km'] is num 
        ? (json['distance_km'] as num).toDouble() 
        : (double.tryParse(json['distance_km']?.toString() ?? '0.0') ?? 0.0);

    return RideResult(
      id: json['id'] ?? 0,
      departureTime: json['date_time'] != null ? json['date_time'].toString().substring(11, 16) : '--:--',
      departureDate: json['date_time'] != null ? json['date_time'].toString().substring(0, 10) : '',
      pickup: json['pickup_location'] ?? '',
      dropoff: json['drop_location'] ?? '',
      // FIXED: Force a fallback to string '0.0' so tryParse handles double/string shapes smoothly
      price: double.tryParse(json['price_per_seat']?.toString() ?? '0.0') ?? 0.0,
      seatsLeft: json['available_seats'] ?? 0,
      driverName: json['driver_name'] ?? 'Unknown',
      // FIXED: Force a fallback to string '0.0' to prevent type comparison crashing
      driverRating: double.tryParse(json['driver_rating']?.toString() ?? '0.0') ?? 0.0,
      duration: minutes > 0 ? "${minutes}m" : "N/A",
      distance: km > 0 ? "${km.toStringAsFixed(1)} km" : "N/A",
      carModel: json['car_model'] ?? "Standard Ride", 
    );
  }
}