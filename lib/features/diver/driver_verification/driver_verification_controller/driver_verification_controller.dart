import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DriverVerificationController extends ChangeNotifier {
  // Car Details Controllers
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  // Document Status Tracking
  bool isSelfieCaptured = false;
  bool isCarPhotoCaptured = false;
  bool isNumberPlateCaptured = false;
  bool isLicenseCaptured = false;

  bool get isAllVerified => 
    isSelfieCaptured && isCarPhotoCaptured && isNumberPlateCaptured && isLicenseCaptured;

  void toggleVerification(String type) {
    switch (type) {
      case 'selfie': isSelfieCaptured = !isSelfieCaptured; break;
      case 'car': isCarPhotoCaptured = !isCarPhotoCaptured; break;
      case 'plate': isNumberPlateCaptured = !isNumberPlateCaptured; break;
      case 'license': isLicenseCaptured = !isLicenseCaptured; break;
    }
    notifyListeners();
  }

  void submitVerification(BuildContext context) {
    if (isAllVerified) {
      //debugPrint("Verification Submitted");
      context.go('/drive_home_screen');
    }
  }

  @override
  void dispose() {
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    super.dispose();
  }
}