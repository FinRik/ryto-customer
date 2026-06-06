import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/layout/bottom_nav_layout.dart';
import '../../ui/screens/account_setup/account_setup_screen.dart';
import '../../ui/screens/account_setup/email_setup_screen.dart';
import '../../ui/screens/account_setup/enable_permission_screen.dart';
import '../../ui/screens/dashboard/bookings/parts/pending_status_widget.dart';
import '../../ui/screens/dashboard/bookings/bookings_screen.dart';
import '../../ui/screens/dashboard/bookings/booking_details_screen.dart';
import '../../ui/screens/dashboard/package/01_available_trips_screen.dart';
import '../../ui/screens/dashboard/package/04_package_booking_summary_screen.dart';
import '../../ui/screens/auth/ui/verify_phone/verify_phone_number_screen.dart';
import '../../ui/screens/dashboard/package/02_add_package_detail_screen.dart';
import '../../ui/screens/dashboard/package/03_confirm_package_select_screen.dart';
import '../../ui/screens/dashboard/package/packages_screen.dart';
import '../../ui/screens/dashboard/profile/app_settings_screen.dart';
import '../../ui/screens/dashboard/profile/edit_user_profile.dart';
import '../../ui/screens/dashboard/profile/help_support_screen.dart';
import '../../ui/screens/dashboard/profile/profile_screen.dart';
import '../../ui/screens/auth/ui/register/register_screen.dart';
import '../../ui/screens/dashboard/trip_setup/available_trips_screen.dart';
import '../../ui/screens/dashboard/trip_setup/book_a_trip_screen.dart';
import '../../ui/screens/dashboard/trip_setup/pay_for_trip_screen.dart';
import '../../ui/screens/dashboard/trip_setup/trip_booking_summary_screen.dart';
import '../../ui/screens/dashboard/trip_setup/trips_setup_screen.dart';
import '../../ui/screens/onboarding/onboarding_screen.dart';
import '../../ui/screens/auth/ui/login/login_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../../ui/screens/app_webview.dart';
import '../models/booking/booking_response.dart';
import '../models/booking/booking_summary.dart';
import '../models/ride/ride.dart';
import '../models/ui/package_size.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
// final scaffoldKey = GlobalKey<ScaffoldState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

BuildContext? get rootContext => _rootNavigatorKey.currentContext;

final router = GoRouter(
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  restorationScopeId: "app",
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.SPLASH,
      name: Routes.SPLASH,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.ONBOARDING,
      name: Routes.ONBOARDING,
      builder: (context, state) => const OnboardingScreen(),
    ),

    //Account Creation Floe
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.REGISTERACCOUNT,
      name: Routes.REGISTERACCOUNT,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: Paths.VERIFYPHONENUMBER,
      name: Routes.VERIFYPHONENUMBER,
      builder: (context, state) =>
          VerifyPhoneNumberScreen(args: state.extra as VerifyOtpArgs),
    ),
    GoRoute(
      path: Paths.ACCOUNTSETUP,
      name: Routes.ACCOUNTSETUP,
      builder: (context, state) => AccountSetupScreen(),
    ),
    GoRoute(
      path: Paths.EMAILSETUP,
      name: Routes.EMAILSETUP,
      builder: (context, state) => EmailSetupScreen(),
    ),
    GoRoute(
      path: Paths.PERMISSIONSETUP,
      name: Routes.PERMISSIONSETUP,
      builder: (context, state) => EnablePermissionScreen(),
    ),

    //
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.LOGIN,
      name: Routes.LOGIN,
      builder: (context, state) => const LoginScreen(),
    ),

    //Dashboard Layout Flow
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, child) => BottomNavLayout(child: child),
      routes: [
        GoRoute(
          path: Paths.HOME,
          name: Routes.HOME,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const TripsSetupScreen(),
        ),
        GoRoute(
          path: Paths.PACKAGES,
          name: Routes.PACKAGES,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const PackagesScreen(),
        ),
        GoRoute(
          path: Paths.BOOKINGHISTORY,
          name: Routes.BOOKINGHISTORY,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: Paths.PROFILE,
          name: Routes.PROFILE,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    //Trip Booking Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.AVAILABLETRIPS,
      name: Routes.AVAILABLETRIPS,
      builder: (context, state) =>
          AvailableTripsScreen(args: state.extra as AvailableTripsArgs),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.BOOKATRIP,
      name: Routes.BOOKATRIP,
      builder: (context, state) => BookATripScreen(ride: state.extra as Ride),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.PAYFORTRIP,
      name: Routes.PAYFORTRIP,
      builder: (context, state) =>
          PayForTripScreen(args: state.extra as TripBookingSummaryArgs),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.TRIPSUMMARY,
      name: Routes.TRIPSUMMARY,
      builder: (context, state) =>
          TripBookingSummaryScreen(args: state.extra as TripBookingSummaryArgs),
    ),

    //Package Booking Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.PACKAGEAVAILABLETRIPS,
      name: Routes.PACKAGEAVAILABLETRIPS,
      builder: (context, state) =>
          PackagesAvailableTripsScreen(args: state.extra as AvailableTripsArgs),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.ADDPACKAGEDETAIL,
      name: Routes.ADDPACKAGEDETAIL,
      builder: (context, state) =>
          AddPackageDetailScreen(ride: state.extra as Ride),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.CONFIRMPACKAGEDETAIL,
      name: Routes.CONFIRMPACKAGEDETAIL,
      builder: (context, state) => ConfirmPackageSelectScreen(
        args: state.extra as ConfirmPackageSelectArgs,
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.PACKAGEBOOKINGSUMMARY,
      name: Routes.PACKAGEBOOKINGSUMMARY,
      builder: (context, state) => PackageBookingSummaryScreen(
        ride: state.extra as Ride,
      ),
    ),

    //Booking history Route
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.BOOKINGSTATUS,
    //   name: Routes.BOOKINGSTATUS,
    //   builder: (context, state) =>
    //       BookingStatusScreen(trip: state.extra as Ride),
    // ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.BOOKINGDETAIL,
      name: Routes.BOOKINGDETAIL,
      builder: (context, state) =>
          BookingDetailsScreen(tripId: state.extra as String),
    ),

    // profile management route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.EDITUSERACCOUNT,
      name: Routes.EDITUSERACCOUNT,
      builder: (context, state) => ProfileManagementScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.APPSETTINGS,
      name: Routes.APPSETTINGS,
      builder: (context, state) => const AppSettingsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.SUPPORT,
      name: Routes.SUPPORT,
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.WEBVIEW,
      name: Routes.WEBVIEW,
      builder: (context, state) => AppWebview(args: state.extra as WebviewArgs),
    ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.SECURITYPIN,
    //   name: Routes.SECURITYPIN,
    //   builder: (context, state) =>
    //       SecurityPinScreen(args: state.extra as PinArgs),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.CONFIRMPIN,
    //   name: Routes.CONFIRMPIN,
    //   builder: (context, state) =>
    //       ConfirmPinScreen(args: state.extra as PinArgs),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.FORGOTPIN,
    //   name: Routes.FORGOTPIN,
    //   builder: (context, state) => const ForgotPinScreen(),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.NEWPASSWORD,
    //   name: Routes.NEWPASSWORD,
    //   builder: (context, state) =>
    //       ResetPasswordScreen(args: state.extra as ResetPassArgs),
    // ),
    // GoRoute(
    //   path: Paths.SETAVATAR,
    //   name: Routes.SETAVATAR,
    //   builder: (context, state) => const AvatarScreen(),
    // ),
    // GoRoute(
    //   path: Paths.FINGERPRINT,
    //   name: Routes.FINGERPRINT,
    //   builder: (context, state) => const EnableFingerprintScreen(),
    // ),
    // GoRoute(
    //   path: Paths.ENABLENOTIF,
    //   name: Routes.ENABLENOTIF,
    //   builder: (context, state) => const EnableNotificationScreen(),
    // ),
    //
    //
    // //notification screens
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.NOTIFICATION,
    //   name: Routes.NOTIFICATION,
    //   builder: (context, state) => const NotificationScreen(),
    // ),
    //
    // //transaction histories
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.TRANSACTIONS,
    //   name: Routes.TRANSACTIONS,
    //   builder: (context, state) => const TransactionHistory(),
    // ),
    //
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.FILTERTRANSATIONSCREEN,
    //   name: Routes.FILTERTRANSATIONSCREEN,
    //   builder: (context, state) => const FilterTransactionScreen(),
    // ),
    //
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.RECEIPT,
    //   name: Routes.RECEIPT,
    //   builder: (context, state) => TransactionReceipt(item: state.extra),
    // ),
  ],
);

