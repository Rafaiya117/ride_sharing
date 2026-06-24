class PostedRideModel {
  final String id;
  final String from;
  final String to;
  final String date;
  final String time;
  final String pricePerSeat;
  final String seats;
  final String postedDate;

  PostedRideModel({
    required this.id,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.pricePerSeat,
    required this.seats,
    required this.postedDate,
  });

  factory PostedRideModel.fromJson(Map<String, dynamic> json) {
    final DateTime dateTime = DateTime.tryParse(json['date_time'] ?? '') ?? DateTime.now();
    return PostedRideModel(
      id: json['id']?.toString() ?? '',
      from: json['pickup_location'] ?? '',
      to: json['drop_location'] ?? '',
      date: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
      time: "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
      pricePerSeat: json['price_per_seat']?.toString() ?? '0',
      seats: "${json['available_seats'] ?? 0}/${json['available_seats'] ?? 0}",
      postedDate: json['created_at'] != null ? json['created_at'].toString().split('T')[0] : '',
    );
  }
}

class ActiveTripModel {
  final String id;
  final String date;
  final String pickup;
  final String destination;
  final String passengerName;
  final double rating;
  final int price;
  final String duration;

  ActiveTripModel({
    required this.id,
    required this.date,
    required this.pickup,
    required this.destination,
    required this.passengerName,
    required this.rating,
    required this.price,
    required this.duration,
  });

  String get initials => passengerName.isNotEmpty ? passengerName[0].toUpperCase() : "?";
  factory ActiveTripModel.fromJson(Map<String, dynamic> json) {
    final DateTime dateTime = DateTime.tryParse(json['date_time'] ?? '') ?? DateTime.now();
    return ActiveTripModel(
      id: json['id']?.toString() ?? '',
      date: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
      pickup: json['pickup_location'] ?? '',
      destination: json['drop_location'] ?? '',
      passengerName: "Passenger", 
      rating: 5.0,
      price: double.tryParse(json['price_per_seat']?.toString() ?? '0')?.toInt() ?? 0,
      duration: "Ongoing",
    );
  }
}