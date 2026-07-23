import 'dart:io' show Platform;

import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/storage/token_storage.dart';
import '../../app/app_setup_locator.dart';
import '../config/custom_dio_exception.dart';
import '../services/api_service.dart';

abstract class AuthRepo {
  Future<bool> login(String phone);

  Future<bool> register(String phone);
  Future<bool> verifyLogin(String phone, String code);
  Future<bool> verifyOtp(String code);
  Future<bool> resendOtp();

  Future<bool> logout();

  Future<bool> signInWithGoogle();
  Future<bool> updateFCMToken(String token);
  Future<bool> deleteFCMToken(String token);
}

class AuthRepoImpl implements AuthRepo {
  final ApiService _apiService;

  AuthRepoImpl({ApiService? service})
    : _apiService = service ?? sl<ApiService>();

  @override
  Future<bool> login(String phone) async {
    final res = await _apiService.login(phone);
    return res.code == 200;
  }

  @override
  Future<bool> register(String phone) async {
    final res = await _apiService.register(phone);
    if (res.data != null) await TokenStorage.saveAccessToken(res.data!.token);
    return res.code == 200;
  }

  @override
  Future<bool> verifyLogin(String phone, String code) async {
    final res = await _apiService.verifyLogin(phone, code);

    // 1. Check if the API returned a failure code
    if (res.code != 200 || res.data == null) {
      throw ExceptionInvalidCredentials();
    }

    // 2. Check the role restriction
    if (res.data?.profile.role != "CUSTOMER") {
      throw ExceptionNotACustomer();
    }

    // 3. Check the account verification
    if (res.data?.profile.phoneVerifiedAt == null) {
      throw ExceptionUnverifiedAccount();
    }

    // 4. Success path
    await TokenStorage.saveAccessToken(res.data!.token);
    return true;
  }

  @override
  Future<bool> verifyOtp(String code) async {
    final res = await _apiService.verifyOtp(code);
    return res.code == 200;
  }

  @override
  Future<bool> resendOtp() async {
    final res = await _apiService.resendOtp();
    return res.code == 200;
  }

  @override
  Future<bool> logout() async {
    final res = await TokenStorage.deleteAccessToken();
    return res;
  }

  @override
  Future<bool> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    try {
      // 1. Trigger the native email selection dialog
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      if (googleUser == null) {
        print("User cancelled the Google flow");
        return false;
      }

      // 2. Extract the idToken
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        // 3. Post to backend
        return await _sendTokenToBackend(token: idToken);
      } else {
        print("Error: Google ID Token was null");
      }
    } catch (error) {
      print("Google Sign-In Failure: $error");
    }
    return false;
  }

  @override
  Future<bool> updateFCMToken(String token) async {
    final isPlatformAndroid = Platform.isAndroid;
    final response = await _apiService.updateFCMToken(
      token: token,
      platform: isPlatformAndroid ? "ANDROID" : "IOS",
    );
    return (response.code == 200);
  }

  @override
  Future<bool> deleteFCMToken(String token) async {
    final response = await _apiService.deleteFCMToken(token: token);
    return (response.code == 200);
  }

  // --- APPLE SIGN-IN ---
  // Future<bool> signInWithApple() async {
  //   try {
  //     // 1. Trigger native Apple sheet
  //     final AuthorizationCredentialAppleID credential =
  //         await SignInWithApple.getAppleIDCredential(
  //           scopes: [
  //             AppleIDAuthorizationScope.email,
  //             AppleIDAuthorizationScope.fullName,
  //           ],
  //         );
  //
  //     final String? identityToken = credential.identityToken;
  //
  //     if (identityToken != null) {
  //       // 2. Post to backend
  //       await _sendTokenToBackend(
  //         token: identityToken,
  //       );
  //     } else {
  //       print("Error: Apple Identity Token was null");
  //     }
  //   } catch (error) {
  //     print("Apple Sign-In Failure: $error");
  //   }
  // }

  // --- COMMON BACKEND POST FUNCTION ---
  Future<bool> _sendTokenToBackend({required String token}) async {
    final response = await _apiService.googleSignIn(
      token: token,
      role: 'CUSTOMER',
    );

    return (response.code == 200 && response.data != null);
  }
}
