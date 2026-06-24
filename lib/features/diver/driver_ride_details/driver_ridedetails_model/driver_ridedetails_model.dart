class DriverRideDetailsModel {
  final int totalPrice;
  final String date;
  final String time;
  final String duration;
  final String distance;
  final int seats;
  final String pickupLocation;
  final String pickupTime;
  final String dropoffLocation;
  final String estArrival;
  final String passengerName;
  final String passengerInitial;
  final double rating;
  final int totalTrips;
  // FIXED: Added property to capture target passenger ID for chat room initialization
  final int passengerId; 

  DriverRideDetailsModel({
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.duration,
    required this.distance,
    required this.seats,
    required this.pickupLocation,
    required this.pickupTime,
    required this.dropoffLocation,
    required this.estArrival,
    required this.passengerName,
    required this.passengerInitial,
    required this.rating,
    required this.totalTrips,
    required this.passengerId, // FIXED
  });

  factory DriverRideDetailsModel.fromJson(Map<String, dynamic> json) {
    final DateTime dateTime = DateTime.tryParse(json['date_time'] ?? '') ?? DateTime.now();
    final List passengersList = json['passengers'] ?? [];
    Map<String, dynamic> mainPassenger = {};
    if (passengersList.isNotEmpty) {
      mainPassenger = passengersList.first is Map ? passengersList.first : {};
    }

    final String pName = mainPassenger['passenger_name'] ?? "Passenger";

    return DriverRideDetailsModel(
      totalPrice: double.tryParse(json['price_per_seat']?.toString() ?? '0')?.toInt() ?? 0,
      date: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
      time: "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
      duration: json['journey_minutes'] != null ? "${json['journey_minutes']}m" : "N/A",
      distance: json['distance_km'] != null ? "${json['distance_km']} km" : "N/A",
      seats: json['available_seats'] ?? 0,
      pickupLocation: json['pickup_location'] ?? '',
      pickupTime: "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
      dropoffLocation: json['drop_location'] ?? '',
      estArrival: "Est. arrival time",
      passengerName: pName,
      passengerInitial: pName.isNotEmpty ? pName[0].toUpperCase() : "P",
      rating: double.tryParse(mainPassenger['passenger_rating']?.toString() ?? '5.0') ?? 5.0,
      totalTrips: mainPassenger['passenger_trips'] ?? 0,
      passengerId: mainPassenger['passenger_id'] ?? 0, // FIXED: Parsed from response array
    );
  }
}