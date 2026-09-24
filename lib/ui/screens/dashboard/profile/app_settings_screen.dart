import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import 'app_settings/cubit/app_settings_cubit.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppSettingsCubit(),
      child: BaseScaffoldWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackArrowHeader(title: 'App Settings'),
              const SizedBox(height: 43),

              // 2. Wrap the dynamic parts with BlocBuilder
              BlocBuilder<AppSettingsCubit, AppSettingsState>(
                builder: (context, state) {
                  final cubit = context.read<AppSettingsCubit>();

                  return Column(
                    children: [
                      SettingsSection(
                        title: "Notifications",
                        children: [
                          SettingsTile(
                            title: "Push Notifications",
                            subtitle: "Alerts for trips and updates",
                            trailing: Switch(
                              value: state.pushNotificationsEnabled,
                              onChanged: cubit.togglePushNotifications,
                              activeColor: Colors.blue,
                            ),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          SettingsTile(
                            title: "Sound",
                            subtitle: "Enable sound for new requests",
                            trailing: Switch(
                              value: state.soundEnabled,
                              onChanged: cubit.toggleSound,
                              activeColor: Colors.blue,
                            ),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          SettingsTile(
                            title: "Email Alerts",
                            subtitle: "Monthly reports and security updates",
                            trailing: Switch(
                              value: state.emailAlertsEnabled,
                              onChanged: cubit.toggleEmailAlerts,
                            ),
                          ),
                        ],
                      ),

                      SettingsSection(
                        title: "Data Usage",
                        children: [
                          SettingsTile(
                            title: "High-Quality Maps",
                            subtitle: "Uses more data for detailed textures",
                            trailing: Switch(
                              value: state.highQualityMapsEnabled,
                              onChanged: cubit.toggleHighQualityMaps,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Version 1.0.0 (Build 12)",
                  style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
