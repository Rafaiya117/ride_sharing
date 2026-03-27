import 'package:flutter/material.dart';
import 'package:ride_sharing/features/trip_history/model/my_trip_history_model.dart';

class TripHistoryController extends ChangeNotifier {
  final List<TripHistoryModel> completedTrips = [
    TripHistoryModel(
      date: "Feb 28, 2026",
      time: "10:00 AM",
      pickupLocation: "New York, NY",
      dropoffLocation: "Philadelphia, PA",
      driverName: "Robert Taylor",
      driverInitial: "R",
      carModel: "Honda Civic 2021",
      rating: 4.8,
      duration: "2h 15m",
      price: 28,
    ),
    TripHistoryModel(
      date: "Feb 22, 2026",
      time: "09:00 AM",
      pickupLocation: "Boston, MA",
      dropoffLocation: "New York, NY",
      driverName: "Jennifer Lee",
      driverInitial: "J",
      carModel: "Toyota Camry 2023",
      rating: 5.0,
      duration: "4h 30m",
      price: 42,
    ),
    TripHistoryModel(
      date: "Feb 15, 2026",
      time: "11:00 AM",
      pickupLocation: "Washington, DC",
      dropoffLocation: "New York, NY",
      driverName: "Christopher Kim",
      driverInitial: "C",
      carModel: "Tesla Model 3",
      rating: 4.7,
      duration: "4h 45m",
      price: 35,
    ),
     TripHistoryModel(
      date: "Feb 8, 2026",
      time: "12:00 AM",
      pickupLocation: "New York, NY",
      dropoffLocation: "Baltimore, MD",
      driverName: "Amanda White",
      driverInitial: "A",
      carModel: "Nissan Altima 2022",
      rating: 4.9,
      duration: "4h 00m",
      price: 32,
    ),
  ];

  // Logic for button taps could go here
  void viewReceipt(TripHistoryModel trip) { print("Viewing receipt for ${trip.driverName}"); }
  void rateDriver(TripHistoryModel trip) { print("Rating driver ${trip.driverName}"); }
}