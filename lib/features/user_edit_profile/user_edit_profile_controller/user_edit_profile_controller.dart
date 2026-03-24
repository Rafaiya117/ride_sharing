import 'package:flutter/material.dart';
import 'package:ride_sharing/features/user_edit_profile/user_edit_profile_model/user_edit_profile_model.dart';

class EditProfileController extends ChangeNotifier {
  // 1. Dynamic User Profile Data
  late UserProfile _currentUser;
  UserProfile get currentUser => _currentUser;

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
  void changePhoto() {
    print("Action dynamically triggered: Change photo (Placeholder logic)");
    // Logic to open image picker (requires package)
    // Update _currentUser.photoPath and notifyListeners()
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