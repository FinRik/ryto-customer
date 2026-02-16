import 'package:flutter/material.dart';

import '../../../../app/res/images.dart';
import '../../../../app/res/svgs.dart';
import '../../../../core/core.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/buttons/social_sign_in_button.dart';
import '../../../widgets/inputs/country_selector.dart';
import '../../../widgets/or_divider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNUmberCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // backgroundColor: colorScheme.primary.withOpacity(.8),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Image.asset(
            AppImages.onboardFour,
            // height: 300,
            width: double.maxFinite,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 53),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CountrySelector(
                        onCountrySelect: (code) {
                          print("Selected Country Code: ${code.countryCode}");
                          print("Selected Country Flag: ${code.flagEmoji}");
                        },
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneNUmberCtrl,
                          keyboardType: TextInputType.phone,
                          obscureText: false,
                          validator: (val) {
                            if (val?.isEmpty ?? true) {
                              return "This field cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (val) {},
                          inputFormatters: [],
                          decoration: InputDecoration(
                            filled: false,
                            // fillColor: const Color(0xFF3E3E3E),
                            hintText: "000 000 000",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xffE5E5E6),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xffE5E5E6),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xffE5E5E6),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffFCFFE9),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Your number is used for trip updates and driver communication.",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                  ScButton(
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        router.push(
                          Paths.VERIFYPHONENUMBER,
                          extra: _phoneNUmberCtrl.text.trim(),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 32),
                  OrDivider(),
                  SizedBox(height: 32),
                  SocialSignInButton(
                    onTap: (){},
                    text: "Continue with Apple",
                    icon: AppSvgs.apple,
                  ),
                  // SizedBox(height: 8),
                  SocialSignInButton(
                    onTap: (){},
                    text: "Continue with Google",
                    icon: AppSvgs.google,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
