import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/res/images.dart';
import '../../../../../app/res/svgs.dart';
import '../../../../../core/core.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/buttons/social_sign_in_button.dart';
import '../../../../widgets/inputs/country_phone_input_field.dart';
import '../../../../widgets/or_divider.dart';
import '../../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _phone;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            router.go(
              Paths.VERIFYPHONENUMBER,
              extra: VerifyOtpArgs(phone: _phone!, isLogin: false),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Image.asset(
                AppImages.onboardFour,
                width: double.maxFinite,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 53),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          CountryPhoneInputField(
                            onChanged: (phone) {
                              _phone = phone;
                            },
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffFCFFE9),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              "Your number will be used for trip updates and driver communication.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          Button(
                            isBusy: state is AuthLoading,
                            text: 'Continue',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  RegisterRequested(_phone!),
                                );
                              }
                            },
                          ),
                          // SocialSignInButton(
                          //   onTap: state is AuthLoading ? null : () {},
                          //   text: "Continue as Guest",
                          // ),
                          SizedBox(height: 24),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Already have an account? ",
                                ),
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      router.push(Paths.LOGIN);
                                    },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          // const SizedBox(height: 32),
                          // const OrDivider(),
                          // const SizedBox(height: 32),
                          // SocialSignInButton(
                          //   onTap: state is AuthLoading ? null : () {},
                          //   text: "Continue with Apple",
                          //   icon: AppSvgs.apple,
                          // ),
                          // SocialSignInButton(
                          //   onTap: state is AuthLoading ? null : () {},
                          //   text: "Continue with Google",
                          //   icon: AppSvgs.google,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
