// class DriverProfileModel {
//   final String name;
//   final String email;
//   final String initials;
//   final int totalTrips;
//   final double rating;
//   final bool isVerified;
//   // Vehicle Details
//   final String carModel;
//   final String plateNumber;
//   final String color;
//   final int availableSeats;

//   DriverProfileModel({
//     required this.name,
//     required this.email,
//     required this.initials,
//     required this.totalTrips,
//     required this.rating,
//     required this.isVerified,
//     required this.carModel,
//     required this.plateNumber,
//     required this.color,
//     required this.availableSeats,
//   });
// }

class DriverProfileModel {
  final String name;
  final String email;
  final String initials;
  final int totalTrips;
  final double rating;
  final bool isVerified;
  // ADDED: Property field tracking variable for stripe onboarding data matching the response
  final bool stripeOnboardingComplete; 
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
    required this.stripeOnboardingComplete, // ADDED to constructor parameters
    required this.carModel,
    required this.plateNumber,
    required this.color,
    required this.availableSeats,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    final nameStr = json['name'] ?? 'User';
    final initialsStr = nameStr.trim().isNotEmpty ? nameStr.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase(): 'U';

    return DriverProfileModel(
      name: nameStr,
      email: json['email'] ?? '',
      initials: initialsStr,
      totalTrips: json['total_trips'] ?? 0,
      rating: double.tryParse(json['avg_rating']?.toString() ?? '0.0') ?? 0.0,
      isVerified: json['verification_status'] == 'approved' || json['verification_status'] == 'pending',
      // FIXED: Safely map the missing onboarding property flag here
      stripeOnboardingComplete: json['stripe_onboarding_complete'] ?? false, 
      carModel: json['car_model'] ?? "Not Provided",
      plateNumber: json['number_plate'] ?? "N/A",
      color: json['car_color'] ?? "N/A",
      availableSeats: json['available_seats'] ?? 0,
    );
  }
}