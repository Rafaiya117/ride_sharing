import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/ride_details/ride_details_model/ride_details_model.dart';

class RideDetailsController extends ChangeNotifier {
   final List<String> _vehicleImages = [
    'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=1000',
    'https://images.unsplash.com/photo-1542281286-9e0a16bb7366?q=80&w=1000',
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=1000',
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?q=80&w=1000',
  ];

  List<String> get vehicleImages => _vehicleImages;
  // ignore: prefer_final_fields
  RideDetailsModel _ride = RideDetailsModel(
    totalPrice: 38.0, date: "Mar 7, 2026", time: "10:00 AM", duration: "4h 45m", distance: "225 miles", totalSeats: 3,
    pickup: "New York, NY", pickupTime: "10:00 AM", dropoff: "Washington, DC", estArrival: "Est. arrival time",
    driverName: "Lisa Martinez", driverInitials: "L", driverRating: 4.9, driverTrips: 54,
    carModel: "Audi A4 2023", carLicense: "AUD 2001", vehicleColor: "Black"
  );

  RideDetailsModel get ride => _ride;
  int _selectedPickupIndex = 0;
  int get selectedPickupIndex => _selectedPickupIndex;

  void setPickupOption(int index) {
    _selectedPickupIndex = index;
    notifyListeners();
  }
  // --- Methods ---

  void callDriver(String phoneNumber) {
    print("Calling driver at $phoneNumber...");
    // Use url_launcher package to open dialer
  }

  void openNotifications(BuildContext context) {
    print("Opening notifications...");
  }

  void shareRideDetails(BuildContext context) {
    print("Sharing ride details...");
  }

  void makeOffer(BuildContext context) {
    print("Making an offer...");
  }

  void bookNow(BuildContext context, double price) {
    GoRouter.of(context).go('/payment');
    print("Booking now for \$$price...");
  }

  void navigateBack(BuildContext context) {
    // Navigator.pop(context);
  }
}