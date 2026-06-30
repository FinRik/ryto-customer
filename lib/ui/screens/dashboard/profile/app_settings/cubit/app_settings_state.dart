part of 'app_settings_cubit.dart';

class AppSettingsState {
  final bool pushNotificationsEnabled;
  final bool soundEnabled;
  final bool emailAlertsEnabled;
  final bool highQualityMapsEnabled;

  const AppSettingsState({
    this.pushNotificationsEnabled = true,
    this.soundEnabled = true,
    this.emailAlertsEnabled = false,
    this.highQualityMapsEnabled = false,
  });

  AppSettingsState copyWith({
    bool? pushNotificationsEnabled,
    bool? soundEnabled,
    bool? emailAlertsEnabled,
    bool? highQualityMapsEnabled,
  }) {
    return AppSettingsState(
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      emailAlertsEnabled: emailAlertsEnabled ?? this.emailAlertsEnabled,
      highQualityMapsEnabled: highQualityMapsEnabled ?? this.highQualityMapsEnabled,
    );
  }

  // Convert state to JSON Map for storage
  Map<String, dynamic> toMap() {
    return {
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'soundEnabled': soundEnabled,
      'emailAlertsEnabled': emailAlertsEnabled,
      'highQualityMapsEnabled': highQualityMapsEnabled,
    };
  }

  // Restore state from JSON Map
  factory AppSettingsState.fromMap(Map<String, dynamic> map) {
    return AppSettingsState(
      pushNotificationsEnabled: map['pushNotificationsEnabled'] ?? true,
      soundEnabled: map['soundEnabled'] ?? true,
      emailAlertsEnabled: map['emailAlertsEnabled'] ?? false,
      highQualityMapsEnabled: map['highQualityMapsEnabled'] ?? false,
    );
  }
}