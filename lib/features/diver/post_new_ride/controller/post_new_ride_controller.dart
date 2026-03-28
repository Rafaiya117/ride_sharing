import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/diver/post_new_ride/model/post_new_ride_model.dart';

class PostRideController extends ChangeNotifier {
  // Instance of the model
  final PostRideModel ride = PostRideModel();

  // Text Controllers
  final TextEditingController priceController = TextEditingController(text: "45");
  final TextEditingController pickupChargesController = TextEditingController();
  final TextEditingController dropoffChargesController = TextEditingController();

  void toggleDoorPickUp(bool value) {
    ride.isDoorPickUp = value;
    notifyListeners();
  }

  void toggleDoorDropOff(bool value) {
    ride.isDoorDropOff = value;
    notifyListeners();
  }

  void submitRide(BuildContext context) {
    // Logic to save the ride
    debugPrint("Posting Ride: ${ride.pickupLocation} to ${ride.dropoffLocation}");
    Navigator.pop(context);
    context.push('/drive_earning_screen');
  }

  @override
  void dispose() {
    priceController.dispose();
    pickupChargesController.dispose();
    dropoffChargesController.dispose();
    super.dispose();
  }
}