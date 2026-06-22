// class TokenStorage {
//   static String? accessToken;
//   static Map<String, dynamic>? userData;
//   static String get userName => userData?['name'] ?? 'Driver';
//   static String get userEmail => userData?['email'] ?? '';
//   static String get verificationStatus => userData?['verification_status'] ?? 'not_submitted';
// }

class TokenStorage {
  static String? accessToken;
  static Map<String, dynamic>? userData;
  static int get currentUserId => userData?['id'] ?? 0;
  static bool stripeOnboardingComplete = false;

  // --- Shared Properties ---
  static String get userName => userData?['name'] ?? 'User';
  static String get userEmail => userData?['email'] ?? '';
  static String get verificationStatus => userData?['verification_status'] ?? 'not_submitted';

  // --- Driver-Specific Properties ---
  static bool get isDriver => userData?['is_driver'] ?? false;
  static int get totalTrips => userData?['total_trips'] ?? 0;
  
  // Handles parsing string values like "4.50" safely into a double
  static double get avgRating => double.tryParse((userData?['avg_rating'] ?? '0.0').toString()) ?? 0.0;
  
  static String? get profilePhoto => userData?['profile_photo'];
}