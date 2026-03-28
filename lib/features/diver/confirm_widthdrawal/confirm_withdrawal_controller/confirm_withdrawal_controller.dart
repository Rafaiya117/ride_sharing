import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/diver/confirm_widthdrawal/confirm_withdrawal_model/confirm_withdrawal_model.dart';

class ConfirmWithdrawalController extends ChangeNotifier {
  late ConfirmWithdrawalModel _withdrawalData;
  ConfirmWithdrawalModel get data => _withdrawalData;

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

  void confirmAndWithdraw(BuildContext context) {
    debugPrint("Processing withdrawal of \$${_withdrawalData.amount}");
    context.push('/drive_bookingconfirm_screen');
    // Add navigation to success screen here
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}