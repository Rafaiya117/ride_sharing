class DriverProfileModel {
  final String name;
  final String email;
  final String initials;
  final int totalTrips;
  final double rating;
  final bool isVerified;
  // Vehicle Details
  final String carModel;
  final String plateNumber;
  final String color;
  final int availableSeats;

  DriverProfileModel({
    required this.name,
    required this.email,
    required this.initials,
    required this.totalTrips,
    required this.rating,
    required this.isVerified,
    required this.carModel,
    required this.plateNumber,
    required this.color,
    required this.availableSeats,
  });
}