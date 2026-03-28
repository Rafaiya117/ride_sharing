import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/role_selection/controller/role_selection_controller.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF000000);

    final List<Map<String, String>> navItems = [
      {'title': 'Home', 'icon': 'assets/icons/home_icon.svg'},
      {'title': 'My Trips', 'icon': 'assets/icons/my_trips.svg'},
      {'title': 'History', 'icon': 'assets/icons/history.svg'},
      {'title': 'Account', 'icon': 'assets/icons/user_icon2.svg'},
    ];

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 10.h,
        top: 10.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          bool isActive = currentIndex == index;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final role = context.read<RoleController>().selectedRole ?? 'passenger';
              if (role == 'driver') {
                final routes = [
                  '/drive_home_screen',
                  '/drive_trip_screen',
                  '/drive_triphistory',
                  '/drive_profile_screen',
                ];
                context.go(routes[index]);
              } else {
                final routes = [
                  '/user_home_screen',
                  '/my_trip',
                  '/my_trip_history',
                  '/my_account',
                ];
                context.go(routes[index]);
              }
              onTap(index); 
            },

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: SvgPicture.asset(
                    navItems[index]['icon']!,
                    width: 24.w,
                    height: 24.w,
                    colorFilter: ColorFilter.mode(
                      isActive ? Colors.black : Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  navItems[index]['title']!,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight:isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}