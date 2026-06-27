enum PaymentMethodType { card, cash, credits }

// class PaymentMethodData {
//   final String title;
//   final String subtitle;
//   final String? subSubtitle;
//   final String iconPath;
//   final bool isSecure;
//   final PaymentMethodType type;

//   PaymentMethodData({
//     required this.title,
//     required this.subtitle,
//     this.subSubtitle,
//     required this.iconPath,
//     this.isSecure = false,
//     required this.type,
//   });
// }

// class PaymentModel {
//   final String route;
//   final String date;
//   final String driverName;
//   final int seats;
//   final double rideFare;
//   final double serviceFee;
//   PaymentMethodType? selectedMethod; 

//   PaymentModel({
//     required this.route,
//     required this.date,
//     required this.driverName,
//     required this.seats,
//     required this.rideFare,
//     required this.serviceFee,
//     this.selectedMethod,
//   });

//   double get totalAmount => rideFare + serviceFee;
// }

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

  factory PaymentModel.fromJson(Map<String, dynamic> json, PaymentMethodType? method) {
    final DateTime dateTime = DateTime.tryParse(json['date_time'] ?? '') ?? DateTime.now();
    final String pickup = json['pickup_location'] ?? '';
    final String drop = json['drop_location'] ?? '';
    final int seatsCount = json['available_seats'] ?? 1;
    final double baseFare = double.tryParse(json['price_per_seat']?.toString() ?? '0.0') ?? 0.0;

    return PaymentModel(
      route: pickup.isNotEmpty && drop.isNotEmpty ? "$pickup → $drop" : "Route details N/A",
      date: "${dateTime.day}/${dateTime.month}/${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
      driverName: json['driver_name'] ?? "Driver",
      seats: seatsCount,
      rideFare: baseFare,
      serviceFee: 0.0, 
      selectedMethod: method,
    );
  }

  double get totalAmount => rideFare + serviceFee;
}