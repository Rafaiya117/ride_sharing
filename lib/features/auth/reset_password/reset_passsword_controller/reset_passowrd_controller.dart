import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/auth/forgot_passowrd/forgot_password_controller/forgot_password_controller.dart';
import 'package:ride_sharing/features/auth/verify_otp/verify_otp_controller/verify_otp_controller.dart';

class ResetPasswordController extends ChangeNotifier {
  // Text Editing Controllers for the password inputs
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // State for toggling password visibility (dynamic behavior)
  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  bool get isNewPasswordObscured => _isNewPasswordObscured;
  bool get isConfirmPasswordObscured => _isConfirmPasswordObscured;

  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Toggle methods remain perfectly untouched
  void toggleNewPasswordVisibility() {
    _isNewPasswordObscured = !_isNewPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    notifyListeners();
  }

  // Updated Submission Logic
  Future<void> resetPassword(BuildContext context) async {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    print("Attempting reset: $newPassword / $confirmPassword");

    // 1. Basic UI validation validation check blocks
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar(context, "Please fill in both fields", isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar(context, "Passwords do not match", isError: true);
      return;
    }

    final forgotPasswordController = Provider.of<ForgotPasswordController>(context, listen: false);
    final otpController = Provider.of<OtpController>(context, listen: false);

    final userEmail = forgotPasswordController.emailController.text.trim();
    // Combines separate pins array straight to a single data string token
    final otpCode = otpController.pinControllers.map((c) => c.text).join();

    if (userEmail.isEmpty || otpCode.length < 6) {
      _showSnackBar(context, "Session expired. Please restart the forgot password flow.", isError: true);
      return;
    }

    _setLoading(true);

    try {
      // 3. Setup configuration params using .env keys
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/auth/reset-password/'; // Update to match your endpoint route

      // 4. Fire network mapping data structure
      final response = await _dio.post(
        url,
        data: {
          "email": userEmail,
          "code": otpCode,
          "new_password": newPassword,
        },
      );

      final responseData = response.data;

      // 5. Handle response conditions matching your format rules
      if (responseData != null && responseData['success'] == true) {
        String successMsg = responseData['data']['message'] ?? "Password reset successful.";
        _showSnackBar(context, successMsg);

        // 6. Navigate back to Sign-In screen cleanly on success
        context.push('/sign_in');
      } else {
        String errorMsg = responseData?['message'] ?? "Failed to reset password";
        _showSnackBar(context, errorMsg, isError: true);
      }

    } on DioException catch (e) {
      String errorMsg = e.response?.data?['message'] ?? "Server error occurred. Please try again.";
      _showSnackBar(context, errorMsg, isError: true);
    } catch (e) {
      _showSnackBar(context, "An unexpected error occurred", isError: true);
    } finally {
      _setLoading(false);
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void navigateBackToSignIn(BuildContext context) {
    context.push('/sign_in');
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}