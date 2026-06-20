import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> requestOTP(BuildContext context) async {
    String email = emailController.text;
    print("Requesting OTP for: $email");

    // 1. Core structural email validation check
    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar(context, "Please enter a valid email address", isError: true);
      return;
    }

    _setLoading(true);

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/auth/forgot-password/'; 

      // 3. Post matching payload structure map
      final response = await _dio.post(
        url,
        data: {
          "email": email,
        },
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        String successMsg = responseData['data']['message'] ?? "OTP sent to email.";
        _showSnackBar(context, successMsg);
        context.push('/otp_verification');
      } else {
        String errorMsg = responseData?['message'] ?? "Failed to request OTP";
        _showSnackBar(context, errorMsg, isError: true);
      }

    } on DioException catch (e) {
      // Handles unconfigured, missing accounts, or server processing fault states cleanly
      String errorMsg = e.response?.data?['message'] ?? "Server error occurred. Try again.";
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
    emailController.dispose();
    super.dispose();
  }
}