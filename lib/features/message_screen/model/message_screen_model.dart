// class MessageModel {
//   final String avatarUrl;
//   final String name;
//   final String lastMessage;
//   final String timestamp;
//   final bool isOnline;
//   final bool isYou;

//   const MessageModel({
//     required this.avatarUrl,
//     required this.name,
//     required this.lastMessage,
//     required this.timestamp,
//     required this.isOnline,
//     this.isYou = false,
//   });
// }

class MessageModel {
  final int id;
  final String avatarUrl;
  final String name;
  final String lastMessage;
  final String timestamp;
  final bool isOnline;
  final bool isYou;
  final bool isDriver;

  const MessageModel({
    required this.id,
    required this.avatarUrl,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.isOnline,
    this.isYou = false,
    required this.isDriver,
  });


  factory MessageModel.fromJson(Map<String, dynamic> json, String defaultAvatar) {
    final participant = json['other_participant'] as Map<String, dynamic>?;

    return MessageModel(
      id: json['id'] ?? 0, 
      name: participant != null ? (participant['name'] ?? 'Unknown') : 'Unknown', // Safe extraction of "rushdha"
      avatarUrl: participant != null ? (participant['profile_photo'] ?? defaultAvatar) : defaultAvatar,
      isDriver: participant != null ? (participant['is_driver'] ?? false) : false,
      lastMessage: json['last_message']?['body'] ?? "Tap to start conversation", // Extracting last message safely if available
      timestamp: json['updated_at'] != null ? _parseTime(json['updated_at']) : "Just now",
      isOnline: true,
    );
  }

  static String _parseTime(String timestampStr) {
    try {
      final parsed = DateTime.parse(timestampStr).toLocal();
      return "${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return "Just now";
    }
  }
}