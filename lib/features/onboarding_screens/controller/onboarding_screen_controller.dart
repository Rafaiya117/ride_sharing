import 'package:flutter/material.dart';
import 'package:ride_sharing/features/onboarding_screens/model/on_screen_model.dart';
import 'package:go_router/go_router.dart';

class OnboardingController extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      title: "Share Rides, Save Money",
      description: "Connect with verified travelers heading your way and split the cost of long-distance trips",
      image: "assets/images/logo_1.png",
    ),
    OnboardingModel(
      title: "Flexible & Affordable",
      description: "Choose from multiple ride options and prices. Drivers set their own rates",
      image: "assets/images/logo_2.png",
    ),
    OnboardingModel(
      title: "Real-time Tracking",
      description: "Live tracking, verified drivers, 24/7 support, and emergency assistance at your fingertips",
      image: "assets/images/logo_3.png",
    ),
  ];

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // This updates the UI automatically
  }

  void navigateToLogin(BuildContext context) {
    context.go('/role'); // Using your go_router requirement
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}