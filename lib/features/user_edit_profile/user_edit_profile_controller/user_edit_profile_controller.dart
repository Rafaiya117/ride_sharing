import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/user_edit_profile/user_edit_profile_model/user_edit_profile_model.dart';

class EditProfileController extends ChangeNotifier {
  late UserProfile _currentUser;
  UserProfile get currentUser => _currentUser;

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, dynamic> _initialsData = {
    'letter': 'J',
    'color': const Color(0xFF1E283A), 
  };
  Map<String, dynamic> get initialsData => _initialsData;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // FIXED: Constructor updated to automatically extract storage parameters on init
  EditProfileController() {
    _loadProfileFromStorage(); 
  }

  void _loadProfileFromStorage() {
    final Map<String, dynamic>? userData = TokenStorage.userData;

    _currentUser = UserProfile(
      photoPath: userData?['profile_photo'], 
      fullName: userData?['name'] ?? 'User',
      email: userData?['email'] ?? '',
      phoneNumber: userData?['phone'] ?? '',
      homeAddress: userData?['address'] ?? '', 
    );

    // Populate controllers with values fetched directly from system storage
    fullNameController.text = _currentUser.fullName;
    emailController.text = _currentUser.email;
    phoneController.text = _currentUser.phoneNumber;
    addressController.text = _currentUser.homeAddress;
    
    if (_currentUser.fullName.isNotEmpty) {
      _initialsData['letter'] = _currentUser.fullName.trim()[0].toUpperCase();
    }
  }

  Future<void> changePhoto(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _handleImagePick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _handleImagePick(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        _currentUser.photoPath = pickedFile.path;
        print("Dynamic photo update: ${pickedFile.path}");
        notifyListeners();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
  
  Future<void> saveChanges(BuildContext context) async {
    final String? token = TokenStorage.accessToken;
    if (token == null) return;

     final Dio _dio = Dio();
     
    _isLoading = true;
    notifyListeners();

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      final response = await _dio.patch(
        '$baseUrl/api/v1/driver/profile/', 
        data: {
          "name": fullNameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "address": addressController.text.trim(),
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final updatedData = response.data['data'];
        
        // FIXED: Updates global TokenStorage so that the changes immediately reflect across other tabs
        TokenStorage.userData = updatedData; 

        // Update the local controller state model 
        _loadProfileFromStorage();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!"), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // Return to previous profile screen view
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.data?['message'] ?? "Failed to save profile changes"), backgroundColor: Colors.red),
          );
        }
      }
    } on DioException catch (e) {
      debugPrint("Dio error while patching profile profile: ${e.response?.data}");
      if (context.mounted) {
        String errorMsg = e.response?.data?['message'] ?? "Server validation rejected updates";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint("Unexpected profile exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}