import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_settings_state.dart';

class AppSettingsCubit extends HydratedCubit<AppSettingsState> {
  AppSettingsCubit() : super(const AppSettingsState());

  void togglePushNotifications(bool value) =>
      emit(state.copyWith(pushNotificationsEnabled: value));
  void toggleSound(bool value) => emit(state.copyWith(soundEnabled: value));
  void toggleEmailAlerts(bool value) =>
      emit(state.copyWith(emailAlertsEnabled: value));
  void toggleHighQualityMaps(bool value) =>
      emit(state.copyWith(highQualityMapsEnabled: value));

  @override
  AppSettingsState? fromJson(Map<String, dynamic> json) {
    return AppSettingsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AppSettingsState state) {
    return state.toMap();
  }
}
