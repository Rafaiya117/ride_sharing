import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentMethodType, PaymentMethodData; 
//import 'package:stripe_platform_interface/stripe_platform_interface.dart' as stripe_platform_interface;
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/payment/payment_model/payment_model.dart';
import 'package:ride_sharing/features/payment/payment_view/stripe_view.dart';

class PaymentController extends ChangeNotifier {
  late PaymentModel _payment;
  PaymentMethodType? _selectedMethod = PaymentMethodType.card; 

  PaymentModel get payment => _payment;
  PaymentMethodType? get selectedMethod => _selectedMethod;

  bool _isPaying = false;
  bool get isPaying => _isPaying;

  final Dio _dio = Dio();
  String? _activeClientSecret;

  final List<PaymentMethodData> _availableMethods = [
    PaymentMethodData(
      title: "Card Payment",
      subtitle: "Pay with Stripe",
      subSubtitle: "Secure & Instant", 
      iconPath: 'assets/icons/credit.svg',
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
      iconPath: 'assets/icons/wallet2.svg',
      type: PaymentMethodType.credits,
    ),
  ];

  List<PaymentMethodData> get availableMethods => _availableMethods;

  PaymentController() {
    _mockInitialData(); 
  }

  void _mockInitialData() {
    _payment = PaymentModel(
      route: "Loading route...",
      date: "Loading schedule...",
      driverName: "Loading...",
      seats: 1,
      rideFare: 0.0,
      serviceFee: 0.0,
      selectedMethod: _selectedMethod,
    );
  }

  // FIXED: Call this from your view initialization step to load real API ride metrics safely
  void initializePaymentData(Map<String, dynamic> rideDataJson) {
    _payment = PaymentModel.fromJson(rideDataJson, _selectedMethod);
    notifyListeners();
  }

  void selectPaymentMethod(PaymentMethodType method) {
    _selectedMethod = method;
    _payment.selectedMethod = method; 
    notifyListeners(); 
  }

  Future<void> getRideDetailsForPayment(BuildContext context, String rideId) async {
    _isPaying = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    final String? token = TokenStorage.accessToken;

    try {
      final response = await _dio.get(
        '$baseUrl/api/v1/passenger/rides/$rideId/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final Map<String, dynamic> rideDataJson = response.data['data'] is Map ? response.data['data'] : {};
        
        // Pass the extracted payload to populate your models instantly
        initializePaymentData(rideDataJson);
      }
    } catch (e) {
      debugPrint("Error fetching ride details for checkout setup: $e");
    } finally {
      _isPaying = false;
      notifyListeners();
    }
  }

  Future<void> processPayment(BuildContext context, int bookingId) async {
    _isPaying = true;
    notifyListeners();

    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    
    final String? token = TokenStorage.accessToken;

    try {
      final String endpointUrl = _selectedMethod == PaymentMethodType.cash
          ? '$baseUrl/api/v1/passenger/checkout/cash/'
          : '$baseUrl/api/v1/passenger/checkout/';

      final response = await _dio.post(
        endpointUrl,
        data: {"booking_id": bookingId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        if (_selectedMethod == PaymentMethodType.cash) {
          final String message = response.data['data']?['message'] ?? "Cash payment confirmed.";
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: const Color(0xFF1DB954), 
              ),
            );
            GoRouter.of(context).push('/user_home_screen');
          }
          return;
        }

        final paymentData = response.data['data'];
        final String? clientSecret = paymentData['payment_intent_client_secret'];
        final String? publishableKey = paymentData['publishable_key'];

        if (clientSecret != null && publishableKey != null) {
          Stripe.publishableKey = publishableKey;
          await Stripe.instance.applySettings();
          
          _activeClientSecret = clientSecret;

          if (context.mounted) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const StripeCardBottomSheet(),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching checkout configurations: $e");
    } finally {
      _isPaying = false;
      notifyListeners();
    }
  }

  Future<bool> confirmCustomCardPayment(BuildContext context, PaymentMethodParams params) async {
    if (_activeClientSecret == null) return false;
    
    _isPaying = true;
    notifyListeners();

    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: _activeClientSecret!,
        data: params,
      );

      if (context.mounted) {
        completeStripePayment(context);
      }
      return true;
    } catch (e) {
      if (e is StripeException) {
        debugPrint("Payment failed or cancelled: ${e.error.localizedMessage}");
      } else {
        debugPrint("Error completing payment transaction: $e");
      }
      return false;
    } finally {
      _isPaying = false;
      notifyListeners();
    }
  }

  void completeStripePayment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful!"),
        backgroundColor: Color(0xFF1DB954), 
      ),
    );
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}

// FIXED: Explicitly added the local helper data class definition to resolve layout compilation constraints cleanly
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