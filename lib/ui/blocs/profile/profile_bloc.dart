import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../core/models/user/profile_request.dart';
import '../../../core/models/user/user_entity.dart';
import '../../../core/repos/user_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  final UserRepo repo;

  ProfileBloc(this.repo) : super(const ProfileState()) {
    on<FetchUserProfile>(_onFetchProfile);
    on<UpdateProfileRequested>(_onUpdateProfile);
  }

  Future<void> _onFetchProfile(
    FetchUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final res = await repo.fetchProfile();
      if (res != null) {
        emit(
          state.copyWith(
            status: ProfileStatus.success,
            user: res,
            message: "Profile Loaded",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            message: "Failed to fetch",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      print("Profile Update Request: ${event.request.toJson()}");
      final result = await repo.updateProfile(event.request);
      if (result != null) {
        emit(
          state.copyWith(
            status: ProfileStatus.success,
            user: result,
            message: "Profile Updated",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            message: "Update failed",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.failure, message: e.toString()),
      );
    }
  }

  // Future<void> _onUpdateProfile(
  //   UpdateProfileRequested event,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   emit(state.copyWith(status: ProfileStatus.loading));
  //   try {
  //     final success = await repo.updateProfile(event.request);
  //     if (success) {
  //       // We don't have the new User object here, so we keep the old one
  //       // and just update the status/message.
  //       emit(
  //         state.copyWith(
  //           status: ProfileStatus.success,
  //           message: "Profile Updated",
  //         ),
  //       );
  //     } else {
  //       emit(
  //         state.copyWith(
  //           status: ProfileStatus.failure,
  //           message: "Update failed",
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     emit(
  //       state.copyWith(status: ProfileStatus.failure, message: e.toString()),
  //     );
  //   }
  // }

  // --- PERSISTENCE LAYER ---

  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    return ProfileState(
      status: ProfileStatus.values[json['status'] as int? ?? 0],
      user: json['user'] != null ? UserEntity.fromJson(json['user']) : null,
    );
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    return {'status': state.status.index, 'user': state.user?.toJson()};
  }
}
