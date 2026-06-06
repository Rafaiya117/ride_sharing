import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing/core/token/token_storage.dart';

class DriverEditController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController(text: "John Doe");
  final TextEditingController emailController = TextEditingController(text: "safimahmud1412@gmail.com");
  final TextEditingController phoneController = TextEditingController(text: "+8801728583881");
  final TextEditingController addressController = TextEditingController(text: "123 Main St, City, State");

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Dynamic Initials calculator matching active name text changes
  String get initials {
    final nameText = nameController.text.trim();
    if (nameText.isEmpty) return 'U';
    return nameText.split(' ').map((l) => l[0]).take(1).join().toUpperCase();
  }

  DriverEditController() {
    // Synchronize current TokenStorage details into inputs if available
    if (TokenStorage.userData != null) {
      nameController.text = TokenStorage.userData?['name'] ?? '';
      emailController.text = TokenStorage.userData?['email'] ?? '';
      phoneController.text = TokenStorage.userData?['phone'] ?? '';
      addressController.text = TokenStorage.userData?['address'] ?? '';
    }
    
    // Listen to name changes to automatically update initials real-time
    nameController.addListener(() => notifyListeners());
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      notifyListeners();
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    debugPrint("Saving Driver Profile: ${nameController.text}");
    
    final token = TokenStorage.accessToken;
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/driver/profile/'; // Replace with your exact update endpoint

      // Prepare standard data payload layout
      final Map<String, dynamic> payload = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
      };

      // Optional: If handling multipart image updates later, swap data parameter for FormData.fromMap
      final response = await _dio.patch(
        url,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        // Update local session storage dictionary properties dynamically
        TokenStorage.userData = responseData['data'];

        _showSnackBar(context, "Profile updated successfully!");
        if (context.mounted) {
          // FIXED: Pass true back through the router pipeline
          Navigator.pop(context, true); 
        }
      }
    } catch (e) {
      debugPrint("Error updating driver profile data: ${e.toString()}");
      _showSnackBar(context, "Failed to update profile", isError: true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}