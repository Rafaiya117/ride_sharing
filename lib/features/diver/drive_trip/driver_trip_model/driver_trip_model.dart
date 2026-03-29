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

  // Dynamic initial from name
  String get initials => passengerName.isNotEmpty ? passengerName[0].toUpperCase() : "?";
}