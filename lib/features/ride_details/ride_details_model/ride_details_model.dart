// class RideDetailsModel {
//   final double totalPrice;
//   final String date;
//   final String time;
//   final String duration;
//   final String distance;
//   final int totalSeats;
//   final String pickup;
//   final String pickupTime;
//   final String dropoff;
//   final String estArrival;
//   final String driverName;
//   final String driverInitials;
//   final double driverRating;
//   final int driverTrips;
//   final String carModel;
//   final String carLicense;
//   final String vehicleColor;

//   RideDetailsModel({
//     required this.totalPrice,
//     required this.date,
//     required this.time,
//     required this.duration,
//     required this.distance,
//     required this.totalSeats,
//     required this.pickup,
//     required this.pickupTime,
//     required this.dropoff,
//     required this.estArrival,
//     required this.driverName,
//     required this.driverInitials,
//     required this.driverRating,
//     required this.driverTrips,
//     required this.carModel,
//     required this.carLicense,
//     required this.vehicleColor,
//   });
// }

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
    required this.totalPrice, required this.date, required this.time,
    required this.duration, required this.distance, required this.totalSeats,
    required this.pickup, required this.pickupTime, required this.dropoff,
    required this.estArrival, required this.driverName, required this.driverInitials,
    required this.driverRating, required this.driverTrips, required this.carModel,
    required this.carLicense, required this.vehicleColor,
  });

  // FIXED: Added factory constructor to parse raw server network payloads cleanly
  factory RideDetailsModel.fromJson(Map<String, dynamic> json) {
    final driver = json['driver_verification'] ?? {};
    final rawDateTime = json['date_time'] ?? '';
    
    return RideDetailsModel(
      totalPrice: double.tryParse(json['price_per_seat'] ?? '0') ?? 0.0,
      date: rawDateTime.isNotEmpty ? rawDateTime.substring(0, 10) : 'N/A',
      time: rawDateTime.isNotEmpty ? rawDateTime.substring(11, 16) : '--:--',
      duration: json['journey_minutes'] != null ? "${json['journey_minutes']}m" : 'N/A',
      distance: json['distance_km'] != null ? "${json['distance_km']} km" : 'N/A',
      totalSeats: json['available_seats'] ?? 0,
      pickup: json['pickup_location'] ?? 'Unknown',
      pickupTime: rawDateTime.isNotEmpty ? rawDateTime.substring(11, 16) : '--:--',
      dropoff: json['drop_location'] ?? 'Unknown',
      estArrival: 'Est. arrival time',
      driverName: json['driver_name'] ?? 'Driver',
      driverInitials: (json['driver_name'] as String? ?? 'D').substring(0, 1).toUpperCase(),
      driverRating: double.tryParse(json['driver_rating'] ?? '0.0') ?? 0.0,
      driverTrips: 0, 
      carModel: driver['car_model'] ?? 'Standard Vehicle',
      carLicense: driver['number_plate'] ?? 'N/A',
      vehicleColor: driver['car_color'] ?? 'N/A',
    );
  }
}