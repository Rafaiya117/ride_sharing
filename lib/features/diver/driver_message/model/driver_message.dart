class MessageModel {
  final String avatarUrl;
  final String name;
  final String lastMessage;
  final String timestamp;
  final bool isOnline;
  final bool isYou;

  const MessageModel({
    required this.avatarUrl,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.isOnline,
    this.isYou = false,
  });
}