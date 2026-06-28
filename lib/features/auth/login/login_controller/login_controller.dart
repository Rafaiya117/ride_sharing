// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';

class SignInController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar(context, "Please enter your email and password", isError: true);
      return;
    }

    _setLoading(true);

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/auth/login/email/'; 

      final response = await _dio.post(
        url,
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text,
        },
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        TokenStorage.accessToken = responseData['data']['access'];
        TokenStorage.userData = responseData['data']['user'];
        // FIXED: Extract and store stripe status config directly
        TokenStorage.stripeOnboardingComplete = responseData['data']['user']['stripe_onboarding_complete'] ?? false;
        
        _showSnackBar(context, "Signed in successfully!");

        final bool isDriverProfile = responseData['data']['user']['is_driver'] ?? false;
        if (isDriverProfile) {
          context.push('/drive_home_screen');
        } else {
          context.push('/user_home_screen');
        }
      } else {
        String errorMsg = responseData?['message'] ?? "Sign in failed";
        _showSnackBar(context, errorMsg, isError: true);
      }

    } on DioException catch (e) {
      final responseData = e.response?.data;
      String errorMsg = "Invalid credentials or server error";
      
      if (responseData is Map<String, dynamic>) {
        errorMsg = responseData['message'] ?? errorMsg;
      } else if (responseData is String) {
        errorMsg = responseData; 
      }
      
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

  void signInWithGoogle(BuildContext context) {}
  void forgotPassword(BuildContext context) {}

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}