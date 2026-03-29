import 'package:go_router/go_router.dart';
import 'package:ride_sharing/features/auth/forgot_passowrd/view/forgot_password_view.dart';
import 'package:ride_sharing/features/auth/login/view/login.dart';
import 'package:ride_sharing/features/auth/signup/view/sign_up_view.dart';
import 'package:ride_sharing/features/cash_payment/cash_payment_view/cash_payment_view.dart';
import 'package:ride_sharing/features/chat/chat_view/chat_view.dart';
import 'package:ride_sharing/features/diver/confirm_widthdrawal/confirm_withdrawal_view/confirm_withdrawal_view.dart';
import 'package:ride_sharing/features/diver/drive_trip/driver_trip_view/driver_trip_view.dart';
import 'package:ride_sharing/features/diver/driver_booking_confirm/driver_bookingconfirm_view/driver_bookingconfirm_view.dart';
import 'package:ride_sharing/features/diver/driver_edit_profile/driver_edit_profile_view/driver_edit_profile_view.dart';
import 'package:ride_sharing/features/diver/driver_homepage/view/driver-homepage_view.dart';
import 'package:ride_sharing/features/diver/driver_profile/driver_profile_view/driver_profile_view.dart';
import 'package:ride_sharing/features/diver/driver_rating/driver_rating_view/driver_rating_view.dart';
import 'package:ride_sharing/features/diver/driver_review/driver_review_view/driver_review_view.dart';
import 'package:ride_sharing/features/diver/driver_ride_complete/driver_ride_complete_view/driver_ridecomplete_view.dart';
import 'package:ride_sharing/features/diver/driver_ride_details/driver_ridedetails_view/driver_ridedeatils_view.dart';
import 'package:ride_sharing/features/diver/driver_track_ride/driver_track_ride_view/driver_tarck_ride_view.dart';
import 'package:ride_sharing/features/diver/driver_triphistory/driver_trip_history_view/driver_triphistory_view.dart';
import 'package:ride_sharing/features/diver/driver_verification/driver_verification_view/driver_verification_view.dart';
import 'package:ride_sharing/features/diver/earning/view/earning_view.dart';
import 'package:ride_sharing/features/diver/withdrawal/withdrawal_view/withdrawal_flow.dart';
import 'package:ride_sharing/features/diver/withdrawal/withdrawal_view/withdrawal_view.dart';
import 'package:ride_sharing/features/home/view/home_view.dart';
import 'package:ride_sharing/features/my_trip/view/my_trip_view.dart';
import 'package:ride_sharing/features/notification/notification_view/notification_view.dart';
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
import 'package:ride_sharing/features/user_settings/privacy_policy/privacy_policy_view.dart';
import 'package:ride_sharing/features/user_settings/term_condition/term_condition.dart';

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
    //!-------------Auth-----------!
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
    //!------------- Passenger ------------!
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
    //!----------- Driver ---------!
    GoRoute(
      path: '/drive_verification_screen',
      builder: (context, state) => DriverVerificationScreen(),
    ),
    GoRoute(
      path: '/drive_home_screen',
      builder: (context, state) => DriverHomeScreen(),
    ),
    GoRoute(
      path: '/drive_earning_screen',
      builder: (context, state) => EarningsView(),
    ),
    GoRoute(
      path: '/drive_withdrawal_screen',
      builder: (context, state) => WithdrawalView(),
    ),
    GoRoute(
      path: '/drive_withdrawalflow_screen',
      builder: (context, state) => WithdrawalFlowView(),
    ),
    GoRoute(
      path: '/drive_confirmwithdrawal_screen',
      builder: (context, state) => ConfirmWithdrawalView(),
    ),
    GoRoute(
      path: '/drive_bookingconfirm_screen',
      builder: (context, state) => BookingConfirmScreen(),
    ),
    GoRoute(
      path: '/drive_profile_screen',
      builder: (context, state) => DriverProfileView(),
    ),
    GoRoute(
      path: '/drive_edit_profile_screen',
      builder: (context, state) => DriverEditView(),
    ),
    GoRoute(
      path: '/drive_review_screen',
      builder: (context, state) => DriverReviewView(),
    ),
    GoRoute(
      path: '/drive_trip_screen',
      builder: (context, state) => DriverTripScreen(),
    ),
    GoRoute(
      path: '/drive_ridedetails_screen',
      builder: (context, state) => DriverRideDetailsScreen(),
    ),
    GoRoute(
      path: '/drive_trackride_screen',
      builder: (context, state) => DriverTrackScreen(),
    ),
    GoRoute(
      path: '/drive_complateride_screen',
      builder: (context, state) => RideCompletedScreen(),
    ),
    GoRoute(
      path: '/drive_rating_screen',
      builder: (context, state) => DriverRatingScreen(),
    ),
    GoRoute(
      path: '/drive_triphistory',
      builder: (context, state) => DriverTripHistoryScreen(),
    ),

    //!-------------- Shared -------------!
    GoRoute(
      path: '/my_account',
      builder: (context, state) => AccountScreen(),
    ),
    GoRoute(
      path: '/account_profile_settting',
      builder: (context, state) => ProfileSettingsScreen(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => PrivacyPolicyPage(),
    ),
    GoRoute(
      path: '/term',
      builder: (context, state) => TermsOfServicePage(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationsScreen(),
    ),
    
  ],
);
