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
  String get driverName => _participantName;

  String _pickup = "Loading...";
  String get pickup => _pickup;

  String _dropoff = "Loading...";
  String get dropoff => _dropoff;

  String _date = "";
  String get date => _date;

  double _pricePerSeat = 0.0;
  double get pricePerSeat => _pricePerSeat;

  // 2. Dynamic Messages List
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages.reversed.toList();

  // 3. Controllers
  final TextEditingController messageInputController = TextEditingController();
  final TextEditingController offerInputController = TextEditingController(); 

  // 4. State for UI Swap
  bool _showOfferInput = false; 
  bool get showOfferInput => _showOfferInput;
  int? _activeOfferId;

  // --- Constructor ---
  ChatController({required this.conversationId}) {
    _loadConversationDetails();
    _initWebSocket();
  }

  // FIXED: Implemented a direct REST API call to handle mark-as-read updates cleanly
  Future<void> markAsRead() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final String? token = TokenStorage.accessToken;

    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/conversations/$conversationId/read/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        debugPrint("Chat status: ${response.data['data']['message']}");
      }
    } catch (e) {
      debugPrint("Error execution on marking conversation read receipt: $e");
    }
  }

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
          if (data['other_participant'] != null) {
            final participant = data['other_participant'];
            if (TokenStorage.isDriver) {
              _participantName = participant['name'] ?? "Passenger";
            } else {
              _participantName = participant['name'] ?? "Driver";
            }
          }

          if (data['ride'] != null) {
            final rideData = data['ride'];
            _pickup = rideData['pickup_location'] ?? "Unknown";
            _dropoff = rideData['drop_location'] ?? "Unknown";
            _pricePerSeat = double.tryParse(rideData['price_per_seat']?.toString() ?? '0') ?? 0.0;
            
            final String rawDateTime = rideData['date_time'] ?? '';
            if (rawDateTime.isNotEmpty && rawDateTime.length >= 10) {
              _date = rawDateTime.substring(0, 10);
            }
          }

          if (data['timeline'] != null) {
            final List<dynamic> timelineData = data['timeline'];
            _messages.clear();

            for (var item in timelineData) {
              if (item['type'] == 'message') {
                final int senderId = item['sender']?['id'] ?? 0;
                final String bodyText = item['body'] ?? '';
                final String createdAt = item['created_at'] ?? '';
                
                final isMe = (senderId == TokenStorage.currentUserId);

                String localizedTime = "Just now";
                if (createdAt.isNotEmpty) {
                  try {
                    final parsedTime = DateTime.parse(createdAt).toLocal();
                    localizedTime = "${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}";
                  } catch (_) {}
                }
                _messages.insert(0, ChatMessage(
                  text: bodyText,
                  time: localizedTime,
                  sender: isMe ? MessageSender.me : MessageSender.other,
                ));
              }
            }
          }

          // FIXED: Look for active negotiation keys inside the response data object on screen reloads
          final activeOffer = data['active_negotiation'] ?? data['latest_offer'] ?? data['last_message'];
          if (activeOffer != null && (activeOffer['body'] == 'accepted' || activeOffer['amount'] != null)) {
            final int senderId = activeOffer['sender_id'] ?? (activeOffer['initiated_by']?['id'] ?? 0);
            final String amountRaw = activeOffer['amount'] ?? '50.00'; 
            final String status = activeOffer['status'] ?? (activeOffer['body'] == 'accepted' ? 'accepted' : 'pending');
            _activeOfferId = activeOffer['id'];

            final String amountClean = double.tryParse(amountRaw)?.toStringAsFixed(0) ?? amountRaw;
            final bool isMe = (senderId == TokenStorage.currentUserId);

            // Inject the matching template format safely into index 0
            _messages.insert(0, ChatMessage(
              text: "💰 Price Offer: \$$amountClean ($status)",
              time: "Just now",
              sender: isMe ? MessageSender.me : MessageSender.other,
            ));
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

  void _initWebSocket() {
    _wsService.connect(conversationId);
    markAsRead(); 

    _wsService.eventStream.listen((payload) {
      final String eventType = payload['event'] ?? '';
      final dynamic eventData = payload['data'];

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
          markAsRead(); 
        }
        notifyListeners();
      } 
      else if (eventType == 'offer' && eventData != null) {
        final int senderId = eventData['sender_id'] ?? 0;
        final String amountRaw = eventData['amount'] ?? '0';
        final String status = eventData['status'] ?? 'pending';
        final String createdAt = eventData['created_at'] ?? '';

        final String amountClean = double.tryParse(amountRaw)?.toStringAsFixed(0) ?? amountRaw;

        String localizedTime = "Just now";
        if (createdAt.isNotEmpty) {
          try {
            final parsedTime = DateTime.parse(createdAt).toLocal();
            localizedTime = "${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}";
          } catch (_) {}
        }

        final isMe = (senderId == TokenStorage.currentUserId);

        _messages.insert(0, ChatMessage(
          text: "💰 Price Offer: \$$amountClean ($status)",
          time: localizedTime,
          sender: isMe ? MessageSender.me : MessageSender.other,
        ));

        notifyListeners();
      }
      else if (eventType == 'read') {
        print("Other participant read your messages.");
      }
    });
  }

  void sendMessage(BuildContext context) { 
    String text = messageInputController.text.trim();
    if (text.isNotEmpty) {
      _wsService.sendMessage(text); 
      messageInputController.clear();
    }
  }

  void toggleOfferInput(bool show) {
    _showOfferInput = show;
    if (!show) offerInputController.clear();
    notifyListeners();
  }

  Future<void> sendOffer(BuildContext context) async {
    final String amountText = offerInputController.text.trim();
    if (amountText.isEmpty) return;

    final baseUrl = dotenv.env['API_BASE_URL'];
    final String? token = TokenStorage.accessToken;

    try {
      final Map<String, dynamic> requestBody = {
        "amount": amountText,
        if (_activeOfferId != null) "parent_offer_id": _activeOfferId,
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/conversations/$conversationId/offers/', 
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        toggleOfferInput(false);
        offerInputController.clear();

        final responseData = response.data['data'];
        if (responseData != null) {
          final String amountRaw = responseData['amount'] ?? amountText;
          final String status = responseData['status'] ?? 'pending';
          final String amountClean = double.tryParse(amountRaw)?.toStringAsFixed(0) ?? amountRaw;
          
          _activeOfferId = responseData['id'];
          _messages.insert(0, ChatMessage(
            text: "💰 Price Offer: \$$amountClean ($status)",
            time: "Just now",
            sender: MessageSender.me, 
          ));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error processing price offer submission: $e");
    }
  }

  Future<void> respondToOffer(BuildContext context, String action) async {
    if (_activeOfferId == null) return;

    final baseUrl = dotenv.env['API_BASE_URL'];
    final String? token = TokenStorage.accessToken;

    try {
      final activeMsg = _messages.firstWhere(
        (msg) => msg.text.contains('💰'),
        orElse: () => ChatMessage(text: '0', time: '', sender: MessageSender.other),
      );
      final String amountStr = RegExp(r'\d+').stringMatch(activeMsg.text) ?? "50";

      final Map<String, dynamic> requestBody = {
        "amount": amountStr,
        "parent_offer_id": _activeOfferId,
        "status": action, 
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/conversations/$conversationId/offers/', 
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _messages.removeWhere((msg) => msg.text.contains('💰'));

        String customStatusText;
        if (action == 'accept') {
          customStatusText = TokenStorage.isDriver ? "Driver Accept Offer" : "User Accepted Offer";
        } else {
          customStatusText = action;
        }

        _messages.insert(0, ChatMessage(
          text: "💰 Price Offer: \$$amountStr ($customStatusText)",
          time: "Just now",
          sender: TokenStorage.isDriver ? MessageSender.me : MessageSender.other,
        ));

        notifyListeners();

        if (!TokenStorage.isDriver && action == 'accept') {
          GoRouter.of(context).push('/payment');
        }
      }
    } catch (e) {
      debugPrint("Error handling respondToOffer action request workflow: $e");
    }
  }

  void callDriver() => print("Calling $_participantName...");
  void navigateBack(BuildContext context) => Navigator.pop(context);

  @override
  void dispose() {
    _wsService.disconnect(); 
    messageInputController.dispose();
    offerInputController.dispose();
    super.dispose();
  }
}