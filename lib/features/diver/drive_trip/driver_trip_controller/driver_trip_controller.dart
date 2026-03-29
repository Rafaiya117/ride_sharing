import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/drive_trip/driver_trip_model/driver_trip_model.dart';

class DriverTripController extends ChangeNotifier {
  int _currentNavbarIndex = 0;
  int get currentNavbarIndex => _currentNavbarIndex;

  PostedRideModel? postedRide = PostedRideModel(
    id: '123',
    from: "Dhaka",
    to: "Khulna",
    date: "Mar 10, 2026",
    time: "22:52",
    pricePerSeat: "50",
    seats: "1/1",
    postedDate: "Mar 9, 2026",
  );

  ActiveTripModel? activeTrip = ActiveTripModel(
    id: '456',
    date: "Mar 6, 2026",
    pickup: "New York, NY",
    destination: "Boston, MA",
    passengerName: "Sarah Johnson",
    rating: 4.9,
    price: 45,
    duration: "4h 30m",
  );

  void setNavbarIndex(int index) {
    _currentNavbarIndex = index;
    notifyListeners();
  }
}