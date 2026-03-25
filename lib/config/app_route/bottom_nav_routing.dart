import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/utils/bottom_nav.dart';
import 'package:ride_sharing/features/home/home_controller/home_controller.dart';
import 'package:ride_sharing/features/home/view/home_view.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final List<Widget> _pages = [
    const HomeScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    // Using a standard Scaffold here to hold the bottomNavigationBar globally
    return Scaffold(
      extendBody: true, // Allows the body to flow behind the navbar if needed
      body: _pages[controller.currentNavbarIndex],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: controller.currentNavbarIndex,
        onTap: (index) => controller.setNavbarIndex(index), 
      ),
    );
  }
}