part of 'account_setup_bloc.dart';

abstract class AccountSetupEvent extends Equatable {
  const AccountSetupEvent();

  @override
  List<Object?> get props => [];
}

// Add this to your events
class SaveDetailsScreenOne extends AccountSetupEvent {
  final ProfileRequest partialRequest;
  const SaveDetailsScreenOne(this.partialRequest);

  @override
  List<Object?> get props => [partialRequest];
}

// Update this to represent the final "Create" action
class FinalizeAccountCreation extends AccountSetupEvent {
  final String email;
  const FinalizeAccountCreation(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdateProfileRequested extends AccountSetupEvent {
  final ProfileRequest request;

  const UpdateProfileRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// class UserProfileRequested extends AccountSetupEvent {
//
//   const UserProfileRequested();
//
//   @override
//   List<Object?> get props => [];
// }