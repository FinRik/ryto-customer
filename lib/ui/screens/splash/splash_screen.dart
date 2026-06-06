import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/res/logos.dart';
import '../../../core/repos/regional_manager_repo.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../../utils/helpers/jwt_utils.dart';
import '../../../utils/storage/app_launch_state.dart';
import '../../../utils/storage/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Use Future.wait to run branding timer and logic in parallel
    await Future.wait([context.read<RegionalManagerRepo>().initializeRegion()]);
    // Once initialized, proceed with Auth logic
    final token = await TokenStorage.getAccessToken();
    if (!(await AppLaunchState.isFirstLaunch())) {
      print('Not my first rodeo');
      if (JwtUtils.isValid(token)) {
        router.push(Paths.HOME);
      } else {
        router.push(Paths.LOGIN);
      }
    } else {
      print('My first rodeo');
      router.go(Paths.ONBOARDING);
    }
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
