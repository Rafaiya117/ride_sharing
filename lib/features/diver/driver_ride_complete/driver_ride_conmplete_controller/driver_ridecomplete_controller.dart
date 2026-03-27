import 'package:flutter/material.dart';

class RideCompletedController extends ChangeNotifier {
  final String passengerName = "John Doe";
  final double rating = 4.9;
  final String fromLocation = "Boston, MA";
  final String toLocation = "New York, NY";
  final int earningsAmount = 42;

  String get initials => passengerName.isNotEmpty ? passengerName[0].toUpperCase() : "";

  void onContinue(BuildContext context) {
    debugPrint("Continuing from completed ride screen...");
  }
}