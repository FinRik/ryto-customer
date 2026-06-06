import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/inputs/auth_text_field.dart';
import '../../widgets/texts/header_text.dart';
import 'bloc/account_setup_bloc.dart';

class EmailSetupScreen extends StatefulWidget {
  const EmailSetupScreen({super.key});

  @override
  State<EmailSetupScreen> createState() => _EmailSetupScreenState();
}

class _EmailSetupScreenState extends State<EmailSetupScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Added FormKey for validation

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onFinalizePressed() {
    // 1. Validate the email field
    if (_formKey.currentState!.validate()) {
      // 2. Dispatch the final event to merge data and hit the API
      context.read<AccountSetupBloc>().add(
        FinalizeAccountCreation(_emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountSetupBloc, AccountSetupState>(
      listener: (context, state) {
        if (state is AccountSetupSuccess) {
          router.push(Paths.PERMISSIONSETUP);
        } else if (state is AccountSetupFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 14,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BackArrowButton(isChevron: false),
                        HeaderText(
                          label: "What's your email?",
                          subText: "This is where we will send your receipts",
                        ),
                        AuthTextField(
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          label: "Email Address",
                          hint: "jondoe@email.com",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email address is required";
                            }
                            final emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    Button(
                      text: "Continue",
                      onTap: _onFinalizePressed,
                      isBusy: state is AccountSetupLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
