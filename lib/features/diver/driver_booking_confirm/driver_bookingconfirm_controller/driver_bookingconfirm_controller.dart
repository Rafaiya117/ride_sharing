import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/driver_booking_confirm/driver_booking_confirm_model/driver_booking_confirm_model.dart';

class BookingConfirmController extends ChangeNotifier {
  // Data points extracted from the design
  final BookingConfirmModel ride = BookingConfirmModel(
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
    print("User initiated start ride sequence for ${ride.passengerName}");
    // Handle state transition or navigation
  }

  void callDriver() => print("Calling driver...");
  void messageDriver() => print("Opening chat...");
  void shareTrip() => print("Sharing trip details...");
}