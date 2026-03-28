import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/role_selection/controller/role_selection_controller.dart';

class SignInController extends ChangeNotifier {
  // Text Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn(BuildContext context) {
    final roleController = Provider.of<RoleController>(context, listen: false);
    final role = roleController.selectedRole;

    print("Signing in with: ${emailController.text} as $role");
    if (role == 'driver') {
      context.push('/drive_home_screen');
    } else {
      context.push('/user_home_screen');
    }
  }

  void signInWithGoogle(BuildContext context) {}
  void forgotPassword(BuildContext context) {}

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}