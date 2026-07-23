abstract class Routes {
  Routes._();

  static const SPLASH = Paths.SPLASH;
  static const ONBOARDING = "on-boarding";

  //Account Creation
  static const REGISTERACCOUNT = "register-account";
  static const VERIFYPHONENUMBER = "verify-phone-number";
  static const ACCOUNTSETUP = "user-account-setup";
  static const EMAILSETUP = "user-email-setup";
  static const PERMISSIONSETUP = "permission-setup";

  static const LOGIN = "login";

  //Dashboard layout flow
  static const HOME = "user-dashboard";
  static const PACKAGES = "user-package";
  static const BOOKINGHISTORY = "user-bookings";
  static const PROFILE = "user-profile";

  /// Booking flow
  static const AVAILABLETRIPS = "view-available-trips";
  static const SETBOOKINGROUTE = "set-booking-route";

  //Trip Booking Route
  static const BOOKATRIP = "book-a-trip_setup";
  static const PAYFORTRIP = "pay-for-trip_setup";
  static const TRIPSUMMARY = "trip_setup-summary";

  //Package Booking Route
  static const ADDPACKAGEDETAIL = "add-package-detail";
  static const CONFIRMPACKAGEDETAIL = "confirm-package-detail";
  static const PACKAGEBOOKINGSUMMARY = "package-booking-summary";

  // Booking history
  static const BOOKINGDETAIL = 'booking-history-detail';

  // profile management route
  static const EDITUSERACCOUNT = 'edit-user-account';
  static const APPSETTINGS = 'app-settings';
  static const SUPPORT = 'help-and-support';
  // static const CHATSUPPORT = 'help-and-support-chat';

  static const WEBVIEW = 'webview';

  // static const CONFIRMPIN = "confirmpin";
  // static const FORGOTPIN = "forgotPin";
  // static const FORGETPASSWORD = "forgetPassword";
  // static const NEWPASSWORD = "newPassword";
  // static const SETAVATAR = "setAvatar";
  // static const FINGERPRINT = "fingerprint";
  // static const ENABLENOTIF = "enablenotif";
  //
  // static const SUCCESSPAGE = "successPage";
  //
  // static const NOTIFICATION = 'notification';
  //
  // //transaction
  // static const TRANSACTIONS = "transactions";
  // static const FILTERTRANSATIONSCREEN = "filter-transaction-screen";
  // static const RECEIPT = "receipt";
  //
  // //profile screens
  // static const PROFILESUBMENU = "profileSubMenu";
  // static const REPORTISSUES = "reportIssues";
  // static const REFERRAL = "referral";
  // static const SUPPORT = "support";
  // // static const LEGAL = "legal";
  //
  // // profile management
  // static const MANAGEACCOUNT = "manage-account";
  // //settings
  // static const SECURITY = "security";
  // static const NOTIFICATIONSETTINGS = "notification-settings";
  // static const RATING = "rating";
  // static const DELETEACCOUNT = "deleteAccount";
  // //security screens
  // static const CHANGEPASSWORD = "changePassword";
  // //kyc
  // static const VERIFYBVN = "verifyBVN";
  // static const VERIFYID = "verifyID";
  // static const KYCSTATUS = "kycStatus";
  // //faq
  // static const FAQ = "faq";
  // static const FAQDETAILS = "faqDetails";
  //
  // static const WEBVIEW = 'webview';
}

abstract class Paths {
  Paths._();
  // main Routes
  static const SPLASH = '/';
  static const ONBOARDING = '/${Routes.ONBOARDING}';

  //User Accounts Creation Flow
  static const REGISTERACCOUNT = "/${Routes.REGISTERACCOUNT}";
  static const VERIFYPHONENUMBER = "/${Routes.VERIFYPHONENUMBER}";
  static const ACCOUNTSETUP = "/${Routes.ACCOUNTSETUP}";
  static const EMAILSETUP = "/${Routes.EMAILSETUP}";
  static const PERMISSIONSETUP = "/${Routes.PERMISSIONSETUP}";

  static const LOGIN = '/${Routes.LOGIN}';

  //Dashboard Layout flow
  static const HOME = '/${Routes.HOME}';
  static const PACKAGES = '/${Routes.PACKAGES}';
  static const BOOKINGHISTORY = '/${Routes.BOOKINGHISTORY}';
  static const PROFILE = '/${Routes.PROFILE}';

  ///Booking flow
  static const AVAILABLETRIPS = '/${Routes.AVAILABLETRIPS}';
  static const SETBOOKINGROUTE = '/${Routes.SETBOOKINGROUTE}';
  //Trip Booking Route
  static const BOOKATRIP = "/${Routes.BOOKATRIP}";
  static const PAYFORTRIP = "/${Routes.PAYFORTRIP}";
  static const TRIPSUMMARY = "/${Routes.TRIPSUMMARY}";

  //Package Booking Route
  static const ADDPACKAGEDETAIL = '/${Routes.ADDPACKAGEDETAIL}';
  static const CONFIRMPACKAGEDETAIL = '/${Routes.CONFIRMPACKAGEDETAIL}';
  static const PACKAGEBOOKINGSUMMARY = '/${Routes.PACKAGEBOOKINGSUMMARY}';

  // Booking history
  static const BOOKINGDETAIL = '/${Routes.BOOKINGDETAIL}';

  // profile management route
  static const EDITUSERACCOUNT = '/${Routes.EDITUSERACCOUNT}';
  static const APPSETTINGS = '/${Routes.APPSETTINGS}';
  static const SUPPORT = '/${Routes.SUPPORT}';
  // static const CHATSUPPORT = '/${Routes.CHATSUPPORT}';

  static const WEBVIEW = '/${Routes.WEBVIEW}';
}
