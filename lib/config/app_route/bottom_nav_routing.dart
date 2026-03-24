import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/utils/bottom_nav.dart';
import 'package:ride_sharing/features/home/home_controller/home_controller.dart';
import 'package:ride_sharing/features/home/view/home_view.dart';

// Dummy screens for other pages
class MyTripsPage extends StatelessWidget { const MyTripsPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("My Trips Page")); }
class HistoryPage extends StatelessWidget { const HistoryPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("History Page")); }
class AccountPage extends StatelessWidget { const AccountPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Account Page")); }

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final List<Widget> _pages = [
    const HomeScreen(), 
    const MyTripsPage(),
    const HistoryPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Access the controller to observe and update the index dynamically
    final controller = context.watch<HomeController>();

    return Scaffold(
      body: _pages[controller.currentNavbarIndex],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: controller.currentNavbarIndex,
        onTap: (index) {
          controller.setNavbarIndex(index); 
        },
      ),
    );
  }
}