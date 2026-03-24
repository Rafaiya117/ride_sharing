import 'dart:async';
import 'package:flutter/material.dart';

class OtpController extends ChangeNotifier {
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> pinControllers = List.generate(4, (_) => TextEditingController());
  
  // Timer state for resending OTP
  Timer? _timer;
  int _start = 30; 
  bool _canResend = false;

  int get start => _start;
  bool get canResend => _canResend;

  OtpController() {
    _startTimer();
    // Auto-focus the first field upon initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(focusNodes[0].context!).requestFocus(focusNodes[0]);
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
    if (value.isNotEmpty && index < 3) {
      // Auto-focus the next field
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Handle backspace auto-focus (optional improvement)
      // FocusScope.of(context).requestFocus(focusNodes[index - 1]);
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

  void verifyOtp(BuildContext context) {
    // Combine pins to form the full code
    String otpCode = pinControllers.map((controller) => controller.text).join();
    print("Verifying OTP: $otpCode");
    
    // Perform API call or navigation logic
    if (otpCode.length == 4) {
      // GoRouter.of(context).push('/resetPassword');
    } else {}
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