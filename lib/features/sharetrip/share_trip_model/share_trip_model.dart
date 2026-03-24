class ShareTripModel {
  final String fromLocation;
  final String toLocation;
  final String departureTime;
  final String departureDate;
  final String driverName;
  final String driverCar;

  ShareTripModel({
    required this.fromLocation, required this.toLocation,
    required this.departureTime, required this.departureDate,
    required this.driverName, required this.driverCar,
  });
}