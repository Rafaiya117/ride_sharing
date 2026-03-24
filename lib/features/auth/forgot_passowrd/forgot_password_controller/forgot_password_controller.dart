import 'package:flutter/material.dart';

class ForgotPasswordController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  void requestOTP(BuildContext context) {
    String email = emailController.text.trim();
    print("Requesting OTP for: $email");

    if (email.isNotEmpty && email.contains('@')) {
    } else {}
  }

  void navigateBackToSignIn(BuildContext context) {}

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}