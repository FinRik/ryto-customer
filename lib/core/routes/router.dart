import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/layout/bottom_nav_layout.dart';
import '../../ui/screens/auth/account_setup/account_setup_screen.dart';
import '../../ui/screens/auth/account_setup/email_setup_screen.dart';
import '../../ui/screens/auth/account_setup/enable_permission_screen.dart';
import '../../ui/screens/auth/login/login_screen.dart';
import '../../ui/screens/auth/register/register_screen.dart';
import '../../ui/screens/auth/verify_phone/verify_phone_number_screen.dart';
import '../../ui/screens/dashboard/books/books_screen.dart';
import '../../ui/screens/dashboard/packages/packages_screen.dart';
import '../../ui/screens/dashboard/profile/profile_screen.dart';
import '../../ui/screens/dashboard/trips/trips_screens.dart';
import '../../ui/screens/onboarding/onboarding_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
// final scaffoldKey = GlobalKey<ScaffoldState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

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
          VerifyPhoneNumberScreen(phoneNumber: state.extra as String),
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
          path: Paths.BOOK,
          name: Routes.BOOK,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const BooksScreen(),
        ),
        GoRoute(
          path: Paths.PACKAGES,
          name: Routes.PACKAGES,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const PackagesScreen(),
        ),
        GoRoute(
          path: Paths.TRIPS,
          name: Routes.TRIPS,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const TripsScreen(),
        ),
        GoRoute(
          path: Paths.PROFILE,
          name: Routes.PROFILE,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.FORGETPASSWORD,
    //   name: Routes.FORGETPASSWORD,
    //   builder: (context, state) => const ForgetPasswordScreen(),
    // ),
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
    //
    // //bills sub screens
    // GoRoute(
    //   path: Paths.AIRTIMEDETAILS,
    //   name: Routes.AIRTIMEDETAILS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const AirtimeDetails(),
    // ),
    // GoRoute(
    //   path: Paths.AIRTIMETODATADETAILS,
    //   name: Routes.AIRTIMETODATADETAILS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const AirtimeToCash(),
    // ),
    // GoRoute(
    //   path: Paths.USSDCODES,
    //   name: Routes.USSDCODES,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const UssdCodes(),
    // ),
    // GoRoute(
    //   path: Paths.DATADETAILS,
    //   name: Routes.DATADETAILS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const DataDetails(),
    // ),
    // GoRoute(
    //   path: Paths.CABLEDETAILS,
    //   name: Routes.CABLEDETAILS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const CableDetails(),
    // ),
    // GoRoute(
    //   path: Paths.ELECTRICITYDETAILS,
    //   name: Routes.ELECTRICITYDETAILS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const ElectricityDetails(),
    // ),
    // GoRoute(
    //   path: Paths.EDUCATIONDETAILS,
    //   name: Routes.EDUCATIONDETAILS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const EducationDetails(),
    // ),
    // GoRoute(
    //   path: Paths.BULKSMSDETAILS,
    //   name: Routes.BULKSMSDETAILS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const BulkSmsDetails(),
    // ),
    // GoRoute(
    //   path: Paths.BILLSRESPONSE,
    //   name: Routes.BILLSRESPONSE,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) =>
    //       BillsResponseScreen(item: state.extra as BillsResponse),
    // ),
    // //beneficiary
    // GoRoute(
    //   path: Paths.BENEFICIARY,
    //   name: Routes.BENEFICIARY,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) =>
    //       BeneficiaryScreen(filter: state.extra as String),
    // ),
    //
    // //wallet screens
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.FUNDINGMETHODS,
    //   name: Routes.FUNDINGMETHODS,
    //   builder: (context, state) => const FundingMethodScreen(),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.USSDFUNDING,
    //   name: Routes.USSDFUNDING,
    //   builder: (context, state) => const UssdFundingScreen(),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.CARDFUNDING,
    //   name: Routes.CARDFUNDING,
    //   builder: (context, state) => const CardFundingScreen(),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.MANUALFUNDING,
    //   name: Routes.MANUALFUNDING,
    //   builder: (context, state) => const ManualFundingScreen(),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.WALLETHISTORY,
    //   name: Routes.WALLETHISTORY,
    //   builder: (context, state) => const WalletHistory(),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.FILTERWALLETHISTORY,
    //   name: Routes.FILTERWALLETHISTORY,
    //   builder: (context, state) => const FilterWalletHistory(),
    // ),
    //
    // // profile sub screens
    // GoRoute(
    //   path: Paths.VERIFYBVN,
    //   name: Routes.VERIFYBVN,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const VerifyBvnScreen(),
    // ),
    //
    // GoRoute(
    //   path: Paths.VERIFYID,
    //   name: Routes.VERIFYID,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const VerifyIdScreen(),
    // ),
    //
    // GoRoute(
    //   path: Paths.KYCSTATUS,
    //   name: Routes.KYCSTATUS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const KycStatusScreen(),
    // ),
    //
    // GoRoute(
    //   path: Paths.PROFILESUBMENU,
    //   name: Routes.PROFILESUBMENU,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) =>
    //       ProfileSubMenu(args: state.extra as ProfileSubMenuArgs),
    // ),
    //
    // GoRoute(
    //   path: Paths.REFERRAL,
    //   name: Routes.REFERRAL,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) =>
    //       ReferralScreen(args: state.extra as ProfileSubMenuArgs),
    // ),
    //
    // GoRoute(
    //   path: Paths.SUPPORT,
    //   name: Routes.SUPPORT,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) =>
    //       SupportScreen(args: state.extra as ProfileSubMenuArgs),
    // ),
    //
    // //profile management screen
    // GoRoute(
    //   path: Paths.MANAGEACCOUNT,
    //   name: Routes.MANAGEACCOUNT,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   path: Paths.SUREPLUGID,
    //   name: Routes.SUREPLUGID,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const CreateUserId(),
    // ),
    // //settings screens
    // GoRoute(
    //   path: Paths.SECURITY,
    //   name: Routes.SECURITY,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const SecuritySettings(),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.CHANGEPASSWORD,
    //   name: Routes.CHANGEPASSWORD,
    //   builder: (context, state) => const ChangePasswordScreen(),
    // ),
    // GoRoute(
    //   path: Paths.NOTIFICATIONSETTINGS,
    //   name: Routes.NOTIFICATIONSETTINGS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const NotificationSettings(),
    // ),
    // GoRoute(
    //   path: Paths.DELETEACCOUNT,
    //   name: Routes.DELETEACCOUNT,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) =>
    //       EmptyStateScreen(args: state.extra as EmptyStateArgs?),
    // ),
    // //faq
    // GoRoute(
    //   path: Paths.FAQ,
    //   name: Routes.FAQ,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const FaqScreen(),
    // ),
    // GoRoute(
    //   path: Paths.FAQDETAILS,
    //   name: Routes.FAQDETAILS,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) =>
    //       FaqDetailsScreen(id: state.extra as FaqEntity),
    // ),
    //
    // GoRoute(
    //   path: Paths.WEBVIEW,
    //   name: Routes.WEBVIEW,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => WebViewScreen(url: state.extra as String),
    // ),
    // GoRoute(
    //   path: Paths.VERIFYACCOUNT,
    //   name: Routes.VERIFYACCOUNT,
    //   builder: (context, state) => const VerifyAccountScreen(),
    // ),
    // GoRoute(
    //   path: Paths.NOTIFICATIONS,
    //   name: Routes.NOTIFICATIONS,
    //   builder: (context, state) => const NotificationScreen(),
    // ),
    // GoRoute(
    //   path: Paths.UNAVAILABLE,
    //   name: Routes.UNAVAILABLE,
    //   builder: (context, state) => const UnauthorizedBottomSheet(),
    // ),
    // GoRoute(
    //   path: Paths.PAYMENTSUCCESS,
    //   name: Routes.PAYMENTSUCCESS,
    //   onExit: (context, _) async => false,
    //   builder: (context, state) => PaymentSuccess(
    //     args: state.extra as PaymentStatusArgs,
    //   ),
    // ),
    // GoRoute(
    //   path: Paths.PAYMENTFAILED,
    //   name: Routes.PAYMENTFAILED,
    //   onExit: (context, _) async => false,
    //   builder: (context, state) => PaymentFailed(
    //     args: state.extra as PaymentStatusArgs,
    //   ),
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

// class ResetPassArgs {
//   final String code;
//   final String email;
//
//   ResetPassArgs({required this.code, required this.email});
// }
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
