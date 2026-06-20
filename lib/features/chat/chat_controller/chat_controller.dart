import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/config/services/chat_web_socket_service.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/chat/chat_model/chat_model.dart';

class ChatController extends ChangeNotifier {
  final Dio _dio = Dio();
  final ChatWebSocketService _wsService = ChatWebSocketService();
  final int conversationId;

  // 1. Dynamic User/Trip Data
  String _participantName = "Loading...";
  String get driverName => _participantName; // Keeping your original UI getter name intact

  String get pickup => "New York, NY";
  String get dropoff => "Boston, MA";
  String get date => "Mar 6, 2026";
  double get pricePerSeat => 45.0;

  // 2. Dynamic Messages List
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages.reversed.toList();

  // 3. Controllers
  final TextEditingController messageInputController = TextEditingController();
  final TextEditingController offerInputController = TextEditingController(); 

  // 4. State for UI Swap
  bool _showOfferInput = false; 
  bool get showOfferInput => _showOfferInput;

  // --- Constructor ---
  ChatController({required this.conversationId}) {
    _loadConversationDetails();
    _initWebSocket();
  }

  /// REST API: Loads initial details from the correct conversation endpoint
  /// REST API: Loads initial details and previous conversation timeline messages
  Future<void> _loadConversationDetails() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final String? token = TokenStorage.accessToken;

    try {
      final response = await _dio.get(
        '$baseUrl/api/v1/conversations/$conversationId/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        if (data != null) {
          // 1. Map participant dynamic name details
          if (data['other_participant'] != null) {
            final participant = data['other_participant'];
            if (TokenStorage.isDriver) {
              _participantName = participant['name'] ?? "Passenger";
            } else {
              _participantName = participant['name'] ?? "Driver";
            }
          }

          // FIXED: Loop through the backend 'timeline' array to load previous messages
          if (data['timeline'] != null) {
            final List<dynamic> timelineData = data['timeline'];
            _messages.clear(); // Safe clear to avoid duplicates on reload

            for (var item in timelineData) {
              // Ensure we are processing active messages
              if (item['type'] == 'message') {
                final int senderId = item['sender']?['id'] ?? 0;
                final String bodyText = item['body'] ?? '';
                final String createdAt = item['created_at'] ?? '';
                
                // Compare sender['id'] against your current storage id
                final isMe = (senderId == TokenStorage.currentUserId);

                String localizedTime = "Just now";
                if (createdAt.isNotEmpty) {
                  try {
                    final parsedTime = DateTime.parse(createdAt).toLocal();
                    localizedTime = "${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}";
                  } catch (_) {}
                }

                // Since your UI getter uses .reversed, insert historical data 
                // at index 0 so they sort and align chronological sequence perfectly
                _messages.insert(0, ChatMessage(
                  text: bodyText,
                  time: localizedTime,
                  sender: isMe ? MessageSender.me : MessageSender.other,
                ));
              }
            }
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error loading conversation history data details: $e");
      _participantName = TokenStorage.isDriver ? "Passenger" : "Sarah Johnson";
      notifyListeners();
    }
  }
  /// WebSockets: Inits listener for incoming data events according to schema
  void _initWebSocket() {
    _wsService.connect(conversationId);
    _wsService.markAsRead(); // Mark existing notifications as read on open [cite: 15]

    _wsService.eventStream.listen((payload) {
      final String eventType = payload['event'] ?? '';
      final dynamic eventData = payload['data'];

      // Handles incoming messages [cite: 21, 25]
      if (eventType == 'message' && eventData != null) {
        final int senderId = eventData['sender_id'] ?? 0;
        final String bodyText = eventData['body'] ?? '';
        final String createdAt = eventData['created_at'] ?? '';
        
        String localizedTime = "Just now";
        if (createdAt.isNotEmpty) {
          try {
            final parsedTime = DateTime.parse(createdAt).toLocal();
            localizedTime = "${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}";
          } catch (_) {}
        }

        final isMe = (senderId == TokenStorage.currentUserId);

        _messages.insert(0, ChatMessage(
          text: bodyText,
          time: localizedTime,
          sender: isMe ? MessageSender.me : MessageSender.other,
        ));
        
        if (!isMe) {
          _wsService.markAsRead(); // Auto-read incoming messages [cite: 14]
        }
        notifyListeners();
      } 
      // Handles remote read receipts [cite: 34, 37]
      else if (eventType == 'read') {
        print("Other participant read your messages.");
        // Optional: Implement a dynamic unread/read state in your UI bubbles if needed
      }
    });
  }

  // --- Methods ---

  void toggleOfferInput(bool show) {
    _showOfferInput = show;
    if (!show) offerInputController.clear();
    notifyListeners();
  }

  void sendMessage(BuildContext context) { 
    String text = messageInputController.text.trim();
    if (text.isNotEmpty) {
      _wsService.sendMessage(text); // Dispatched safely through web-socket connection [cite: 9]
      messageInputController.clear();
    }
  }

  void sendOffer(BuildContext context) {
    if (offerInputController.text.isNotEmpty) {
      GoRouter.of(context).push('/payment');
      print("Offer Sent: ${offerInputController.text}");
      toggleOfferInput(false);
    }
  }

  void callDriver() => print("Calling $_participantName...");
  void navigateBack(BuildContext context) => Navigator.pop(context);

  @override
  void dispose() {
    _wsService.disconnect(); // Securely disconnect channels during cleanup
    messageInputController.dispose();
    offerInputController.dispose();
    super.dispose();
  }
}