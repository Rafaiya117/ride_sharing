class UserProfile {
  String? photoPath; 
  String fullName;
  String email;
  String phoneNumber;
  String homeAddress;

  UserProfile({
    this.photoPath,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.homeAddress,
  });
}