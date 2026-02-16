import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../widgets/buttons/arrow_back.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/inputs/otp_input_field.dart';
import '../../../widgets/texts/header_text.dart';
import '../account_setup/account_setup_screen.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  static const int _initialSeconds = 60;
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _initialSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    setState(() {
      _secondsRemaining = _initialSeconds;
    });
    _startCountdown();

    // TODO: Call your resend OTP API here
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    // return "$minutes:$seconds";
    return seconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const HeaderText(
                    label: "Verify Your Phone number",
                    subText: "A code was sent to +234 80**********",
                  ),
                  OtpInputField(fieldLength: 4, onChanged: (pin, isValid) {}),
                  const SizedBox(height: 16),

                  _secondsRemaining > 0
                      ? Text.rich(
                          TextSpan(
                            text: "Resend code ",
                            children: [
                              TextSpan(
                                text: "${_formattedTime}s",
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                          style: const TextStyle(
                            color: Color(0xff696E7E),
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : GestureDetector(
                          onTap: _resendCode,
                          child: const Text(
                            "Resend Code",
                            style: TextStyle(
                              color: Color(0xff696E7E),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                ],
              ),

              ScButton(
                btnText: "Continue",
                onClick: () {
                  router.push(Paths.ACCOUNTSETUP);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
