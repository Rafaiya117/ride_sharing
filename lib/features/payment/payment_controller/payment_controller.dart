import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentMethodType, PaymentMethodData; 
import 'package:stripe_platform_interface/stripe_platform_interface.dart' as stripe_platform_interface;
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/payment/payment_model/payment_model.dart';
import 'package:ride_sharing/features/payment/payment_view/stripe_view.dart';

// class PaymentController extends ChangeNotifier {
//   // 1. Dynamic Payment state
//   late PaymentModel _payment;
//   PaymentMethodType? _selectedMethod = PaymentMethodType.card; 

//   PaymentModel get payment => _payment;
//   PaymentMethodType? get selectedMethod => _selectedMethod;

//   bool _isPaying = false;
//   bool get isPaying => _isPaying;

//   final Dio _dio = Dio();

//   // 2. Static Payment Methods data
//   final List<PaymentMethodData> _availableMethods = [
//     PaymentMethodData(
//       title: "Card Payment",
//       subtitle: "Pay with Stripe",
//       subSubtitle: "Secure & Instant", 
//       iconPath: 'assets/icons/credit.svg',
//       isSecure: true,
//       type: PaymentMethodType.card,
//     ),
//     PaymentMethodData(
//       title: "Cash Payment",
//       subtitle: "Pay with cash",
//       subSubtitle: "\$ Pay directly to driver", 
//       iconPath: 'assets/icons/cash.svg',
//       type: PaymentMethodType.cash,
//     ),
//     PaymentMethodData(
//       title: "My Credits",
//       subtitle: "Available Credits",
//       iconPath: 'assets/icons/wallet2.svg',
//       type: PaymentMethodType.credits,
//     ),
//   ];

//   List<PaymentMethodData> get availableMethods => _availableMethods;

//   PaymentController() {
//     _mockInitialData(); 
//   }

//   void _mockInitialData() {
//     _payment = PaymentModel(
//       route: "New York, NY → Boston, MA",
//       date: "Mar 6, 2026, 09:00 AM",
//       driverName: "Sarah Johnson",
//       seats: 1,
//       rideFare: 45.0,
//       serviceFee: 5.0,
//       selectedMethod: _selectedMethod,
//     );
//   }

//   // --- Logic for Success Redirect ---

//   void completeStripePayment(BuildContext context) {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const HomeScreen()), 
//       (route) => false,
//     );
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Payment Successful!"),
//         backgroundColor: Color(0xFF1DB954), 
//       ),
//     );
//   }

//   // --- Action Methods ---

//   void selectPaymentMethod(PaymentMethodType method) {
//     _selectedMethod = method;
//     _payment.selectedMethod = method; 
//     notifyListeners(); 
//   }

//   // void processPayment(BuildContext context) {
//   //   if (_selectedMethod == PaymentMethodType.card) {
//   //     showModalBottomSheet(
//   //       context: context,
//   //       isScrollControlled: true, 
//   //       backgroundColor: Colors.transparent,
//   //       builder: (context) => const StripeCardBottomSheet(),
//   //     );
//   //   } else if (_selectedMethod != null) {
//   //     completeStripePayment(context);
//   //   }
//   // }

//   Future<void> processPayment(BuildContext context, int bookingId) async {
//     if (_selectedMethod != PaymentMethodType.card) {
//       completeStripePayment(context);
//       return;
//     }
//     _isPaying = true;
//     notifyListeners();

//     String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
//     if (baseUrl.endsWith('/')) {
//       baseUrl = baseUrl.substring(0, baseUrl.length - 1);
//     }
    
//     final String? token = TokenStorage.accessToken;

//     try {
//       final response = await _dio.post(
//         '$baseUrl/api/v1/passenger/checkout/',
//         data: {"booking_id": bookingId},
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             if (token != null) 'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.data != null && response.data['success'] == true) {
//         final String? checkoutUrl = response.data['data']['url'] ?? response.data['data']['payment_url'];

//         if (checkoutUrl != null && context.mounted) {
//           _showInAppWebViewSheet(context, checkoutUrl);
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching checkout payment window: $e");
//     } finally {
//       _isPaying = false;
//       notifyListeners();
//     }
//   }
//   // FIXED: Opens Stripe completely inside your existing app widget layout context tree
//   void _showInAppWebViewSheet(BuildContext context, String initialUrl) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (bottomSheetContext) {
//         return SizedBox(
//           height: MediaQuery.of(context).size.height * 0.85, // Takes up 85% of screen height
//           child: Column(
//             children: [
//               // Header drag handle / close row panel
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 color: Colors.grey.shade100,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Secure Stripe Checkout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(bottomSheetContext),
//                     )
//                   ],
//                 ),
//               ),
//               // Web engine content frame
//               Expanded(
//                 child: InAppWebView(
//                   initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
//                   initialSettings: InAppWebViewSettings(
//                     javaScriptEnabled: true,
//                     allowsBackForwardNavigationGestures: true,
//                   ),
//                   onUpdateVisitedHistory: (webViewCtrl, uri, isReload) {
//                     // 3. Listen for your payment web success landing target address url changes
//                     if (uri != null && uri.toString().contains('/stripe/return/')) {
//                       // Close the modal checkout view window
//                       Navigator.pop(bottomSheetContext);
//                       // Trigger successful home navigation layout sequence automatically
//                       completeStripePayment(context);
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void navigateBack(BuildContext context) {
//     Navigator.pop(context);
//   }
// }

class PaymentController extends ChangeNotifier {
  late PaymentModel _payment;
  PaymentMethodType? _selectedMethod = PaymentMethodType.card; 

  PaymentModel get payment => _payment;
  PaymentMethodType? get selectedMethod => _selectedMethod;

  bool _isPaying = false;
  bool get isPaying => _isPaying;

  final Dio _dio = Dio();

  // Cached secret token used when completing payment from your custom bottom sheet layout
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

  // FIXED: Refactored to fetch intent data and trigger your custom layout sheet directly
  Future<void> processPayment(BuildContext context, int bookingId) async {
    if (_selectedMethod != PaymentMethodType.card) {
      completeStripePayment(context);
      GoRouter.of(context).push('/user_home_screen');
      return;
    }
    
    _isPaying = true;
    notifyListeners();

    String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    
    final String? token = TokenStorage.accessToken;

    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/passenger/checkout/',
        data: {"booking_id": bookingId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final paymentData = response.data['data'];
        
        final String? clientSecret = paymentData['payment_intent_client_secret'];
        final String? publishableKey = paymentData['publishable_key'];

        if (clientSecret != null && publishableKey != null) {
          Stripe.publishableKey = publishableKey;
          await Stripe.instance.applySettings();
          
          // Cache client secret for confirmation step
          _activeClientSecret = clientSecret;

          // Open your custom StripeCardBottomSheet UI view container
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

  // FIXED: Simplified return block signature type here to report operational pipeline status back to UI layout views
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

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}