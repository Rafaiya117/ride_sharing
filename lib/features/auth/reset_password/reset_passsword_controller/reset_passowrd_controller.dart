import 'package:flutter/material.dart';

class ResetPasswordController extends ChangeNotifier {
  // Text Editing Controllers for the password inputs
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // State for toggling password visibility (dynamic behavior)
  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  bool get isNewPasswordObscured => _isNewPasswordObscured;
  bool get isConfirmPasswordObscured => _isConfirmPasswordObscured;

  // Toggle methods
  void toggleNewPasswordVisibility() {
    _isNewPasswordObscured = !_isNewPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    notifyListeners();
  }

  // Submission Logic
  void resetPassword(BuildContext context) {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    print("Attempting reset: $newPassword / $confirmPassword");

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      // Basic validation
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in both fields')));
      return;
    }

    if (newPassword != confirmPassword) {
      // Basic validation
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
  }

  void navigateBackToSignIn(BuildContext context) {
    // Navigator.pop(context); // Navigates back on the stack
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}