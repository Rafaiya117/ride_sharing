enum MessageSender { me, other }

class ChatMessage {
  final String text;
  final String time;
  final MessageSender sender;

  ChatMessage({required this.text, required this.time, required this.sender});
}