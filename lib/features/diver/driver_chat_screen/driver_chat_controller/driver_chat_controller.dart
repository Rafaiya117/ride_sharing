import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/driver_chat_screen/driver_chat_model/driver_chat_model.dart';

class DriverChatController extends ChangeNotifier {
  // 1. Dynamic Rider/Trip Data
  String get riderName => "Sarah Johnson";
  String get pickup => "New York, NY";
  String get dropoff => "Boston, MA";
  String get date => "Mar 6, 2026";
  double get pricePerSeat => 45.0;

  // 2. Dynamic Messages List
  final List<DriverChatMessage> _messages = [
    DriverChatMessage(text: "Perfect. Looking forward to the trip!", time: "10:36 AM", sender: DriverMessageSender.me),
    DriverChatMessage(text: "Sure thing! I'll give you a call when I'm nearby.", time: "10:35 AM", sender: DriverMessageSender.other),
    DriverChatMessage(text: "Great! See you at 9:00 AM. Can you please call me when you arrive?", time: "10:32 AM", sender: DriverMessageSender.me),
    DriverChatMessage(text: "Hi! I'll be picking you up at the agreed location.", time: "10:30 AM", sender: DriverMessageSender.other),
  ];

  List<DriverChatMessage> get messages => _messages.reversed.toList();

  // 3. Controllers
  final TextEditingController messageInputController = TextEditingController();
  final TextEditingController offerInputController = TextEditingController(); 

  // 4. State for UI Swap
  bool _showOfferInput = false; 
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
      _messages.insert(0, DriverChatMessage(
        text: text,
        time: TimeOfDay.now().format(context),
        sender: DriverMessageSender.me,
      )); 
      messageInputController.clear();
      notifyListeners();
    }
  }

  void sendOffer(BuildContext context) {
    if (offerInputController.text.isNotEmpty) {
      // Direct console log context or routing fallback
      print("Driver Counter Offer Sent: ${offerInputController.text}");
      toggleOfferInput(false);
    }
  }

  void callRider() => print("Calling $riderName...");
  void navigateBack(BuildContext context) => Navigator.pop(context);

  @override
  void dispose() {
    messageInputController.dispose();
    offerInputController.dispose();
    super.dispose();
  }
}