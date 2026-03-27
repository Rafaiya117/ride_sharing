import 'package:flutter/material.dart';
import 'package:ride_sharing/features/my_trip/model/my_trip_model.dart';

class MyTripsController extends ChangeNotifier {
  // Mock Data
  final TripModel bookingTrip = TripModel(
    driverName: "Sarah Johnson",
    date: "Mar 6, 2026",
    time: "09:00 AM",
    pickup: "New York, NY",
    dropoff: "Boston, MA",
    price: "45",
    durationOrCar: "4h 30m",
    rating: 4.9,
    isUpcoming: true,
  );

  final TripModel activeTrip = TripModel(
    driverName: "Sarah Johnson",
    date: "Mar 6, 2026",
    time: "09:00 AM",
    pickup: "New York, NY",
    dropoff: "Boston, MA",
    price: "45",
    durationOrCar: "Honda Accord 2022",
    rating: 4.9,
  );

  void cancelBooking() {
    // Add cancellation logic
    print("Booking Cancelled");
  }

  void trackTrip() {
    // Add tracking navigation logic
    print("Navigating to Tracking");
  }
}