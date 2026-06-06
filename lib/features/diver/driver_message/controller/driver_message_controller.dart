import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/driver_message/model/driver_message.dart';

class MessageController extends ChangeNotifier {
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  int _currentNavbarIndex = 3;
  int get currentNavbarIndex => _currentNavbarIndex;

  MessageController() {
    fetchMessages();
  }

  void fetchMessages() {
    const String defaultAvatar = 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';
    
    _messages = const [
      MessageModel(
        avatarUrl: defaultAvatar,
        name: "Sarah Wilson",
        lastMessage: "You: hi",
        timestamp: "45 min",
        isOnline: true,
        isYou: true,
      ),
      MessageModel(
        avatarUrl: defaultAvatar,
        name: "Mike Chen",
        lastMessage: "Hello",
        timestamp: "1 d",
        isOnline: true,
      ),
      MessageModel(
        avatarUrl: defaultAvatar,
        name: "Alex Kumar",
        lastMessage: "Hello",
        timestamp: "Jan 20",
        isOnline: true,
      ),
      MessageModel(
        avatarUrl: defaultAvatar,
        name: "Alex Kumar",
        lastMessage: "Hello",
        timestamp: "Jan 20",
        isOnline: true,
      ),
      MessageModel(
        avatarUrl: defaultAvatar,
        name: "Alex Kumar",
        lastMessage: "Hello",
        timestamp: "Jan 20",
        isOnline: true,
      ),
      MessageModel(
        avatarUrl: defaultAvatar,
        name: "Alex Kumar",
        lastMessage: "Hello",
        timestamp: "Jan 20",
        isOnline: true,
      ),
      MessageModel(
        avatarUrl: defaultAvatar,
        name: "Alex Kumar",
        lastMessage: "Hello",
        timestamp: "Jan 20",
        isOnline: true,
      ),
    ];
    notifyListeners();
  }

  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }

}