import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/auth/forgot_passowrd/view/forgot_password_view.dart';
import 'package:ride_sharing/features/auth/login/view/login.dart';
import 'package:ride_sharing/features/auth/signup/view/sign_up_view.dart';
import 'package:ride_sharing/features/cash_payment/cash_payment_view/cash_payment_view.dart';
import 'package:ride_sharing/features/chat/chat_view/chat_view.dart';
import 'package:ride_sharing/features/diver/driver_triphistory/driver_trip_history_view/driver_triphistory_view.dart';
import 'package:ride_sharing/features/home/view/home_view.dart';
import 'package:ride_sharing/features/my_trip/view/my_trip_view.dart';
import 'package:ride_sharing/features/onboarding_screens/onboarding_screen_one.dart';
import 'package:ride_sharing/features/auth/reset_password/view/reset_password_view.dart';
import 'package:ride_sharing/features/payment/payment_view/payment_view.dart';
import 'package:ride_sharing/features/rating_driver/rating_driver_view/rating_driver_view.dart';
import 'package:ride_sharing/features/review_user/review_user_view/review_user_view.dart';
import 'package:ride_sharing/features/ride_details/ride_details_view/ride_details_view.dart';
import 'package:ride_sharing/features/ride_tracking/ride_tracking_view/ride_tracking_view.dart';
import 'package:ride_sharing/features/role_selection/view/role_screen.dart';
import 'package:ride_sharing/features/search/view/search_ride_view.dart';
import 'package:ride_sharing/features/sharetrip/sharetrip_view/share_trip_view.dart';
import 'package:ride_sharing/features/splash_screen.dart';
import 'package:ride_sharing/features/auth/verify_otp/view/verify_otp_view.dart';
import 'package:ride_sharing/features/trip_history/view/my_trip_history_view.dart';
import 'package:ride_sharing/features/user_edit_profile/user_edit_profile_view/user_edit_profile_view.dart';
import 'package:ride_sharing/features/user_profile/user_profile_view/user_profile_view.dart';
import 'package:ride_sharing/features/user_settings/account/view/account_view.dart';
import 'package:ride_sharing/features/user_settings/account_notification_settings/view/account_notification_setting_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/role',
      builder: (context, state) => RoleScreen(),
    ),
    GoRoute(
      path: '/sign_in',
      builder: (context, state) => SignInScreen(),
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp_verification',
      builder: (context, state) => OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/user_home_screen',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/search_ride_screen',
      builder: (context, state) => SearchResultsScreen(),
    ),
    GoRoute(
      path: '/ride_details',
      builder: (context, state) => RideDetailsScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => ChatScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => PaymentScreen(),
    ),
    GoRoute(
      path: '/ride_tracking',
      builder: (context, state) => TrackRideScreen(),
    ),
    GoRoute(
      path: '/cash_payment',
      builder: (context, state) => CashPaymentScreen(),
    ),
    GoRoute(
      path: '/rating_screen',
      builder: (context, state) => RatingScreen(),
    ),
    GoRoute(
      path: '/profile_screen',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/edit_profile',
      builder: (context, state) => EditProfileView(),
    ),
    GoRoute(
      path: '/review_user',
      builder: (context, state) => ReviewsView(),
    ),
    GoRoute(
      path: '/share_trip_view',
      builder: (context, state) => ShareTripView(),
    ),
    GoRoute(
      path: '/my_trip',
      builder: (context, state) => MyTripsScreen(),
    ),
    GoRoute(
      path: '/my_trip_history',
      builder: (context, state) => TripHistoryScreen(),
    ),
    GoRoute(
      path: '/my_account',
      builder: (context, state) => AccountScreen(),
    ),
    GoRoute(
      path: '/account_profile_settting',
      builder: (context, state) => ProfileSettingsScreen(),
    ),
    //!----------- Driver ---------!
    GoRoute(
      path: '/drive_triphistory',
      builder: (context, state) => DriverTripHistoryScreen(),
    ),
  ],
);
