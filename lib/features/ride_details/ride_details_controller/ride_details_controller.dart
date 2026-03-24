import 'package:flutter/material.dart';
import 'package:ride_sharing/features/ride_details/ride_details_model/ride_details_model.dart';

class RideDetailsController extends ChangeNotifier {
  // 1. Dynamic Ride Data (Mocked from image_7.png)
  // ignore: prefer_final_fields
  RideDetailsModel _ride = RideDetailsModel(
    totalPrice: 38.0, date: "Mar 7, 2026", time: "10:00 AM", duration: "4h 45m", distance: "225 miles", totalSeats: 3,
    pickup: "New York, NY", pickupTime: "10:00 AM", dropoff: "Washington, DC", estArrival: "Est. arrival time",
    driverName: "Lisa Martinez", driverInitials: "L", driverRating: 4.9, driverTrips: 54,
    carModel: "Audi A4 2023", carLicense: "AUD 2001", vehicleColor: "Black"
  );

  RideDetailsModel get ride => _ride;
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
    print("Booking now for \$$price...");
  }

  void navigateBack(BuildContext context) {
    // Navigator.pop(context);
  }
}