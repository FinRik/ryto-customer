import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ryto_customer/app/res/logos.dart';

import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      router.push(Paths.ONBOARDING);
      // router.push(Paths.HOME);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary.withOpacity(.8),
      body: SafeArea(
        child: Center(child: SvgPicture.asset(AppLogos.appLogoWhiteYellow)),
      ),
    );
  }
}
