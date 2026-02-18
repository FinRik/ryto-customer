import 'package:flutter/material.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/res/images.dart';
import '../../../styles/app_spacing.dart';
import '../../../widgets/custom_app_bar.dart';
import 'widgets/setting_item.dart';
import 'widgets/settings_section.dart';

enum TrailingType { chevron, external, destructive }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(removeHorizPadding: true),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xffE3FB20),
                image: DecorationImage(
                  image: AssetImage(AppImages.profilePattern),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 30),
                  SizedBox(height: 12),
                  Text("Jaiyeoluwa"),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star),
                      SizedBox(width: 4),
                      Text("5.0 (100+)"),
                    ],
                  ),
                ],
              ),
            ),

            ///body
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  SettingsSection(
                    title: "Account",
                    children: [
                      SettingItem(
                        icon: AppIcons.editOutlined,
                        title: "Edit Profile",
                        onTap: () {},
                      ),
                      SettingItem(
                        icon: AppIcons.notificationStatus,
                        title: "Notifications",
                        onTap: () {},
                      ),
                      SettingItem(
                        icon: AppIcons.securityUser,
                        title: "Security",
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  SettingsSection(
                    title: "Location",
                    children: [
                      SettingItem(
                        icon: AppIcons.send,
                        title: "Saved Addresses",
                        onTap: () {},
                      ),
                      SettingItem(
                        icon: AppIcons.mapOutlined,
                        title: "Default Pickup Location",
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  SettingsSection(
                    title: "Help & Support",
                    children: [
                      SettingItem(
                        title: "Help Center / FAQ",
                        onTap: () {},
                      ),
                      SettingItem(
                        title: "Privacy Policy",
                        onTap: () {},
                      ),
                      SettingItem(
                        title: "Terms & Conditions",
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  SettingsSection(
                    title: "About",
                    children: [
                      SettingItem(
                        icon: AppIcons.global,
                        title: "Website",
                        trailingType: TrailingType.external,
                        onTap: () {},
                      ),
                      SettingItem(
                        icon: AppIcons.twitter,
                        title: "X (Twitter)",
                        trailingType: TrailingType.external,
                        onTap: () {},
                      ),
                      SettingItem(
                        icon: AppIcons.instagram,
                        title: "Instagram",
                        trailingType: TrailingType.external,
                        onTap: () {},
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.sectionSpacing),

                  SettingItem(
                    title: "Delete WakaMi account",
                    trailingType: TrailingType.external,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  SettingItem(
                    title: "Log out",
                    trailingType: TrailingType.destructive,
                    isDestructive: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
