import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/auth/forgot_passowrd/forgot_password_controller/forgot_password_controller.dart';

class OtpController extends ChangeNotifier {
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> pinControllers = List.generate(6, (_) => TextEditingController());
  
  Timer? _timer;
  int _start = 30; 
  bool _canResend = false;

  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int get start => _start;
  bool get canResend => _canResend;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  OtpController() {
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes[0].context != null) {
        FocusScope.of(focusNodes[0].context!).requestFocus(focusNodes[0]);
      }
    });
  }

  void _startTimer() {
    _canResend = false;
    _start = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _canResend = true;
        _timer?.cancel();
        notifyListeners();
      } else {
        _start--;
        notifyListeners();
      }
    });
  }

  void onPinChanged(BuildContext context, String value, int index) {
    // Fixed: Changed validation limit index up to 5 to fully back 6 fields
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
    notifyListeners(); 
  }

  void resendOtp() {
    if (_canResend) {
      for (var controller in pinControllers) {
        controller.clear();
      }
      _startTimer();
      FocusScope.of(focusNodes[0].context!).requestFocus(focusNodes[0]);
      print("Resending OTP...");
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    // 1. Combine 6 generated index values to build your target string payload
    String otpCode = pinControllers.map((controller) => controller.text).join();
    print("Verifying OTP: $otpCode");
    
    // Check validation length constraints (updated from 4 to 6)
    if (otpCode.length < 6) {
      _showSnackBar(context, "Please enter the complete 6-digit code", isError: true);
      return;
    }
    final forgotPasswordController = Provider.of<ForgotPasswordController>(context, listen: false);
    final userEmail = forgotPasswordController.emailController.text;

    if (userEmail.isEmpty) {
      _showSnackBar(context, "Session invalid. Please return and type your email again.", isError: true);
      return;
    }

    _setLoading(true);

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/auth/verify-otp/'; // Update to match your endpoint route

      // 3. Post matching structural data map objects
      final response = await _dio.post(
        url,
        data: {
          "email": userEmail,
          "code": otpCode,
        },
      );

      final responseData = response.data;
      if (responseData != null && responseData['success'] == true) {
        String successMsg = responseData['data']['message'] ?? "OTP verified.";
        _showSnackBar(context, successMsg);
        _timer?.cancel();
        context.push('/reset_password');
      } else {
        String errorMsg = responseData?['message'] ?? "Invalid OTP code";
        _showSnackBar(context, errorMsg, isError: true);
      }

    } on DioException catch (e) {
      String errorMsg = e.response?.data?['message'] ?? "Incorrect code or validation expired";
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

  void navigateBack(BuildContext context) {}

  @override
  void dispose() {
    _timer?.cancel();
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in pinControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}