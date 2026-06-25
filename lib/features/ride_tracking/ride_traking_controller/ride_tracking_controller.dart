import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/ride_tracking/ride_tracking_model/ride_tracking_model.dart';
import 'package:share_plus/share_plus.dart';

class TrackRideController extends ChangeNotifier {
  // 1. Dynamic Trip Data 
  String _pickup = "Loading...";
  String get pickup => _pickup;

  String _dropoff = "Loading...";
  String get dropoff => _dropoff;
  
  double _totalDistanceMiles = 0.0;
  double get totalDistanceMiles => _totalDistanceMiles;

  Duration _totalDuration = const Duration(minutes: 0);
  Duration get totalDuration => _totalDuration;

  double _price = 0.0;
  double get price => _price;
  
  // 2. Dynamic Status
  String _estimatedArrival = "-- m";
  String get estimatedArrival => _estimatedArrival;
  
  double get percentageComplete => 0.63;
  String get currentStatusText => ""; 

  // 3. Dynamic Driver Data
  // FIXED: Set a default clean loading state until the API returns actual driver data
  DriverModel _driver = DriverModel(
    name: "Loading...",
    avatarPath: "", 
    carModel: "Loading...",
    carPlate: "",
    rating: 5.0,
  );
  DriverModel get driver => _driver;

  // --- Methods ---
  String selectedPaymentMethod = "Cash";
  Timer? _popupTimer;

  final Dio _dio = Dio();
  Timer? _trackingTimer;
  GoogleMapController? _mapController;

  LatLng? _driverPosition;
  LatLng? get driverPosition => _driverPosition;

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  // FIXED: Backing variable to safely track the live URL string from the API payload updates
  String _googleMapsUrl = "";

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    if (_driverPosition != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(_driverPosition!));
    }
  }

  void startDriverTrackingLoop(int rideId) {
    _trackingTimer?.cancel();
    _fetchLocationPayload(rideId);

    _trackingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _fetchLocationPayload(rideId);
    });
  }

  Future<void> _fetchLocationPayload(int rideId) async {
    final String? token = TokenStorage.accessToken;
    if (token == null) return;

    try {
      String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

      final response = await _dio.get(
        '$baseUrl/api/v1/passenger/rides/$rideId/track/', 
        queryParameters: {'include_eta': true},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'];
        debugPrint('!!!!!!!!!!!!!$data!!!!!!!!!!!!');
        final double lat = double.parse(data['driver_lat'].toString());
        final double lng = double.parse(data['driver_lng'].toString());
        
        _driverPosition = LatLng(lat, lng);

        if (data['pickup_location'] != null) _pickup = data['pickup_location'];
        if (data['drop_location'] != null) _dropoff = data['drop_location'];

        _totalDistanceMiles = double.tryParse(data['distance']?.toString() ?? '0.0') ?? 0.0;
        
        final int durationMinutes = int.tryParse(data['duration']?.toString() ?? '0') ?? 0;
        _totalDuration = Duration(minutes: durationMinutes);
        _estimatedArrival = "${durationMinutes}m";

        _price = double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0;

        // FIXED: Extract and store the tracking web link destination
        _googleMapsUrl = data['google_maps_url'] ?? "";

        // FIXED: Dynamically map incoming driver telemetry values straight from backend json payload keys
        _driver = DriverModel(
          name: data['driver_name'] ?? 'Driver',
          avatarPath: data['driver_photo'] ?? "", // Passes network URL string cleanly if available
          carModel: data['car_model'] ?? 'Car',
          carPlate: data['license_plate'] ?? '',
          rating: 5.0, // Hardcoded fallback or use mapping if backend adds rating key later
        );

        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('driver_marker'),
            position: _driverPosition!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(title: _driver.name, snippet: _driver.carModel),
          ),
        );

        _mapController?.animateCamera(CameraUpdate.newLatLng(_driverPosition!));
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Telemetry tracking network request exception dropped: $e");
    }
  }

  void startRideTimeout(BuildContext context) {
    _popupTimer?.cancel(); 
    _popupTimer = Timer(const Duration(seconds: 3), () {
      if (context.mounted && ModalRoute.of(context)?.isCurrent == true) {}
    });
  }

  void triggerEmergencySOS(BuildContext context) {
    debugPrint("EMERGENCY SOS TRIGGERED! Calling emergency services and notifying platform...");
  }

  void openChatWithDriver(BuildContext context) {
    GoRouter.of(context).push('/chat', extra: 13);
  }

  void callDriver() {
    print("Calling ${driver.name} at placeholder number...");
  }

  
  void shareTripWithFamily(BuildContext context) {
    if (_googleMapsUrl.isNotEmpty) {
      // ignore: deprecated_member_use
      Share.share(
        "Track my live ride here: $_googleMapsUrl",
        subject: "Live Ride Map Share",
      );
    } else {
      debugPrint("Telemetry data has not loaded yet. Unable to distribute tracking link map sheet context.");
    }
  }

  void openNotifications(BuildContext context) {
    print("Opening notifications...");
  }

  void navigateBack(BuildContext context) {}

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _popupTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}