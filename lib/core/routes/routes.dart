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
  static const BOOKINGHISTORY = "user-booking-history";
  static const PROFILE = "user-profile";

  //Trip Booking Route
  static const AVAILABLETRIPS = "view-available-booking_history";
  static const BOOKATRIP = "book-a-trip";
  static const PAYFORTRIP = "pay-for-trip";
  static const TRIPSUMMARY = "trip-summary";

  //Package Booking Route
  static const ADDPACKAGEDETAIL = "add-package-detail";
  static const CONFIRMPACKAGEDETAIL = "confirm-package-detail";
  static const PACKAGEBOOKINGSUMMARY = "package-booking-summary";

  // Booking history
  static const BOOKINGHISTORYDETAIL = 'booking-history';

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

  //Trip Booking Route
  static const AVAILABLETRIPS = '/${Routes.AVAILABLETRIPS}';
  static const BOOKATRIP = "/${Routes.BOOKATRIP}";
  static const PAYFORTRIP = "/${Routes.PAYFORTRIP}";
  static const TRIPSUMMARY = "/${Routes.TRIPSUMMARY}";

  //Package Booking Route
  static const ADDPACKAGEDETAIL = '/${Routes.ADDPACKAGEDETAIL}';
  static const CONFIRMPACKAGEDETAIL = '/${Routes.CONFIRMPACKAGEDETAIL}';
  static const PACKAGEBOOKINGSUMMARY = '/${Routes.PACKAGEBOOKINGSUMMARY}';

  // Booking history
  static const BOOKINGHISTORYDETAIL = '/${Routes.BOOKINGHISTORYDETAIL}';

  // static const CONFIRMPIN = '/${Routes.CONFIRMPIN}';
  // static const FORGOTPIN = "/${Routes.FORGOTPIN}";
  // static const FORGETPASSWORD = "/${Routes.FORGETPASSWORD}";
  // static const NEWPASSWORD = '/${Routes.NEWPASSWORD}';
  // static const SETAVATAR = "/${Routes.SETAVATAR}";
  // static const FINGERPRINT = "/${Routes.FINGERPRINT}";
  // static const ENABLENOTIF = "/${Routes.ENABLENOTIF}";
  //
  // static const SUCCESSPAGE = '/${Routes.SUCCESSPAGE}';
  //
  // //homes
  // static const NOTIFICATION = "/${Routes.NOTIFICATION}";
  //
  // //transactions
  // static const TRANSACTIONS = "/${Routes.TRANSACTIONS}";
  // static const FILTERTRANSATIONSCREEN = "/${Routes.FILTERTRANSATIONSCREEN}";
  // static const RECEIPT = "/${Routes.RECEIPT}";
  //
  // // profile screens
  // static const PROFILESUBMENU = "/${Routes.PROFILESUBMENU}";
  // static const REPORTISSUES = "/${Routes.REPORTISSUES}";
  // static const REFERRAL = "/${Routes.REFERRAL}";
  // static const SUPPORT = "/${Routes.SUPPORT}";
  // // static const LEGAL = "/${Routes.LEGAL}";
  //
  // // profile management
  // static const MANAGEACCOUNT = "/${Routes.MANAGEACCOUNT}";
  //
  // // settings
  // static const SECURITY = "/${Routes.SECURITY}";
  // static const NOTIFICATIONSETTINGS = "/${Routes.NOTIFICATIONSETTINGS}";
  // static const RATING = "/${Routes.RATING}";
  // static const DELETEACCOUNT = "/${Routes.DELETEACCOUNT}";
  // //security screen
  // static const CHANGEPASSWORD = "/${Routes.CHANGEPASSWORD}";
  //
  // //kyc
  // static const VERIFYBVN = "/${Routes.VERIFYBVN}";
  // static const VERIFYID = "/${Routes.VERIFYID}";
  // static const KYCSTATUS = "/${Routes.KYCSTATUS}";
  //
  // //faq
  // static const FAQ = "/${Routes.FAQ}";
  // static const FAQDETAILS = "/${Routes.FAQDETAILS}";
  //
  // static const WEBVIEW = "/${Routes.WEBVIEW}";
}
