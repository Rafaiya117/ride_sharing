import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/role_selection/controller/role_selection_controller.dart';

class SignUpController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void createAccount(BuildContext context) {
    final roleController = Provider.of<RoleController>(context, listen: false);
    final role = roleController.selectedRole;

    print("Creating account for: ${nameController.text} as $role");
    if (role == 'driver') {
      context.push('/drive_verification_screen'); 
    } else {
      context.go('/user_home_screen');
    }
  }

  void signUpWithGoogle(BuildContext context) {}

  void navigateToSignIn(BuildContext context) {
    context.go('/sign_in');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}