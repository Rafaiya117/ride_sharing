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
    final minutes = json['journey_minutes'] ?? 0;
    final km = json['distance_km'] ?? 0;

    return RideResult(
      id: json['id'] ?? 0,
      departureTime: json['date_time'] != null ? json['date_time'].toString().substring(11, 16) : '--:--',
      departureDate: json['date_time'] != null ? json['date_time'].toString().substring(0, 10) : '',
      pickup: json['pickup_location'] ?? '',
      dropoff: json['drop_location'] ?? '',
      price: double.tryParse(json['price_per_seat'] ?? '0') ?? 0.0,
      seatsLeft: json['available_seats'] ?? 0,
      driverName: json['driver_name'] ?? 'Unknown',
      driverRating: double.tryParse(json['driver_rating'] ?? '0.0') ?? 0.0,
      duration: minutes > 0 ? "${minutes}m" : "N/A",
      distance: km > 0 ? "${km} km" : "N/A",
      carModel: json['car_model'] ?? "Standard Ride", 
    );
  }
}