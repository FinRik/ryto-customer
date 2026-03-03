import 'package:flutter/material.dart';

import '../../../../app/res/svgs.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/customs/custom_tile_widget.dart';
import '../../../widgets/inputs/auth_text_field.dart';
import '../../../widgets/texts/header_text.dart';

class EnablePermissionScreen extends StatefulWidget {
  const EnablePermissionScreen({super.key});

  @override
  State<EnablePermissionScreen> createState() => _EnablePermissionScreenState();
}

class _EnablePermissionScreenState extends State<EnablePermissionScreen> {

  bool locationEnabled = true;
  bool notificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackArrowButton(isChevron: false),
                  HeaderText(
                    label: "Enable permissions",
                    subText: "These help us provide a better experience.",
                  ),
                  CustomTileWidget(
                    svgIcon: AppSvgs.location,
                    title: "Location",
                    subtitle: "To show nearby pickup points and routes",
                    trailing: Transform.scale(
                      scale: .8,
                      child: Switch(
                        value: locationEnabled,
                        onChanged: (value) {
                          setState(() {
                            locationEnabled = value;
                          });
                        },
                      ),
                    ),
                    showArrow: false,
                  ),

                  CustomTileWidget(
                    svgIcon: AppSvgs.notification,
                    title: "Notifications",
                    subtitle:
                    "Trip updates, driver arrival, seat confirmation",
                    trailing: Transform.scale(
                      scale: .8,
                      child: Switch(
                        value: notificationEnabled,
                        onChanged: (value) {
                          setState(() {
                            notificationEnabled = value;
                          });
                        },
                      ),
                    ),
                    showArrow: false,
                  ),
                ],
              ),

              ScButton(
                btnText: "Continue",
                onClick: (){
                  router.push(Paths.HOME);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
