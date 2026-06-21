import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;


class ChatWebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _eventStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get eventStream => _eventStreamController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void connect(int conversationId) {
  if (_isConnected && _channel != null) return;

  final String? token = TokenStorage.accessToken ?? '';
  final String envUrl = dotenv.env['API_BASE_URL'] ?? '';

  if (token!.isEmpty || envUrl.isEmpty) {
    debugPrint('WS: No token or Base URL — aborting connect');
    return;
  }

  // FIXED: Parse the environment string safely to extract ONLY the clean host domain
  final parsedEnv = Uri.parse(envUrl);
  final String host = parsedEnv.host; 

  // Dynamically assemble the correct wss endpoint format securely
  final String url = "wss://$host/ws/chat/$conversationId/?token=$token";
  debugPrint('WS: Connecting → $url');

  try {
    final uri = Uri.parse(url);
    _channel = WebSocketChannel.connect(uri);
    _isConnected = true;

    _channel!.stream.listen(
      (data) {
        debugPrint('WS: Received → $data');
        try {
          final json = jsonDecode(data as String) as Map<String, dynamic>;
          _eventStreamController.add(json);
        } catch (e) {
          debugPrint('WS: Parse error → $e');
        }
      },
      onError: (e) {
        debugPrint('WS: Error → $e');
        _isConnected = false;
        _handleReconnect(conversationId);
      },
      onDone: () {
        debugPrint('WS: Connection closed');
        _isConnected = false;
        _handleReconnect(conversationId);
      },
      cancelOnError: false,
    );
  } catch (e) {
    debugPrint('WS: Connect failed → $e');
    _isConnected = false;
  }
}

  void sendMessage(String text) {
    if (!_isConnected || _channel == null) {
      print("WS Error: Not connected — cannot send message.");
      return;
    }
    
    final payload = {
      "action": "message",
      "body": text,
    };
    
    _channel!.sink.add(jsonEncode(payload));
  }

  // void markAsRead() {
  //   if (!_isConnected || _channel == null) return;

  //   final payload = {
  //     "action": "mark_read",
  //   };

  //   _channel!.sink.add(jsonEncode(payload));
  // }

  void _handleReconnect(int conversationId) {
    disconnect();
    Future.delayed(const Duration(seconds: 3), () => connect(conversationId));
  }

  void disconnect() {
    print("WS: Disconnecting");
    _channel?.sink.close(ws_status.normalClosure);
    _channel = null;
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _eventStreamController.close();
  }
}