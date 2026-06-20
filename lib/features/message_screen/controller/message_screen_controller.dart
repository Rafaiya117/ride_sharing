import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/message_screen/model/message_screen_model.dart';

class MessageController extends ChangeNotifier {
  final Dio _dio = Dio();
  
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentNavbarIndex = 3;
  int get currentNavbarIndex => _currentNavbarIndex;

  MessageController() {
    fetchMessages();
  }

  Future<void> fetchMessages() async {
  _isLoading = true;
  notifyListeners();

  const String defaultAvatar = 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';
  final url = dotenv.env['API_BASE_URL']; 
  final String? token = TokenStorage.accessToken; 

  try {
    // FIXED: Changed endpoint to the correct conversations endpoint
    final response = await _dio.get(
      '$url/api/v1/conversations/',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data;
      print('FETCH_MESSAGES_DATA: $responseData');

      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> results = responseData['data']['results'] ?? [];
        
        // FIXED: Parsing the conversation payload list directly
        _messages = results.map((convJson) {
          return MessageModel.fromJson(convJson, defaultAvatar);
        }).toList(); 
      }
    }
  } on DioException catch (e) {
    print('Dio error during fetching conversations: ${e.message}');
  } catch (e) {
    print('Unexpected error during fetching conversations: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
  // FIXED: Added dedicated search query handler matching the list payload array schema
  Future<void> searchMessages(String query) async {
    if (query.trim().isEmpty) {
      await fetchMessages();
      return;
    }

    _isLoading = true;
    notifyListeners();

    const String defaultAvatar = 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';
    final url = dotenv.env['API_BASE_URL']; 
    final String? token = TokenStorage.accessToken; 

    try {
      final response = await _dio.get(
        '$url/api/v1/users/search/',
        queryParameters: {'q': query}, // Passes the string text safely into the query path
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true && responseData['data'] != null) {
          // The search response uses a direct array structure under data: {"success": true, "data": [...]}
          final List<dynamic> searchDataList = responseData['data'] ?? [];
          final List<MessageModel> parsedSearch = searchDataList.map((userJson) {
            return MessageModel.fromJson(userJson, defaultAvatar);
          }).toList();

          _messages = parsedSearch.where((user) => user.isDriver == false).toList();
        }
      }
    } on DioException catch (e) {
      print('Dio search error: ${e.message}');
    } catch (e) {
      print('Unexpected error during search: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }
}