// extension GoRouterExt on GoRouter {
//   String get _currentRouteName => routerDelegate.currentConfiguration.last.route.name ?? "";
//
//   void popUntil(String routeName) {
//     var currentRouteName = _currentRouteName;
//     while (currentRouteName != routeName && currentRouteName.isNotEmpty && canPop()) {
//       pop();
//       currentRouteName = _currentRouteName;
//     }
//   }
// }

class VerifyOtpArgs {
  final String phone;
  final bool isLogin;

  VerifyOtpArgs({required this.phone, required this.isLogin});
}

class AvailableTripsArgs {
  final String? destinationCity;
  final String? originCity;
  final String? departureDate;
  final int? passengerSeats;

  AvailableTripsArgs({
    this.destinationCity,
    this.originCity,
    this.departureDate,
    this.passengerSeats,
  });
}

class TripBookingSummaryArgs {
  final Ride? ride;
  final BookingSummary? summary;
  final BookingResponse? bookingResponse;

  TripBookingSummaryArgs({this.ride, this.summary, this.bookingResponse});
}

class ConfirmPackageSelectArgs {
  final PackageSize packageSize;
  final Ride ride;

  ConfirmPackageSelectArgs({required this.packageSize, required this.ride});
}

class WebviewArgs {
  final String? title;
  final String url;

  WebviewArgs({this.title, required this.url});
}

//
// class OtpArgs {
//   const OtpArgs({
//     required this.email,
//     required this.route,
//     this.isVerify = false,
//   });
//
//   final String email;
//   final AuthRoute route;
//   final bool isVerify;
// }
//
// class PinArgs {
//   const PinArgs({
//     this.isVerify = false,
//     this.model,
//     required this.route,
//     this.password,
//   });
//
//   final bool isVerify;
//   final PinRoute route;
//   final PinViewModel? model;
//   final String? password;
// }
//
// class EmptyStateArgs {
//   const EmptyStateArgs({this.title, this.subtitle, this.image, this.btnText});
//
//   final String? title;
//   final String? image;
//   final String? subtitle;
//   final String? btnText;
// }
//
// // class ServiceArgs {
// //   const ServiceArgs({
// //     required this.title,
// //     required this.model,
// //   });
// //
// //   final String title;
// //   final ServiceViewModel model;
// // }
//
// class ProfileSubMenuArgs {
//   final String title;
//   final List<ActionModel>? list;
//
//   ProfileSubMenuArgs({required this.title, this.list});
// }
//
// class TransactionArgs<T> {
//   final T data;
//
//   TransactionArgs({required this.data});
// }
