import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ryto_customer/app/api_urls.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/res/images.dart';
import '../../../../core/enums/bottom_sheet_type.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/bottom_sheet_service.dart';
import '../../../../utils/helpers/socials_helper.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../styles/app_spacing.dart';
import '../../../widgets/app_bars/custom_app_bar.dart';
import '../../../widgets/dp_image_widget.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import '../../auth/bloc/auth_bloc.dart';
import 'widgets/setting_item.dart';
import 'widgets/settings_section.dart';

enum TrailingType { chevron, external, destructive }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      removePadding: true,
      appBar: CustomAppBar(removeHorizPadding: true),
      child: Column(
        children: [
          BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state.status == ProfileStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? "An error occurred"),
                  ),
                );
              }
            },
            builder: (context, state) {
              final user = state.user;
              final isLoading = state.status == ProfileStatus.loading;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffE3FB20),
                  image: DecorationImage(
                    image: AssetImage(AppImages.profilePattern),
                    opacity: 0.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DpImageWidget(imageUrl: user!.imageUrl),
                    const SizedBox(height: 12),
                    isLoading && user == null
                        ? const CircularIndicator()
                        : Text(
                            user.firstName ?? "Guest",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, size: 16),
                        const SizedBox(width: 4),
                        Text("${user.rating} (${user.reviewCount}+)"),
                      ],
                    ),
                  ],
                ),
              );
            },
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
                      onTap: () => router.push(Paths.EDITUSERACCOUNT),
                    ),
                    // SettingItem(
                    //   icon: AppIcons.notificationStatus,
                    //   title: "Notifications",
                    //   onTap: () => router.push(Paths.SUPPORT),
                    // ),
                    SettingItem(
                      icon: AppIcons.securityUser,
                      title: "Security",
                      onTap: () => router.push(Paths.APPSETTINGS),
                    ),
                  ],
                ),

                // const SizedBox(height: AppSpacing.sectionSpacing),
                // SettingsSection(
                //   title: "Location",
                //   children: [
                //     SettingItem(
                //       icon: AppIcons.send,
                //       title: "Saved Addresses",
                //       onTap: () {},
                //     ),
                //     SettingItem(
                //       icon: AppIcons.mapOutlined,
                //       title: "Default Pickup Location",
                //       onTap: () {},
                //     ),
                //   ],
                // ),
                const SizedBox(height: AppSpacing.sectionSpacing),
                SettingsSection(
                  title: "Help & Support",
                  children: [
                    SettingItem(
                      title: "Help Center / FAQ",
                      onTap: () => router.push(Paths.SUPPORT),
                    ),
                    SettingItem(
                      title: "Contact Support",
                      onTap: () => sl<BottomSheetService>()
                          .showCustomBottomSheet(
                            variant: BottomSheetType.contactSupport,
                          ),
                    ),
                    SettingItem(
                      title: "Privacy Policy",
                      onTap: () => router.push(
                        Paths.WEBVIEW,
                        extra: WebviewArgs(
                          url: ApiUrls.privacy,
                          title: "Privacy Policy",
                        ),
                      ),
                    ),
                    SettingItem(
                      title: "Terms & Conditions",
                      onTap: () => router.push(
                        Paths.WEBVIEW,
                        extra: WebviewArgs(
                          url: ApiUrls.terms,
                          title: "Terms & Conditions",
                        ),
                      ),
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
                      onTap: SocialHelper.openWebsite,
                      // onTap: () => router.push(
                      //   Paths.WEBVIEW,
                      //   extra: WebviewArgs(url: ApiUrls.website, title: ""),
                      // ),
                    ),
                    SettingItem(
                      icon: AppIcons.twitter,
                      title: "X (Twitter)",
                      trailingType: TrailingType.external,
                      onTap: SocialHelper.openTwitter,
                    ),
                    SettingItem(
                      icon: AppIcons.instagram,
                      title: "Instagram",
                      trailingType: TrailingType.external,
                      onTap: SocialHelper.openInstagram,
                    ),
                  ],
                ),

                // SizedBox(height: AppSpacing.sectionSpacing),
                // SettingItem(
                //   title: "Delete Ryto Account",
                //   trailingType: TrailingType.external,
                //   onTap: () {},
                // ),

                const SizedBox(height: 10),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthInitial) {
                      router.go(Paths.LOGIN);
                    }
                  },
                  builder: (context, state) {
                    return SettingItem(
                      title: "Log out",
                      trailingType: TrailingType.destructive,
                      isDestructive: true,
                      onTap: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
