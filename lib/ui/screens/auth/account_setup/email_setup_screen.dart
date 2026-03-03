import 'package:flutter/material.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/inputs/auth_text_field.dart';
import '../../../widgets/texts/header_text.dart';
import 'enable_permission_screen.dart';

class EmailSetupScreen extends StatelessWidget {
  const EmailSetupScreen({super.key});

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
                    label: "whats your email?",
                    subText: "This is where we will send your receipts",
                  ),
                  AuthTextField(
                    controller: TextEditingController(),
                    label: "Email Address",
                    textInputType: TextInputType.emailAddress,
                    hint: "Enter Email Address",
                  ),
                ],
              ),

              ScButton(
                btnText: "Continue",
                onClick: () {
                  router.push(Paths.PERMISSIONSETUP);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
