import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF000000); 
    
    final List<Map<String, String>> navItems = [
      {'title': 'Home', 'icon': 'assets/icons/home.svg'},
      {'title': 'My Trips', 'icon': 'assets/icons/trips.svg'},
      {'title': 'History', 'icon': 'assets/icons/history.svg'},
      {'title': 'Account', 'icon': 'assets/icons/account.svg'},
    ];

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10.h, top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          bool isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The White Container for the Active Icon
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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