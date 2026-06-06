class TokenStorage {
  static String? accessToken;
  static Map<String, dynamic>? userData;
  static String get userName => userData?['name'] ?? 'Driver';
  static String get userEmail => userData?['email'] ?? '';
  static String get verificationStatus => userData?['verification_status'] ?? 'not_submitted';
}