import 'package:flutter/material.dart';

class FeePaymentController extends ChangeNotifier {
  final double tripEarnings = 28.00;
  final double feePercentage = 0.05;

  double get platformFee => tripEarnings * feePercentage;
  double get netEarnings => tripEarnings - platformFee;

  int _selectedMethod = 0; 
  int get selectedMethod => _selectedMethod;

  void selectMethod(int index) {
    _selectedMethod = index;
    notifyListeners();
  }

  void handlePayment(BuildContext context) {
    debugPrint("Paying \$${platformFee.toStringAsFixed(2)} via method $_selectedMethod");
    Navigator.pop(context); 
  }
}