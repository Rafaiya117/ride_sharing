class RideRequestModel {
  final String passengerName;
  final String initial;
  final double rating;
  final String pickupTimeAgo;
  final double price;
  final int seats;
  final String pickupLocation;
  final String dropoffLocation;

  RideRequestModel({
    required this.passengerName, required this.initial, required this.rating,
    required this.pickupTimeAgo, required this.price, required this.seats,
    required this.pickupLocation, required this.dropoffLocation,
  });
}