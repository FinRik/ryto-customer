import 'package:flutter/material.dart';

import '../../../app/res/images.dart';
import 'parts/onboarding_page.dart';
import 'widgets/dot_indication.dart';

/// ----------------------
/// MODEL
/// ----------------------
class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}

/// ----------------------
/// SCREEN
/// ----------------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> pages = [
    OnboardingData(
      image: AppImages.onboardOne,
      title: "Trips already in motion",
      description:
          "Ryto connects you with verified drivers already traveling between cities, turning existing booking_history into reliable travel and delivery options.",
    ),
    OnboardingData(
      image: AppImages.onboardTwo,
      title: "Plan it. Trust it. Move.",
      description:
          "Schedule intercity booking_history in advance, know your route and driver, and travel with confidence every time.",
    ),
    OnboardingData(
      image: AppImages.onboardThree,
      title: "People and package, together",
      description:
          "Travel between cities or send small package using the same trusted peer-to-peer routes, all in one app.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B5ED7),
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: pages.length,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          itemBuilder: (_, index) {
            return OnboardingPage(
              data: pages[index],
              currentIndex: _currentIndex,
              pageLength: pages.length,
            );
          },
        ),
      ),
    );
  }
}
