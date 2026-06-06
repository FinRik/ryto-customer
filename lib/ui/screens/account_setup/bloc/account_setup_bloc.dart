import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/user/profile_request.dart';
import '../../../../core/models/user/user_entity.dart';
import '../../../../core/repos/user_repo.dart';

part 'account_setup_event.dart';
part 'account_setup_state.dart';

class AccountSetupBloc extends Bloc<AccountSetupEvent, AccountSetupState> {
  final UserRepo repo;

  // Local variable to hold the merged data
  ProfileRequest? _cachedRequest;

  AccountSetupBloc(this.repo) : super(AccountSetupInitial()) {
    // Step 1: Capture data from Screen 1
    on<SaveDetailsScreenOne>((event, emit) {
      _cachedRequest = event.partialRequest;
      emit(ScreenOneDataSaved(event.partialRequest));
    });

    // Step 2: Merge with Screen 2 and Call Repository
    on<FinalizeAccountCreation>((event, emit) async {
      if (_cachedRequest == null) {
        emit(const AccountSetupFailure("Missing details from first screen"));
        return;
      }

      emit(AccountSetupLoading());

      try {
        // Merge the email into your request object
        final finalRequest = _cachedRequest!.copyWith(email: event.email);

        final result = await repo.updateProfile(finalRequest);

        if (result != null) {
          emit(AccountSetupSuccess(user: result));
        } else {
          emit(const AccountSetupFailure("Account creation failed"));
        }
      } catch (e) {
        emit(AccountSetupFailure(e.toString()));
      }
    });
  }
}
