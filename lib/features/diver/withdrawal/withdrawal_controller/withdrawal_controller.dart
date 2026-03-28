import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/diver/withdrawal/withdrawal_model/withdrawal_model.dart';

class WithdrawalController extends ChangeNotifier {
  late WithdrawalDashboardModel _data;
  WithdrawalDashboardModel get data => _data;

  WithdrawalController() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _data = WithdrawalDashboardModel(
      availableBalance: 441.0,
      pendingBalance: 98.0,
      monthlyEarned: 1960.0,
      monthlyWithdrawn: 1200.0,
      monthlyTrips: 38,
      transactions: [
        WithdrawalTransaction(amount: 450, method: "Bank Account", date: "Mar 1, 2026", status: "Completed"),
        WithdrawalTransaction(amount: 320, method: "PayPal", date: "Feb 15, 2026", status: "Completed"),
        WithdrawalTransaction(amount: 280, method: "Bank Account", date: "Feb 1, 2026", status: "Completed"),
      ],
    );
  }

  void navigateToWithdrawAmount(BuildContext context) {
    debugPrint("Navigating to Amount Selection...");
    GoRouter.of(context).push('/drive_withdrawalflow_screen');
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

}