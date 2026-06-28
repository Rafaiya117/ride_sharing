import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/ride_details/ride_details_model/ride_details_model.dart';

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
    carLicense: '', vehicleColor: '', id: 0, driverId: 0,
  );
  RideDetailsModel get ride => _ride;

  int _selectedPickupIndex = 0;
  int get selectedPickupIndex => _selectedPickupIndex;

  Future<void> fetchRideDetails(int rideId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      final String? token = TokenStorage.accessToken;
      
      // FIXED: Adjusted endpoint route path to properly query passenger-scoped details matching search context
      final url = '$baseUrl/api/v1/passenger/rides/$rideId/'; 

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        dynamic serverData = response.data['data'];
        
        // Handle if data comes nested under results list array
        if (serverData != null && serverData['results'] != null) {
          final List<dynamic> resultsList = serverData['results'];
          if (resultsList.isNotEmpty) {
            serverData = resultsList.firstWhere(
              (element) => element['id'] == rideId, 
              orElse: () => resultsList.first,
            );
          }
        }

        _ride = RideDetailsModel.fromJson(serverData);

        final driverVer = serverData['driver_verification'] ?? {};
        _vehicleImages = [
          if (driverVer['car_photo'] != null) driverVer['car_photo'].toString(),
          if (driverVer['number_plate_photo'] != null) driverVer['number_plate_photo'].toString(),
          if (driverVer['selfie'] != null) driverVer['selfie'].toString(),
        ];
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        debugPrint("Server Ride Details Error Profile: ${e.response?.data}");
      } else {
        debugPrint("Error loading ride details data profile: $e");
      }
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

  // void bookNow(BuildContext context, double price) {
  //   GoRouter.of(context).go('/payment');
  // }

  // FIXED: Changed to Future<void> to execute the booking API call asynchronously
  Future<void> bookNow(BuildContext context, double price) async {
    final router = GoRouter.of(context);
    final int rideId = _ride.id;
    
    if (rideId == 0) {
      debugPrint("Invalid ride ID tracking context.");
      return;
    }

    router.go('/payment', extra: {
      "ride_id": rideId,
    });
  }

  Future<void> navigateToChat(BuildContext context, {required int targetUserId, int? targetRideId}) async {
    final router = GoRouter.of(context);
    
    _isLoading = true;
    notifyListeners();

    final baseUrl = dotenv.env['API_BASE_URL'];
    final String? token = TokenStorage.accessToken;

    try {
      final Map<String, dynamic> requestBody = {
        "user_id": targetUserId,
        if (targetRideId != null) "ride_id": targetRideId,
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/conversations/',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final resData = response.data['data'];
        if (resData != null && resData['id'] != null) {
          final int validConversationId = resData['id'];
          
          debugPrint("SUCCESS: Redirecting via captured router instances → ID: $validConversationId");
          router.push('/chat', extra: validConversationId);
        }
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        debugPrint("Server Validation Error Details: ${e.response?.data}");
      } else {
        debugPrint("Error initializing conversation room payload: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateBack(BuildContext context) {
    context.pop();
  }
}