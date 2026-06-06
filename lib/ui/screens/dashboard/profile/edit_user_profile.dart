import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/user/profile_request.dart';
import '../../../../core/models/user/user_entity.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/dp_image_widget.dart';
import '../../../widgets/inputs/auth_text_field.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _imageUrl;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    if (state.user != null) {
      _fillControllers(state.user!);
    }
  }

  void _fillControllers(UserEntity user) {
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _phoneController.text = user.phone ?? '';
    _emailController.text = user.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message ?? "Success")));
          setState(() => _isEditing = false); // Lock fields after update
        }
        if (state.status == ProfileStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message ?? "Error")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: const BackArrowButton(),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.close : Icons.edit,
                  color: Colors.black,
                ),
                onPressed: () => setState(() => _isEditing = !_isEditing),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      DpImageWidget(
                        imageUrl: state.user?.imageUrl,
                        showEditIcon: _isEditing,
                        onChanged: (file) {
                          setState(() => _imageUrl = file.path);
                        },
                      ),
                      const SizedBox(height: 32),
                      AuthTextField(
                        controller: _firstNameController,
                        label: "First name",
                        readOnly: !_isEditing, // Disable when not editing
                        textInputType: TextInputType.name,
                        bottomMargin: 0,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        controller: _lastNameController,
                        label: "Last name",
                        readOnly: !_isEditing,
                        textInputType: TextInputType.name,
                        bottomMargin: 0,
                      ),
                      const SizedBox(height: 20),
                      // CountryPhoneInputField(
                      //   initialValue: _phoneController.text,
                      //   enabled: false,
                      //   onChanged: (phone) {},
                      // ),
                      // const SizedBox(height: 20),
                      AuthTextField(
                        controller: _emailController,
                        label: "Email Address",
                        readOnly: !_isEditing,
                        textInputType: TextInputType.emailAddress,
                        bottomMargin: 0,
                      ),
                    ],
                  ),
                ),
              ),

              // Only show Update button if in editing mode
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Button(
                    onTap: () {
                      if (_imageUrl == null) {
                        context.read<ProfileBloc>().add(
                          UpdateProfileRequested(
                            ProfileRequest(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                            ),
                          ),
                        );
                      } else {
                        context.read<ProfileBloc>().add(
                          UpdateProfileRequested(
                            ProfileRequest(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              profilePicture: _imageUrl,
                            ),
                          ),
                        );
                      }
                    },
                    isBusy: state.status == ProfileStatus.loading,
                    text: "Update Profile",
                    showSuffixIcon: state.status != ProfileStatus.loading,
                    suffixIcon: Icons.chevron_right,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
