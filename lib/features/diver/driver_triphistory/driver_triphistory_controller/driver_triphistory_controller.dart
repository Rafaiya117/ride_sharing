import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/driver_triphistory/driver_trip_history_model/driver_triphistory_model.dart';

class DriverTripHistoryController extends ChangeNotifier {
  List<DriverTripHistoryModel> trips = [
    DriverTripHistoryModel(
      date: "Feb 28, 2026",
      pickupLocation: "New York, NY",
      dropoffLocation: "Philadelphia, PA",
      passengerName: "Robert Taylor",
      rating: 4.8,
      price: 28.00,
      duration: "2h 15m",
    ),
    DriverTripHistoryModel(
      date: "Feb 22, 2026",
      pickupLocation: "Boston, MA",
      dropoffLocation: "New York, NY",
      passengerName: "Jennifer Lee",
      rating: 5.0,
      price: 42.00,
      duration: "4h 30m",
    ),
    DriverTripHistoryModel(
      date: "Feb 15, 2026",
      pickupLocation: "Washington, DC",
      dropoffLocation: "New York, NY",
      passengerName: "Christopher Kim",
      rating: 4.7,
      price: 35.00,
      duration: "4h 45m",
    ),
    DriverTripHistoryModel(
      date: "Feb 8, 2026",
      pickupLocation: "New York, NY",
      dropoffLocation: "Baltimore, MD",
      passengerName: "Amanda White",
      rating: 4.9,
      price: 32.00,
      duration: "4h 00m",
    ),
  ];
}