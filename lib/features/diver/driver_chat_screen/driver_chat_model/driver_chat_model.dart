enum DriverMessageSender { me, other }

class DriverChatMessage {
  final String text;
  final String time;
  final DriverMessageSender sender;

  DriverChatMessage({
    required this.text,
    required this.time,
    required this.sender,
  });
}