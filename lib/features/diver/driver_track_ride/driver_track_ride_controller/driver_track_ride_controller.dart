import 'package:flutter/material.dart';
import 'package:ride_sharing/features/diver/driver_track_ride/driver_track_ride_model/driver_track_ride_model.dart';

class DriverTrackController extends ChangeNotifier {
  final DriverTrackModel trip = DriverTrackModel(
    passengerName: "Sarah Johnson",
    carModel: "Honda Accord 2022",
    carPlate: "ABC 1234",
    estimatedArrival: "2h 45m",
    progress: 0.63,
    currentStatus: "Approaching Hartford, CT",
    pickup: "New York, NY",
    destination: "Boston, MA",
    distance: "215 miles",
    duration: "4h 30m",
    price: 45,
  );

  void endRide(BuildContext context) {
    print("Ride ended. Navigating to summary...");
  }

  void triggerSOS() => print("Emergency SOS activated!");
  void callPassenger() => print("Calling passenger...");
  void messagePassenger() => print("Opening chat...");
  void shareTrip() => print("Sharing trip with family...");
}