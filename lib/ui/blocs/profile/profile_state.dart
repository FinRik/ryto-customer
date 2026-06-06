part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? user;
  final String? message;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.message,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    String? message,
    String? imagePath,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}