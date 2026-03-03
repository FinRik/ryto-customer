import 'package:flutter/material.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/inputs/auth_text_field.dart';
import '../../../widgets/texts/header_text.dart';
import 'email_setup_screen.dart';
import 'widgets/profile_image_picker.dart';

class AccountSetupScreen extends StatelessWidget {
  const AccountSetupScreen({super.key});

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
                    label: "Tell us about yourself",
                    subText: "This helps drivers identify you.",
                  ),
                  ProfileImagePicker(),
                  SizedBox(height: 48),
                  AuthTextField(
                    controller: TextEditingController(),
                    label: "First name",
                    textInputType: TextInputType.text,
                    hint: "Enter your first name",
                  ),
                  AuthTextField(
                    controller: TextEditingController(),
                    label: "Last name",
                    textInputType: TextInputType.text,
                    hint: "Enter your last name",
                  ),
                ],
              ),

              ScButton(
                btnText: "Continue",
                onClick: () {
                  router.push(Paths.EMAILSETUP);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
