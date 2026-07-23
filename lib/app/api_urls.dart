class ApiUrls {
  ApiUrls._();

  static const String baseUrl = "https://api.getryto.com";
  static const String countryBaseUrl = "https://countriesnow.space/api/v0.1";
  static const String paystackUrl = "https://api.paystack.co";
  static const String stripeBaseUrl = "https://api.stripe.com/v1";

  static const String states = "/countries/states";
  static const String cities = "/countries";

  static const String locationUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String placeDetailsUrl =
      "https://maps.googleapis.com/maps/api/place/details/json";
  // socials
  static const String instagram = "https://www.instagram.com/rytoapp";
  static const String facebook =
      "https://www.facebook.com/share/16xszJZNrY/?mibextid=wwXIfr";
  static const String tiktok = "https://www.tiktok.com/@rytoapp";
  static const String linkedIn = "https://www.linkedin.com/company/rytoapp/";
  static const String twitter = "https://www.x.com/rytoapp";
  static const String faq = "https://getryto.com/faqs";
  static const String privacy = "https://getryto.com/privacy";
  static const String terms = "https://getryto.com/terms";
  static const String website = "https://getryto.com";

  static const String login = "/auth/customer/login/phone";
  static const String verifyLogin = "/auth/customer/verify-login";

  static const String register = "/auth/customer/signup/phone";
  static const String verifyOtp = "/auth/customer/verify/phone";
  static const String resendOtp = "/auth/customer/resend-phone-verification";
  static const String sso = "/auth/customer/verify-google-token";
  static const String updateFCMToken = "/auth/customer/push-token";
  static const String deleteFCMToken = "/auth/customer/push-token";

  // Profile
  static const String fetchProfile = "/auth/customer/user";
  static const String updateProfile = "/auth/customer/complete-profile";

  // Trips
  static const String trips = "/customer/trips";
  static const String tripSummary = "/customer/trips/{id}";

  // Booking flow
  static const String popularRoutes = "/customer/trips/popular-routes";
  static const String availableTrips = "/customer/trips/filter";
  static const String bookingCost = "/booking/summary";
  static const String bookPackage = "/booking";
  static const String scheduleTrip = "/booking";
  static const String verifyPayment = "/booking/verify-payment";
  static const String cancelTrip = "/booking/cancel";

  // Onboarding flow
  static const String verifyNin = "/kyc/driver/identity";
  static const String verifyLicense = "/kyc/driver/license";
  static const String verificationStatus = "/kyc/driver/status";
  static const String addVehicleDetails = "/vehicle/driver/details";
  static const String addVehicleCapacity = "/vehicle/driver/capacity";
  static const String addVehicleDocument = "/vehicle/driver/docs-and-photos";
  static const String fetchVehicleDetails = "/vehicle/driver/me";
  static const String fetchDriverPreference = "/driver/trip_setup/preferences";
  static const String setDriverPreference = "/driver/trip_setup/preferences";
  static const String fetchDriverPayout = "/driver/payout-method";
  static const String setDriverPayout = "/driver/payout-method";
}
