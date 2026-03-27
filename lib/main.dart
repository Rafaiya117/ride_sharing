import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/config/app_route/app_router.dart';
import 'package:ride_sharing/config/connectivity/no_connectivity.dart';
import 'package:ride_sharing/features/auth/forgot_passowrd/forgot_password_controller/forgot_password_controller.dart';
import 'package:ride_sharing/features/auth/login/login_controller/login_controller.dart';
import 'package:ride_sharing/features/auth/reset_password/reset_passsword_controller/reset_passowrd_controller.dart';
import 'package:ride_sharing/features/auth/signup/sign_up_controller/sign_up_controller.dart';
import 'package:ride_sharing/features/cash_payment/cash_payment_controller/cash_payment_controller.dart';
import 'package:ride_sharing/features/chat/chat_controller/chat_controller.dart';
import 'package:ride_sharing/features/diver/driver_triphistory/driver_triphistory_controller/driver_triphistory_controller.dart';
import 'package:ride_sharing/features/home/home_controller/home_controller.dart';
import 'package:ride_sharing/features/my_trip/controller/my_trip_controller.dart';
import 'package:ride_sharing/features/onboarding_screens/controller/onboarding_screen_controller.dart';
import 'package:ride_sharing/features/payment/payment_controller/payment_controller.dart';
import 'package:ride_sharing/features/rating_driver/rating_driver_controller/rating_driver_controller.dart';
import 'package:ride_sharing/features/review_user/review_user_controller/review_user_controller.dart';
import 'package:ride_sharing/features/ride_details/ride_details_controller/ride_details_controller.dart';
import 'package:ride_sharing/features/ride_tracking/ride_traking_controller/ride_tracking_controller.dart';
import 'package:ride_sharing/features/role_selection/controller/role_selection_controller.dart';
import 'package:ride_sharing/features/auth/verify_otp/verify_otp_controller/verify_otp_controller.dart';
import 'package:ride_sharing/features/search/controller/search_ride_controller.dart';
import 'package:ride_sharing/features/sharetrip/share_trip_controller/share_trip_controller.dart';
import 'package:ride_sharing/features/trip_history/controller/my_trip_history_controller.dart';
import 'package:ride_sharing/features/user_edit_profile/user_edit_profile_controller/user_edit_profile_controller.dart';
import 'package:ride_sharing/features/user_profile/user_profile_controller/user_profile_controller.dart';
import 'package:ride_sharing/features/user_settings/account/controller/account_controller.dart';
import 'package:ride_sharing/features/user_settings/account_notification_settings/account_notification_setting_controller.dart/account_notification_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasConnection = true;
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((status) {
      if (!mounted) return; 
      setState(() {
        hasConnection = status != ConnectivityResult.none;
      });
    });
  }


  Future<void> _checkConnectivity() async {
    final status = await Connectivity().checkConnectivity();
    if (!mounted) return; 
    setState(() {
      hasConnection = status != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => OnboardingController()),
            ChangeNotifierProvider(create: (_)=> RoleController()),
            ChangeNotifierProvider(create: (_)=> SignInController()),
            ChangeNotifierProvider(create: (_)=> SignUpController()),
            ChangeNotifierProvider(create: (_)=> ForgotPasswordController()),
            ChangeNotifierProvider(create: (_)=> OtpController()),
            ChangeNotifierProvider(create: (_)=> ResetPasswordController()),
            ChangeNotifierProvider(create: (_)=> HomeController()),
            ChangeNotifierProvider(create: (_)=> SearchResultsController()),
            ChangeNotifierProvider(create: (_)=> RideDetailsController()),
            ChangeNotifierProvider(create: (_)=> ChatController()),
            ChangeNotifierProvider(create: (_)=> PaymentController()),
            ChangeNotifierProvider(create: (_)=> TrackRideController()),
            ChangeNotifierProvider(create: (_)=> CashPaymentController()),
            ChangeNotifierProvider(create: (_)=> RatingController()),
            ChangeNotifierProvider(create: (_)=> ProfileController()),
            ChangeNotifierProvider(create: (_)=> EditProfileController()),
            ChangeNotifierProvider(create: (_)=> ReviewsController()),
            ChangeNotifierProvider(create: (_)=> ShareTripController()),
            ChangeNotifierProvider(create: (_)=> MyTripsController()),
            ChangeNotifierProvider(create: (_)=> TripHistoryController()),
            ChangeNotifierProvider(create: (_)=> AccountController()),
            ChangeNotifierProvider(create: (_)=> ProfileSettingsController()),

            //!------------ Driver ------------!
            ChangeNotifierProvider(create: (_)=> DriverTripHistoryController()),
          ],
          child: Builder(
            builder: (context) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                routerConfig: appRouter,
                builder: (context, child) {
                  return hasConnection
                    ? child! : const NoInternetWidget();
                },
              );
            },
          ),
        );
      },
    );
  }
}
