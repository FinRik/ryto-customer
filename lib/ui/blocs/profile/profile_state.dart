part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }
enum TokenStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final TokenStatus tokenStatus;
  final UserEntity? user;
  final String? message;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.tokenStatus = TokenStatus.initial,
    this.user,
    this.message,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    TokenStatus? tokenStatus,
    UserEntity? user,
    String? message,
    String? imagePath,
  }) {
    return ProfileState(
      status: status ?? this.status,
      tokenStatus: tokenStatus ?? this.tokenStatus,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, tokenStatus, user, message];
}