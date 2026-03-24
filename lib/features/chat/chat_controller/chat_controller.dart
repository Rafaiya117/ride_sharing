import 'package:flutter/material.dart';
import 'package:ride_sharing/features/chat/chat_model/chat_model.dart';

class ChatController extends ChangeNotifier {
  // 1. Dynamic User/Trip Data
  String get driverName => "Sarah Johnson";
  String get pickup => "New York, NY";
  String get dropoff => "Boston, MA";
  String get date => "Mar 6, 2026";
  double get pricePerSeat => 45.0;

  // 2. Dynamic Messages List
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Perfect. Looking forward to the trip!", time: "10:36 AM", sender: MessageSender.me),
    ChatMessage(text: "Sure thing! I'll give you a call when I'm nearby.", time: "10:35 AM", sender: MessageSender.other),
    ChatMessage(text: "Great! See you at 9:00 AM. Can you please call me when you arrive?", time: "10:32 AM", sender: MessageSender.me),
    ChatMessage(text: "Hi! I'll be picking you up at the agreed location.", time: "10:30 AM", sender: MessageSender.other),
  ];

  List<ChatMessage> get messages => _messages.reversed.toList();

  // 3. Controllers
  final TextEditingController messageInputController = TextEditingController();
  final TextEditingController offerInputController = TextEditingController(); // Added for Offer

  // 4. State for UI Swap
  bool _showOfferInput = false; // Controls which UI to show
  bool get showOfferInput => _showOfferInput;

  // --- Methods ---

  void toggleOfferInput(bool show) {
    _showOfferInput = show;
    if (!show) offerInputController.clear();
    notifyListeners();
  }

  void sendMessage(BuildContext context) { 
    String text = messageInputController.text.trim();
    if (text.isNotEmpty) {
      _messages.insert(0, ChatMessage(
        text: text,
        time: TimeOfDay.now().format(context),
        sender: MessageSender.me,
      )); 
      messageInputController.clear();
      notifyListeners();
    }
  }

  void sendOffer(BuildContext context) {
    if (offerInputController.text.isNotEmpty) {
      print("Offer Sent: ${offerInputController.text}");
      toggleOfferInput(false);
    }
  }

  void callDriver() => print("Calling $driverName...");
  void navigateBack(BuildContext context) => Navigator.pop(context);

  @override
  void dispose() {
    messageInputController.dispose();
    offerInputController.dispose();
    super.dispose();
  }
}