import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_role_card.dart';
import 'package:ride_sharing/features/role_selection/controller/role_selection_controller.dart';


class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RoleController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Text(
              "Choose Your Role",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "How would you like to use RideShare?",
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF7A7A7A),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(flex: 1),
            
            // Map through the roles from controller
            ...controller.roles.map((role) => RoleCard(
                  title: role.title,
                  description: role.description,
                  iconPath: role.iconPath,
                  isSelected: controller.selectedRole == role.id,
                  onTap: () => controller.onRoleSelected(context, role.id),
                )),

            const Spacer(flex: 3),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                "You can switch roles anytime in settings",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF7A7A7A),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}