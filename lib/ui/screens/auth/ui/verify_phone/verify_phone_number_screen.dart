import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../widgets/buttons/back_arrow_button.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/inputs/otp_input_field.dart';
import '../../../../widgets/texts/header_text.dart';
import '../../bloc/auth_bloc.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key, required this.args});

  final VerifyOtpArgs args;

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  static const int _initialSeconds = 60;
  late int _secondsRemaining;
  Timer? _timer;

  // Local state for the OTP value
  String _otpCode = "";
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _initialSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = _initialSeconds);
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

  void _resendCode(BuildContext context) {
    // Trigger the Bloc event for resending OTP
    context.read<AuthBloc>().add(ResendOtpRequested());
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return seconds;
  }

  Future<void> _showError(
    BuildContext context, {
    required String message,
    String title = 'Error',
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (widget.args.isLogin) {
              router.push(Paths.HOME);
            } else {
              router.push(Paths.ACCOUNTSETUP);
            }
          } else if (state is AuthFailure) {
            _showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BackArrowButton(isChevron: false),
                      HeaderText(
                        label: "Verify Your Phone number",
                        subText: "A code was sent to ${widget.args.phone}",
                      ),

                      // Requirement 3: Capture and validate the OTP
                      OtpInputField(
                        fieldLength: 4,
                        onChanged: (pin, isValid) {
                          setState(() {
                            _otpCode = pin;
                            _isOtpValid = isValid;
                          });
                        },
                      ),
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
                              onTap: isLoading
                                  ? null
                                  : () => _resendCode(context),
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

                  Button(
                    text: "Continue",
                    isBusy: isLoading,
                    onTap: (_isOtpValid && !isLoading)
                        ? () {
                            if (widget.args.isLogin) {
                              context.read<AuthBloc>().add(
                                VerifyLoginRequested(
                                  phone: widget.args.phone,
                                  code: _otpCode,
                                ),
                              );
                            } else {
                              context.read<AuthBloc>().add(
                                VerifyOtpRequested(_otpCode),
                              );
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
