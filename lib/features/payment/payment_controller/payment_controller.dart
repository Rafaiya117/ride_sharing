import 'package:flutter/material.dart';
import 'package:ride_sharing/features/home/view/home_view.dart';
import 'package:ride_sharing/features/payment/payment_model/payment_model.dart';
import 'package:ride_sharing/features/payment/payment_view/stripe_view.dart';

class PaymentController extends ChangeNotifier {
  // 1. Dynamic Payment state
  late PaymentModel _payment;
  PaymentMethodType? _selectedMethod = PaymentMethodType.card; 

  PaymentModel get payment => _payment;
  PaymentMethodType? get selectedMethod => _selectedMethod;

  // 2. Static Payment Methods data
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

  // --- Logic for Success Redirect ---

  void completeStripePayment(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()), 
      (route) => false,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful!"),
        backgroundColor: Color(0xFF1DB954), 
      ),
    );
  }

  // --- Action Methods ---

  void selectPaymentMethod(PaymentMethodType method) {
    _selectedMethod = method;
    _payment.selectedMethod = method; 
    notifyListeners(); 
  }

 void processPayment(BuildContext context) {
    if (_selectedMethod == PaymentMethodType.card) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, 
        backgroundColor: Colors.transparent,
        builder: (context) => const StripeCardBottomSheet(),
      );
    } else if (_selectedMethod != null) {
      completeStripePayment(context);
    }
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}