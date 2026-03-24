import 'package:flutter/material.dart';
import 'package:ride_sharing/core/components/onboarding_screen_template.dart';
import 'package:ride_sharing/features/onboarding_screens/controller/onboarding_screen_controller.dart';
import 'package:provider/provider.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the controller
    final controller = context.watch<OnboardingController>();

    return PageView.builder(
      controller: controller.pageController,
      itemCount: controller.onboardingData.length,
      onPageChanged: (index) => controller.updateIndex(index),
      itemBuilder: (context, index) {
        final data = controller.onboardingData[index];
        return OnboardingTemplate(
          currentIndex: controller.currentIndex,
          imagePath: data.image,
          title: data.title,
          description: data.description,
          onSkip: () => controller.navigateToLogin(context),
          onNext: () {
            if (controller.currentIndex < controller.onboardingData.length - 1) {
              controller.pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              controller.navigateToLogin(context);
            }
          },
        );
      },
    );
  }
}