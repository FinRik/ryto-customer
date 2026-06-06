import 'dart:io';

import '../../app/app_setup_locator.dart';
import '../models/user/profile_request.dart';
import '../models/user/user_entity.dart';
import '../services/api_service.dart';

abstract class UserRepo {
  Future<UserEntity?> fetchProfile();
  Future<UserEntity?> updateProfile(ProfileRequest request);
}

class UserRepoImpl implements UserRepo {
  final ApiService _apiService;

  UserRepoImpl({ApiService? service})
    : _apiService = service ?? sl<ApiService>();

  @override
  Future<UserEntity?> fetchProfile() async {
    final result = await _apiService.fetchProfile();
    return result.data;
  }

  @override
  Future<UserEntity?> updateProfile(ProfileRequest request) async {
    final res = await _apiService.updateProfile(
      lastName: request.lastName!,
      firstName: request.firstName!,
      email: request.email!,
      image: File(request.profilePicture!),
    );
    return res.data;
  }
}
