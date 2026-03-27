import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DriverEditController extends ChangeNotifier {
  // Mock Data matching the image
  final TextEditingController nameController = TextEditingController(text: "John Doe");
  final TextEditingController emailController = TextEditingController(text: "safimahmud1412@gmail.com");
  final TextEditingController phoneController = TextEditingController(text: "+8801728583881");
  final TextEditingController addressController = TextEditingController(text: "123 Main St, City, State");

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      notifyListeners();
    }
  }

  void saveChanges(BuildContext context) {
    debugPrint("Saving Driver Profile: ${nameController.text}");
    // Add API logic here
    Navigator.pop(context);
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