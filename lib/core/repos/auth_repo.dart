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
}
