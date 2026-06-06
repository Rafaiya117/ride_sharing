import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/diver/confirm_widthdrawal/confirm_withdrawal_model/confirm_withdrawal_model.dart';

class ConfirmWithdrawalController extends ChangeNotifier {
  late ConfirmWithdrawalModel _withdrawalData;
  ConfirmWithdrawalModel get data => _withdrawalData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Dio _dio = Dio(); 
  ConfirmWithdrawalController() {
    _loadData();
  }

  void _loadData() {
    _withdrawalData = ConfirmWithdrawalModel(
      amount: 50.00,
      date: "Feb 23, 2026",
      methodTitle: "Card Payment",
      methodSubtitle: "Withdrawal to Stripe",
    );
  }

  Future<void> confirmAndWithdraw(BuildContext context) async {
    final token = TokenStorage.accessToken;
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    debugPrint("Processing withdrawal of \$${_withdrawalData.amount}");

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/withdraw/request/'; 

      final response = await _dio.post(
        url,
        data: {
          "amount": _withdrawalData.amount.toStringAsFixed(0), 
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        _showSnackBar(context, "Withdrawal processed successfully!");
        if (context.mounted) {
          context.push('/drive_bookingconfirm_screen');
        }
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      
      if (responseData != null && responseData['errors'] != null) {
        final errors = responseData['errors'];
        if (errors['amount'] is List && (errors['amount'] as List).isNotEmpty) {
          _showSnackBar(context, errors['amount'][0].toString(), isError: true);
          return;
        }
        if (errors['amount'] is String) {
          _showSnackBar(context, errors['amount'].toString(), isError: true);
          return;
        }
        if (responseData['message'] != null) {
          _showSnackBar(context, responseData['message'].toString(), isError: true);
          return;
        }
      }
      _showSnackBar(context, "Withdrawal submission rejected by server.", isError: true);
    }
  }

  void updateWithdrawalAmount(double dynamicAmount) {
    _withdrawalData = ConfirmWithdrawalModel(
      amount: dynamicAmount, 
      date: _withdrawalData.date,
      methodTitle: _withdrawalData.methodTitle,
      methodSubtitle: _withdrawalData.methodSubtitle,
    );
    notifyListeners();
  }

  // !------- internal snackbar ----------!
  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}