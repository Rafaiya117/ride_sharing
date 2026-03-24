class ProfileModel {
  final String name;
  final String email;
  final String initials;
  final int totalTrips;
  final double rating;
  final double availableCredits;
  final bool isVerified;
  // future path for dynamic avatar
  final String? avatarPath; 

  ProfileModel({
    required this.name, required this.email, required this.initials, required this.totalTrips, required this.rating,
    required this.availableCredits, required this.isVerified, this.avatarPath,
  });
}