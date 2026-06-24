class ProfileModel {
  final String name;
  final String email;
  final String initials;
  final int totalTrips;
  final double rating;
  final double availableCredits;
  final bool isVerified;
  final String? avatarPath; 

  ProfileModel({
    required this.name, 
    required this.email, 
    required this.initials, 
    required this.totalTrips, 
    required this.rating,
    required this.availableCredits, 
    required this.isVerified, 
    this.avatarPath,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final String parsedName = json['name'] ?? 'User';
    final String initialChar = parsedName.trim().isNotEmpty ? parsedName.trim()[0].toUpperCase() : 'U';

    return ProfileModel(
      name: parsedName,
      email: json['email'] ?? '',
      initials: initialChar,
      totalTrips: json['total_trips'] ?? 0,
      rating: double.tryParse((json['avg_rating'] ?? '0.0').toString()) ?? 0.0,
      availableCredits: double.tryParse((json['available_credits'] ?? '0.0').toString()) ?? 0.0,
      isVerified: (json['verification_status'] ?? '') == "verified" || json['verification_status'] == "approved",
      avatarPath: json['profile_photo'],
    );
  }
}