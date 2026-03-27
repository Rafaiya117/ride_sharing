class WithdrawalDashboardModel {
  final double availableBalance;
  final double pendingBalance;
  final double monthlyEarned;
  final double monthlyWithdrawn;
  final int monthlyTrips;
  final List<WithdrawalTransaction> transactions;

  WithdrawalDashboardModel({
    required this.availableBalance,
    required this.pendingBalance,
    required this.monthlyEarned,
    required this.monthlyWithdrawn,
    required this.monthlyTrips,
    required this.transactions,
  });
}

class WithdrawalTransaction {
  final int amount;
  final String method;
  final String date;
  final String status;

  WithdrawalTransaction({
    required this.amount,
    required this.method,
    required this.date,
    required this.status,
  });
}