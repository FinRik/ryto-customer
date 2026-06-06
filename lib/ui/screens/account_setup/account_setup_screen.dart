import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../app/app_setup_locator.dart';
import '../../../core/models/user/profile_request.dart';
import '../../../core/repos/regional_manager_repo.dart';
import '../../../core/setups/region_identity_setup.dart';
import '../../../utils/helpers/date_formatter_utils.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/inputs/auth_text_field.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/texts/header_text.dart';
import 'bloc/account_setup_bloc.dart';
import 'widgets/profile_image_picker.dart';
import 'widgets/region_notification.dart';
import 'widgets/states_city_form.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _region = sl<RegionIdentity>();
  bool _isRegionInitialized = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  File? _profileImage;

  void updateProfileImage(File image) => setState(() => _profileImage = image);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await _initRegion(),
    );
  }

  Future<void> _initRegion() async {
    try {
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 800)),
        context.read<RegionalManagerRepo>().initializeRegion(),
      ]);

      if (mounted) {
        setState(() {
          _isRegionInitialized = true;
          _nationalityController.text = _region.country;
        });
      }
    } catch (e) {
      debugPrint("Region initialization error: $e");
      if (mounted) {
        setState(() {
          _isRegionInitialized = true;
          _nationalityController.text = "Nigeria";
        });
      }
    }
  }

  // Show notification banner when region is detected
  Widget _buildRegionNotification() {
    if (!_isRegionInitialized) {
      return const SizedBox.shrink();
    }

    return RegionNotification(
      onPressed: _showRegionSelector,
      country: _region.country,
    );
  }

  Future<void> _showRegionSelector() async {
    final selectedCode = await context.read<RegionalManagerRepo>().setRegion();

    if (selectedCode != null && mounted) {
      final updatedRegion = sl<RegionIdentity>();

      setState(() {
        _nationalityController.text = updatedRegion.country;

        _stateController.clear();
        _cityController.clear();
        _addressController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Region updated to ${updatedRegion.country}"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountSetupBloc, AccountSetupState>(
      // Listen for the specific state that confirms data is saved
      listener: (context, state) {
        if (state is ScreenOneDataSaved) {
          router.push(Paths.EMAILSETUP);
        }
        if (state is AccountSetupFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BaseScaffoldWidget(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        child: Form(
          key: _formKey, // Wrap in Form for validation
          child: SingleChildScrollView(
            // Added scroll view for smaller screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackArrowButton(isChevron: false),
                HeaderText(
                  label: "Tell us about yourself",
                  subText: "This helps drivers identify you.",
                ),
                ProfileImagePicker(onImageSelected: updateProfileImage),
                const SizedBox(height: 24),
                _buildRegionNotification(),
                const SizedBox(height: 24),

                AuthTextField(
                  controller: _firstNameController,
                  label: "First name",
                  hint: "Enter your first name",
                  textInputType: TextInputType.text,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                AuthTextField(
                  controller: _lastNameController,
                  label: "Last name",
                  textInputType: TextInputType.text,
                  hint: "Enter your last name",
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                AuthTextField(
                  controller: _dobController,
                  label: "Date of Birth",
                  hint: "Select a Date",
                  readOnly: true,
                  textInputType: TextInputType.datetime,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? "Date of birth is required"
                      : null,
                ),

                AuthTextField(
                  controller: _nationalityController,
                  textInputType: TextInputType.text,
                  label: "Country",
                  hint: "Your Country",
                  readOnly: true,
                  suffixIcon: IconButton(
                    onPressed: _showRegionSelector,
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? "Country is required"
                      : null,
                ),
                // State & City Form (Now receives controllers)
                if (_nationalityController.text.isNotEmpty)
                  AnimatedOpacity(
                    opacity: _nationalityController.text.isNotEmpty ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        StateCityForm(
                          stateController: _stateController,
                          cityController: _cityController,
                          region: _nationalityController
                              .text, // Pass current country
                        ),
                        const SizedBox(height: 8),

                        // Home Address
                        AuthTextField(
                          controller: _addressController,
                          textInputType: TextInputType.streetAddress,
                          label: "Home Address",
                          hint: "Enter Street Address",
                          validator: (value) => (value?.trim().isEmpty ?? true)
                              ? "Address is required"
                              : null,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),

                Button(text: "Continue", onTap: _onContinuePressed),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onContinuePressed() {
    // 1. Check for Profile Image First
    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload a profile picture to proceed."),
          backgroundColor: Color(0xFFC62828), // Formal dark red
          behavior: SnackBarBehavior.floating,
        ),
      );
      return; // Stop execution
    }

    // 2. Trigger Form Validation
    if (_formKey.currentState!.validate()) {
      final dob = DateFormatterUtils.parseBackendFormat(
        _dobController.text.trim(),
      );

      if (dob == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid date of birth format")),
        );
        return;
      }

      final partialData = ProfileRequest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: dob,
        homeAddress: _addressController.text.trim(),
        country: _nationalityController.text,
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        profilePicture: _profileImage?.path,
      );

      context.read<AccountSetupBloc>().add(SaveDetailsScreenOne(partialData));
    } else {
      // Optional: General nudge if the form has errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please correct the errors in the form."),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
