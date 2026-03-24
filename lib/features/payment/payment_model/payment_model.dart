enum PaymentMethodType { card, cash, credits }

class PaymentMethodData {
  final String title;
  final String subtitle;
  final String? subSubtitle;
  final String iconPath;
  final bool isSecure;
  final PaymentMethodType type;

  PaymentMethodData({
    required this.title,
    required this.subtitle,
    this.subSubtitle,
    required this.iconPath,
    this.isSecure = false,
    required this.type,
  });
}

class PaymentModel {
  final String route;
  final String date;
  final String driverName;
  final int seats;
  final double rideFare;
  final double serviceFee;
  PaymentMethodType? selectedMethod; 

  PaymentModel({
    required this.route,
    required this.date,
    required this.driverName,
    required this.seats,
    required this.rideFare,
    required this.serviceFee,
    this.selectedMethod,
  });

  double get totalAmount => rideFare + serviceFee;
}