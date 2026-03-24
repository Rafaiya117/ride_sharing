import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInController extends ChangeNotifier {
  // Text Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn(BuildContext context) {
    print("Signing in with: ${emailController.text}");
    context.push('/user_home_screen');
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