import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/ride_details/ride_details_model/ride_details_model.dart';

// class RideDetailsController extends ChangeNotifier {
//    final List<String> _vehicleImages = [
//     'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=1000',
//     'https://images.unsplash.com/photo-1542281286-9e0a16bb7366?q=80&w=1000',
//     'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=1000',
//     'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?q=80&w=1000',
//   ];

//   List<String> get vehicleImages => _vehicleImages;
//   // ignore: prefer_final_fields
//   RideDetailsModel _ride = RideDetailsModel(
//     totalPrice: 38.0, date: "Mar 7, 2026", time: "10:00 AM", duration: "4h 45m", distance: "225 miles", totalSeats: 3,
//     pickup: "New York, NY", pickupTime: "10:00 AM", dropoff: "Washington, DC", estArrival: "Est. arrival time",
//     driverName: "Lisa Martinez", driverInitials: "L", driverRating: 4.9, driverTrips: 54,
//     carModel: "Audi A4 2023", carLicense: "AUD 2001", vehicleColor: "Black"
//   );

//   RideDetailsModel get ride => _ride;
//   int _selectedPickupIndex = 0;
//   int get selectedPickupIndex => _selectedPickupIndex;

//   void setPickupOption(int index) {
//     _selectedPickupIndex = index;
//     notifyListeners();
//   }
//   // --- Methods ---

//   void callDriver(String phoneNumber) {
//     print("Calling driver at $phoneNumber...");
//     // Use url_launcher package to open dialer
//   }

//   void openNotifications(BuildContext context) {
//     print("Opening notifications...");
//   }

//   void shareRideDetails(BuildContext context) {
//     print("Sharing ride details...");
//   }

//   void makeOffer(BuildContext context) {
//     print("Making an offer...");
//   }

//   void bookNow(BuildContext context, double price) {
//     GoRouter.of(context).go('/payment');
//     print("Booking now for \$$price...");
//   }

//   void navigateBack(BuildContext context) {
//     // Navigator.pop(context);
//   }
// }

class RideDetailsController extends ChangeNotifier {
  final Dio _dio = Dio();
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<String> _vehicleImages = [];
  List<String> get vehicleImages => _vehicleImages;

  // FIXED: Initialized _ride with a default model configuration instance to eliminate late errors
  RideDetailsModel _ride = RideDetailsModel(
    totalPrice: 0.0, date: '', time: '', duration: '', distance: '', totalSeats: 0,
    pickup: '', pickupTime: '', dropoff: '', estArrival: '', driverName: '',
    driverInitials: '', driverRating: 0.0, driverTrips: 0, carModel: '',
    carLicense: '', vehicleColor: '',
  );
  RideDetailsModel get ride => _ride;

  int _selectedPickupIndex = 0;
  int get selectedPickupIndex => _selectedPickupIndex;

  Future<void> fetchRideDetails(int rideId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final url = '$baseUrl/api/v1/rides/$rideId/'; 

      final response = await _dio.get(url);

      if (response.data != null && response.data['success'] == true) {
        final serverData = response.data['data'];
        
        _ride = RideDetailsModel.fromJson(serverData);

        final driverVer = serverData['driver_verification'] ?? {};
        _vehicleImages = [
          if (driverVer['car_photo'] != null) driverVer['car_photo'].toString(),
          if (driverVer['number_plate_photo'] != null) driverVer['number_plate_photo'].toString(),
          if (driverVer['selfie'] != null) driverVer['selfie'].toString(),
        ];
      }
    } catch (e) {
      debugPrint("Error loading ride details data profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void shareRideDetails(BuildContext context) {
    print("Sharing ride details...");
  }

  void setPickupOption(int index) {
    _selectedPickupIndex = index;
    notifyListeners();
  }

  void callDriver(String phoneNumber) {
    debugPrint("Calling driver at $phoneNumber...");
  }

  void makeOffer(BuildContext context) {}

  void bookNow(BuildContext context, double price) {
    GoRouter.of(context).go('/payment');
  }

  void navigateBack(BuildContext context) {
    context.pop();
  }
}