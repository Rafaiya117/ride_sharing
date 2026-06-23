class TripModel {
  final String driverName;
  final String date;
  final String time;
  final String pickup;
  final String dropoff;
  final String price;
  final String durationOrCar;
  final double rating;
  final bool isUpcoming;
  final String status;
  final String timelineStatus;

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
    this.status = '',
    this.timelineStatus = '',
  });

  String get initial => driverName.isNotEmpty ? driverName[0].toUpperCase() : "?";

  factory TripModel.fromJson(Map<String, dynamic> json) {
    final rawDateTime = json['date_time']?.toString() ?? '';
    String parsedDate = "N/A";
    String parsedTime = "--:--";
    
    if (rawDateTime.length >= 16) {
      parsedDate = rawDateTime.substring(0, 10); // YYYY-MM-DD
      parsedTime = rawDateTime.substring(11, 16); // HH:MM
    }

    final int? minutes = json['journey_minutes'];
    final String parsedDurationOrCar = minutes != null && minutes > 0 
        ? "${minutes}m" 
        : (json['car_model'] ?? "Standard Ride");

    return TripModel(
      driverName: json['driver_name'] ?? 'Unknown',
      date: parsedDate,
      time: parsedTime,
      pickup: json['pickup_location'] ?? '',
      dropoff: json['drop_location'] ?? '',
      price: json['price_per_seat']?.toString() ?? '0',
      durationOrCar: parsedDurationOrCar,
      rating: double.tryParse(json['driver_rating']?.toString() ?? '0.0') ?? 0.0,
      status: json['status'] ?? '',
      timelineStatus: json['timeline_status'] ?? '',
      isUpcoming: json['status'] == 'booked',
    );
  }
}