// class RideRequestModel {
//   final String passengerName;
//   final String initial;
//   final double rating;
//   final String pickupTimeAgo;
//   final double price;
//   final int seats;
//   final String pickupLocation;
//   final String dropoffLocation;

//   RideRequestModel({
//     required this.passengerName, required this.initial, required this.rating,
//     required this.pickupTimeAgo, required this.price, required this.seats,
//     required this.pickupLocation, required this.dropoffLocation,
//   });
// }

class RideRequestModel {
  final String bookingId; // FIXED: Added to hold unique API path parameters
  final String passengerName;
  final String initial;
  final double rating;
  final String pickupTimeAgo;
  final double price;
  final int seats;
  final String pickupLocation;
  final String dropoffLocation;
  String status;

  RideRequestModel({
    required this.bookingId, // FIXED
    required this.passengerName, 
    required this.initial, 
    required this.rating,
    required this.pickupTimeAgo, 
    required this.price, 
    required this.seats,
    required this.pickupLocation, 
    required this.dropoffLocation,
    this.status = "pending", 
  });
}