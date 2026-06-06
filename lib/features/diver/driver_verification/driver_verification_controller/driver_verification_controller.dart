import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:ride_sharing/core/token/token_storage.dart';
// class DriverVerificationController extends ChangeNotifier {
//   // Car Details Controllers
//   final TextEditingController modelController = TextEditingController();
//   final TextEditingController yearController = TextEditingController();
//   final TextEditingController colorController = TextEditingController();

//   // Document Status Tracking
//   bool isSelfieCaptured = false;
//   bool isCarPhotoCaptured = false;
//   bool isNumberPlateCaptured = false;
//   bool isLicenseCaptured = false;

//   bool get isAllVerified => 
//     isSelfieCaptured && isCarPhotoCaptured && isNumberPlateCaptured && isLicenseCaptured;

//   void toggleVerification(String type) {
//     switch (type) {
//       case 'selfie': isSelfieCaptured = !isSelfieCaptured; break;
//       case 'car': isCarPhotoCaptured = !isCarPhotoCaptured; break;
//       case 'plate': isNumberPlateCaptured = !isNumberPlateCaptured; break;
//       case 'license': isLicenseCaptured = !isLicenseCaptured; break;
//     }
//     notifyListeners();
//   }

//   void submitVerification(BuildContext context) {
//     if (isAllVerified) {
//       //debugPrint("Verification Submitted");
//       context.go('/drive_home_screen');
//     }
//   }

//   @override
//   void dispose() {
//     modelController.dispose();
//     yearController.dispose();
//     colorController.dispose();
//     super.dispose();
//   }
// }

class DriverVerificationController extends ChangeNotifier {
  // Car Details Controllers
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController numberPlateController = TextEditingController(); // Fields for number_plate string data

  // Document Status Tracking
  bool isSelfieCaptured = false;
  bool isCarPhotoCaptured = false;
  bool isNumberPlateCaptured = false;
  bool isLicenseCaptured = false;

  // Real File Paths matching the required form data files
  String? selfiePath;
  String? carPhotoPath;
  String? numberPlatePhotoPath;
  String? drivingLicensePath;

  // Network configuration parameters
  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Pure validation state tracker remains untouched
  bool get isAllVerified => 
    isSelfieCaptured && isCarPhotoCaptured && isNumberPlateCaptured && isLicenseCaptured;

  void toggleVerification(String type, {String? filePath}) {
    switch (type) {
      case 'selfie': 
        isSelfieCaptured = !isSelfieCaptured; 
        selfiePath = filePath;
        break;
      case 'car': 
        isCarPhotoCaptured = !isCarPhotoCaptured; 
        carPhotoPath = filePath;
        break;
      case 'plate': 
        isNumberPlateCaptured = !isNumberPlateCaptured; 
        numberPlatePhotoPath = filePath;
        break;
      case 'license': 
        isLicenseCaptured = !isLicenseCaptured; 
        drivingLicensePath = filePath;
        break;
    }
    notifyListeners();
  }

  Future<void> submitVerification(BuildContext context) async {
    if (!isAllVerified) return;

    // Fast fail check for missing text parameters
    if (modelController.text.isEmpty || yearController.text.isEmpty || 
        colorController.text.isEmpty) {
      _showSnackBar(context, "Please complete all car text detail fields", isError: true);
      return;
    }

    // Retrieve the saved access token
    final token = TokenStorage.accessToken;
    if (token == null) {
      _showSnackBar(context, "Authentication session missing. Please sign up again.", isError: true);
      return;
    }

    _setLoading(true);

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/driver/verification/'; 

      // Bundle structural schema parameters and dynamic files to FormData map
      final formData = FormData.fromMap({
        "car_model": modelController.text.trim(),
        "car_year": int.tryParse(yearController.text.trim()) ?? 0,
        "car_color": colorController.text.trim(),

        "selfie": await MultipartFile.fromFile(
          selfiePath!, 
          filename: p.basename(selfiePath!),
        ),
        "car_photo": await MultipartFile.fromFile(
          carPhotoPath!, 
          filename: p.basename(carPhotoPath!),
        ),
        "number_plate_photo": await MultipartFile.fromFile(
          numberPlatePhotoPath!, 
          filename: p.basename(numberPlatePhotoPath!),
        ),
        "driving_license": await MultipartFile.fromFile(
          drivingLicensePath!, 
          filename: p.basename(drivingLicensePath!),
        ),
      });

      // Pass the Bearer token safely via Dio Options headers parameter
      final response = await _dio.post(
        url, 
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      
      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        _showSnackBar(context, "Verification submitted successfully!");
        context.go('/drive_home_screen');
      } else {
        String errorMsg = responseData?['message'] ?? "Submission failed";
        _showSnackBar(context, errorMsg, isError: true);
      }

    } on DioException catch (e) {
      String errorMsg = e.response?.data?['message'] ?? "Server validation error occurred";
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

  @override
  void dispose() {
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    numberPlateController.dispose();
    super.dispose();
  }
}