import 'package:flutter/material.dart';

import '../../../../app/res/images.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // backgroundColor: colorScheme.primary.withOpacity(.8),
      body: Column(
        children: [
          Image.asset(
            AppImages.onboardFour,
            // height: 300,
            width: double.maxFinite,
            fit: BoxFit.contain,
          ),

          Container(),
        ],
      ),
    );
  }
}
