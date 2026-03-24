import 'package:flutter/material.dart';

class SignUpController extends ChangeNotifier {
  // Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void createAccount(BuildContext context) {
    print("Creating account for: ${nameController.text}");}

  void signUpWithGoogle(BuildContext context) {
  }

  void navigateToSignIn(BuildContext context) {}

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}