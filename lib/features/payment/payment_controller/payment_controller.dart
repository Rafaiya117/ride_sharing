import 'package:flutter/material.dart';
import 'package:ride_sharing/features/payment/payment_model/payment_model.dart';

class PaymentController extends ChangeNotifier {
  // 1. Dynamic Payment state from image_10.png
  late PaymentModel _payment;
  PaymentMethodType? _selectedMethod = PaymentMethodType.card; 

  PaymentModel get payment => _payment;
  PaymentMethodType? get selectedMethod => _selectedMethod;

  // 2. static Payment Methods data per MVC pattern
  final List<PaymentMethodData> _availableMethods = [
    PaymentMethodData(
      title: "Card Payment",
      subtitle: "Pay with Stripe",
      subSubtitle: "Secure & Instant", 
      iconPath: 'assets/icons/card.svg',
      isSecure: true,
      type: PaymentMethodType.card,
    ),
    PaymentMethodData(
      title: "Cash Payment",
      subtitle: "Pay with cash",
      subSubtitle: "\$ Pay directly to driver", 
      iconPath: 'assets/icons/cash.svg',
      type: PaymentMethodType.cash,
    ),
    PaymentMethodData(
      title: "My Credits",
      subtitle: "Available Credits",
      iconPath: 'assets/icons/credits.svg',
      type: PaymentMethodType.credits,
    ),
  ];

  List<PaymentMethodData> get availableMethods => _availableMethods;

  PaymentController() {
    _mockInitialData(); 
  }

  void _mockInitialData() {
    _payment = PaymentModel(
      route: "New York, NY → Boston, MA",
      date: "Mar 6, 2026, 09:00 AM",
      driverName: "Sarah Johnson",
      seats: 1,
      rideFare: 45.0,
      serviceFee: 5.0,
      selectedMethod: _selectedMethod,
    );
  }

  // --- Dynamic Methods ---

  void selectPaymentMethod(PaymentMethodType method) {
    _selectedMethod = method;
    _payment.selectedMethod = method; 
    notifyListeners(); 
    print("Standard dynamic update to payment method: ${method.name}");
  }

  void processPayment(BuildContext context) {
    if (_selectedMethod != null) {
      print("Processing Dynamic Payment of \$${_payment.totalAmount.toStringAsFixed(0)} via ${_selectedMethod?.name}...");
      // --- API CALL LOGIC ---
      // GoRouter.of(context).push('/paymentSuccess');
    } else {
      // Show error validation dialog
    }
  }

  void navigateBack(BuildContext context) {
    // GoRouter.of(context).pop(); // standard go back
  }
}