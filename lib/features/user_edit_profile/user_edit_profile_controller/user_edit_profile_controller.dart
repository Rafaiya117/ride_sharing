import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing/features/user_edit_profile/user_edit_profile_model/user_edit_profile_model.dart';

class EditProfileController extends ChangeNotifier {
  // 1. Dynamic User Profile Data
  late UserProfile _currentUser;
  UserProfile get currentUser => _currentUser;

  final ImagePicker _picker = ImagePicker();

  // 2. Local State Variables (Mocked from image_10.png)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, dynamic> _initialsData = {
    'letter': 'J',
    'color': const Color(0xFF1E283A), 
  };
  Map<String, dynamic> get initialsData => _initialsData;

  // 3. Controllers for text fields (allows dynamic updates)
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  EditProfileController() {
    _mockInitialData(); // Load data when controller is created
  }

  // standard dynamic logic for loading profile data
  void _mockInitialData() {
    _currentUser = UserProfile(
      photoPath: null, 
      fullName: 'John Doe',
      email: 'safimahmud1412@gmail.com',
      phoneNumber: '+8801728583881',
      homeAddress: '123 Main St, City, State',
    );

    // Dynamic price logic standard: Update controllers with initial values
    fullNameController.text = _currentUser.fullName;
    emailController.text = _currentUser.email;
    phoneController.text = _currentUser.phoneNumber;
    addressController.text = _currentUser.homeAddress;
  }

  // --- Methods ---

  // standardized MVC logic
  Future<void> changePhoto(BuildContext context) async {
    // Standard design: Show a bottom sheet to choose between Gallery or Camera
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
        maxWidth: 512, // Standard optimization for avatars
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Update your model path dynamically
        // _profile = _profile.copyWith(photoPath: pickedFile.path); 
        
        print("Dynamic photo update: ${pickedFile.path}");
        notifyListeners();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
  
  // standardized mvc logic for saving a model standard price logic
  void saveChanges() {
    print("Action dynamically triggered: Save changes (Placeholder logic)");
    _isLoading = true;
    notifyListeners();

    // Mock API delay
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading = false;
      notifyListeners();
      // Logic to send updated text field data to an API
      print("Dynamic updates applied locally to model: ");
      print("Name: ${fullNameController.text}");
    });
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