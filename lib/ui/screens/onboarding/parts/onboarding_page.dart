import 'package:flutter/material.dart';

import '../../../widgets/buttons/sc_button.dart';
import '../../auth/register/register_screen.dart';
import '../onboarding_screen.dart';
import '../widgets/dot_indication.dart';

/// ----------------------
/// REUSABLE PAGE WIDGET
/// ----------------------
class OnboardingPage extends StatefulWidget {
  final OnboardingData data;
  final int currentIndex, pageLength;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.currentIndex,
    required this.pageLength,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 39),
              Image.asset(
                widget.data.image,
                width: double.maxFinite,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 71),
            ],
          ),
          Column(
            children: [
              DotIndicator(
                currentIndex: widget.currentIndex,
                total: widget.pageLength,
              ),
              const SizedBox(height: 21),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.data.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 34),
                    ScButton(
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
