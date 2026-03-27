import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/driver_ride_details/driver_ridedetails_model/driver_ridedetails_model.dart';

class DriverRideDetailsController extends ChangeNotifier {
  final DriverRideDetailsModel ride = DriverRideDetailsModel(
    totalPrice: 38,
    date: "Mar 7, 2026",
    time: "10:00 AM",
    duration: "4h 45m",
    distance: "225 miles",
    seats: 3,
    pickupLocation: "New York, NY",
    pickupTime: "10:00 AM",
    dropoffLocation: "Washington, DC",
    estArrival: "Est. arrival time",
    passengerName: "Lisa Martinez",
    passengerInitial: "L",
    rating: 4.9,
    totalTrips: 54,
  );

  void startRide(BuildContext context) {
    print("Ride Started for ${ride.passengerName}");
    // Implementation for navigation/status update
  }

  void callPassenger() => print("Calling passenger...");
  void messagePassenger() => print("Opening chat...");
  void shareRide() => print("Sharing ride link...");
}