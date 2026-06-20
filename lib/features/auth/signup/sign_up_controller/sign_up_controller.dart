import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/role_selection/controller/role_selection_controller.dart';

class SignUpController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

 
  // Initialize Dio
  final Dio _dio = Dio();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Future<void> createAccount(BuildContext context) async {
  //   final roleController = Provider.of<RoleController>(context, listen: false);
  //   final role = roleController.selectedRole;

  //   // Validation check
  //   if (nameController.text.isEmpty || emailController.text.isEmpty || 
  //       phoneController.text.isEmpty || passwordController.text.isEmpty) {
  //     _showSnackBar(context, "Please fill in all fields", isError: true);
  //     return;
  //   }

  //   _setLoading(true);

  //   try {
  //     // Pulling the base URL from your .env file
  //     final baseUrl = dotenv.env['API_BASE_URL'];
  //     final url = '$baseUrl/api/v1/auth/signup/'; 

  //     // Sending request with Dio
  //     final response = await _dio.post(
  //       url,
  //       data: {
  //         "name": nameController.text.trim(),
  //         "email": emailController.text.trim(),
  //         "phone": phoneController.text.trim(),
  //         "password": passwordController.text,
  //       },
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     );

  //     // Dio automatically parses JSON responses into a Map
  //     final responseData = response.data;

  //     if (responseData != null && responseData['success'] == true) {
  //       TokenStorage.accessToken = responseData['data']['access'];
  //       TokenStorage.userData = responseData['data']['user'];
  //       _showSnackBar(context, "Account created successfully!");

  //       // Navigate based on role
  //       if (role == 'driver') {
  //         context.push('/drive_verification_screen'); 
  //       } else {
  //         context.push('/user_home_screen');
  //       }
  //     } else {
  //       String errorMsg = responseData?['message'] ?? "Sign up failed";
  //       _showSnackBar(context, errorMsg, isError: true);
  //     }

  //   } on DioException catch (e) {
  //     // Catch network, timeout, or bad status code errors cleanly
  //     String errorMsg = e.response?.data?['message'] ?? "Server error occurred";
  //     _showSnackBar(context, errorMsg, isError: true);
  //   } catch (e) {
  //     _showSnackBar(context, "An unexpected error occurred", isError: true);
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future<void> createAccount(BuildContext context) async {
    final roleController = Provider.of<RoleController>(context, listen: false);
    final role = roleController.selectedRole;

    // Validation check
    if (nameController.text.isEmpty || emailController.text.isEmpty || 
        phoneController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar(context, "Please fill in all fields", isError: true);
      return;
    }

    _setLoading(true);

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/auth/signup/'; 

      final bool isDriverRole = (role == 'driver');
      final response = await _dio.post(
        url,
        data: {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "password": passwordController.text,
          "is_driver": isDriverRole, 
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        TokenStorage.accessToken = responseData['data']['access'];
        TokenStorage.userData = responseData['data']['user'];
        _showSnackBar(context, "Account created successfully!");
        if (isDriverRole) {
          context.push('/drive_verification_screen'); 
        } else {
          context.push('/user_home_screen');
        }
      } else {
        String errorMsg = responseData?['message'] ?? "Sign up failed";
        _showSnackBar(context, errorMsg, isError: true);
      }

    } on DioException catch (e) {
      // Catch network, timeout, or bad status code errors cleanly
      String errorMsg = e.response?.data?['message'] ?? "Server error occurred";
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

  void signUpWithGoogle(BuildContext context) {}

  void navigateToSignIn(BuildContext context) {
    context.push('/sign_in');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}