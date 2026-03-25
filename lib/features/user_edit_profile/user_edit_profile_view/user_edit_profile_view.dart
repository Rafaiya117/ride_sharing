import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/custom_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/user_edit_profile/user_edit_profile_controller/user_edit_profile_controller.dart';
import 'package:ride_sharing/features/user_edit_profile/widget/image_section.dart';
import 'package:ride_sharing/features/user_edit_profile/widget/profile_form.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditProfileController>(context, listen: false);

    return BaseScaffold(
      title: "Edit Profile",
      isCurved: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          print("Action dynamically triggered: Navigate back");
        },
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/pencil.svg',
            width: 20.r,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            print("Action dynamically triggered: Edit Pencil (placeholder)");
          },
        ),
      ],
      child: Column(
        children: [
          SizedBox(height: 10.h),
          const PhotoHeader(),
          const ProfileForm(),
          SizedBox(height: 40.h),
          CustomButton(
            text: "Save Changes",
            onTap: controller.saveChanges,
            iconPath: 'assets/icons/save.svg',
            //isLoading: controller.isLoading,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}