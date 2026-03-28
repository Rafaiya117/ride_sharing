import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/role_selection/model/role_selection_model.dart';

class RoleController extends ChangeNotifier {
  String? _selectedRole;
  String? get selectedRole => _selectedRole;

  final List<RoleModel> roles = [
    RoleModel(
      id: 'passenger',
      title: "Passenger",
      description: "Find and book affordable\nrides",
      iconPath: 'assets/icons/passenger.svg',
    ),
    RoleModel(
      id: 'driver',
      title: "Driver",
      description: "Offer rides and earn money",
      iconPath: 'assets/icons/driver.svg',
    ),
  ];

  void onRoleSelected(BuildContext context, String roleId) {
    _selectedRole = roleId;
    notifyListeners();

    // Both roles now go to sign_in
    Timer(const Duration(milliseconds: 300), () {
      context.go('/sign_in');
    });
  }
}
