class DriverModel {
  final String name;
  final String avatarPath;
  final String carModel;
  final String carPlate;
  final double rating;

  DriverModel({
    required this.name, 
    required this.avatarPath, 
    required this.carModel, 
    required this.carPlate, 
    required this.rating
  });

  // Fixed: Added getter to handle initials dynamically for the avatar
  String get driverInitials {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(" ");
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}