import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    // Colors from image_5.png
    const backgroundColor = Color(0xFF000000); 
    const activeBoxColor = Colors.white;
    const inactiveIconColor = Colors.white;

    final List<Map<String, String>> navItems = [
      {'title': 'Home', 'icon': 'assets/icons/home.svg'},
      {'title': 'My Trips', 'icon': 'assets/icons/trips.svg'},
      {'title': 'History', 'icon': 'assets/icons/history.svg'},
      {'title': 'Account', 'icon': 'assets/icons/account.svg'},
    ];

    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: backgroundColor,
        // Optional: match the mesh pattern header style if needed
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          bool isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The "Stage" or Active Box
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isActive ? activeBoxColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SvgPicture.asset(
                    navItems[index]['icon']!,
                    width: 24.w,
                    height: 24.w,
                    colorFilter: ColorFilter.mode(
                      isActive ? Colors.black : inactiveIconColor,
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