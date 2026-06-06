import 'package:flutter/material.dart';

import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackArrowHeader(title: 'App Settings'),
            SizedBox(height: 43),
            SettingsSection(
              title: "Notifications",
              children: [
                SettingsTile(
                  title: "Push Notifications",
                  subtitle: "Alerts for trips and updates",
                  trailing: Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: Colors.blue,
                  ),
                  icon: null,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SettingsTile(
                  title: "Sound",
                  subtitle: "Enable sound for new requests",
                  trailing: Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: Colors.blue,
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SettingsTile(
                  title: "Email Alerts",
                  subtitle: "Monthly reports and security updates",
                  trailing: Switch(value: false, onChanged: (v) {}),
                ),
              ],
            ),

            SettingsSection(
              title: "Language",
              children: [
                SettingsTile(
                  title: "Language",
                  subtitle: "Current: English (US)",
                  onTap: () {},
                ),
              ],
            ),

            SettingsSection(
              title: "Data Usage",
              children: [
                SettingsTile(
                  title: "High-Quality Maps",
                  subtitle: "Uses more data for detailed textures",
                  trailing: Switch(value: false, onChanged: (v) {}),
                ),
              ],
            ),

            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: const Text(
                "Version 2.4.12 (Build 883)",
                style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
