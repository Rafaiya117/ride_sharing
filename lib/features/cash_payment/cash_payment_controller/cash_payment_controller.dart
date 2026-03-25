import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CashPaymentController extends ChangeNotifier {
  String _selectedMethod = 'cash'; 
  
  String get selectedMethod => _selectedMethod;

  void selectMethod(String method) {
    _selectedMethod = method;
    notifyListeners(); 
  }

  void processCashPayment(BuildContext context, double amount) {
    print("User confirmed cash payment of \$$amount to the driver.");
    GoRouter.of(context).push('/rating_screen');
  }
}