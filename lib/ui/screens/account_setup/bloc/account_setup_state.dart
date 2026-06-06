part of 'account_setup_bloc.dart';

abstract class AccountSetupState extends Equatable {
  const AccountSetupState();

  @override
  List<Object?> get props => [];
}

class AccountSetupInitial extends AccountSetupState {}

class AccountSetupLoading extends AccountSetupState {}

class AccountSetupSuccess extends AccountSetupState {
  final UserEntity user;
  const AccountSetupSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

// This signals Screen 1 to navigate to Screen 2
class ScreenOneDataSaved extends AccountSetupState {
  final ProfileRequest partialRequest;
  const ScreenOneDataSaved(this.partialRequest);

  @override
  List<Object?> get props => [partialRequest];
}

class AccountSetupFailure extends AccountSetupState {
  final String message;

  const AccountSetupFailure(this.message);

  @override
  List<Object?> get props => [message];
}
