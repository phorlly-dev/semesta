import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:semesta/app/utils/custom_toast.dart';
import 'package:semesta/app/utils/file_helper.dart';
import 'package:semesta/app/utils/format.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/ui/widgets/custom_button.dart';
import 'package:semesta/ui/widgets/date_time_input.dart';
import 'package:semesta/ui/widgets/image_picker.dart';
import 'package:semesta/ui/widgets/loader.dart';
import 'package:semesta/ui/widgets/radio_group_input.dart';
import 'package:semesta/ui/widgets/text_input.dart';

class SignUp extends StatefulWidget {
  final AuthController controller;
  final GlobalKey<FormBuilderState> formKey;

  const SignUp({super.key, required this.formKey, required this.controller});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File? image;
  var _ckpassword = '';
  var _isVisible = false;
  var _isConfirm = false;
  final pController = TextEditingController();
  final cController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final form = widget.formKey;

    return Column(
      children: [
        ImagePicker(onTap: _pickAvatar, image: image),
        TextInput(
          name: 'name',
          label: 'Full Name',
          autofocus: true,
          prefixIcon: const Icon(Icons.person),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Full Name is required'),
            FormBuilderValidators.minLength(
              2,
              errorText: 'Full Name must be at least 2 characters',
            ),
          ]),
        ),
        RadioGroupInput(
          name: 'gender',
          icon: Icons.group_outlined,
          initValue: Gender.female.name,
          items: Gender.values.map((g) {
            return FormBuilderFieldOption(
              value: g.name,
              child: Text(toCapitalize(g.name)),
            );
          }).toList(),
        ),
        DateTimeInput(
          name: 'birthday',
          icon: Icons.date_range,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Birthday is required'),
            (value) {
              if (value == null) return null; // already handled by 'required'
              final today = DateTime.now();
              final age =
                  today.year -
                  value.year -
                  ((today.month < value.month ||
                          (today.month == value.month && today.day < value.day))
                      ? 1
                      : 0);

              if (age < 13) {
                return 'You must be at least 13 years old';
              }

              return null; // valid
            },
          ]),
        ),
        TextInput(
          name: 'email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Email is required'),
            FormBuilderValidators.email(errorText: 'Enter a valid email'),
          ]),
        ),

        TextInput(
          name: 'password',
          controller: pController,
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          obscureText: !_isVisible,
          onChanged: (value) {
            setState(() => _ckpassword = value ?? '');

            // Trigger revalidation of confirm_password when password changes
            form.currentState?.fields['confirm']?.validate();
          },
          suffixIcon: IconButton(
            icon: Icon(
              _isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () => setState(() => _isVisible = !_isVisible),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Password is required'),
            FormBuilderValidators.minLength(
              6,
              errorText: 'Password must be at least 6 characters',
            ),
          ]),
        ),

        TextInput(
          name: 'confirm',
          controller: cController,
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          obscureText: !_isConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirm
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () => setState(() => _isConfirm = !_isConfirm),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Please confirm your password';
            }
            if (val != _ckpassword) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),

        const SizedBox(height: 12),

        // Sign Up Button
        Obx(() {
          final isLoading = controller.isLoading.value;

          return CustomButton(
            enableShadow: true,
            icon: isLoading ? Loader() : Icons.create_new_folder,
            label: isLoading ? 'Signing Up...' : 'Sign Up',
            color: Theme.of(context).colorScheme.secondary,
            onPressed: isLoading
                ? null
                : () async {
                    final state = form.currentState;
                    if (state == null || !state.saveAndValidate()) return;

                    final data = state.value;
                    final email = data['email'.trim()];
                    final password = data['password'];

                    final model = UserModel(
                      name: data['name'.trim()],
                      email: email,
                      gender: Gender.values.firstWhere(
                        (e) => e.name == data['gender'],
                        orElse: () => Gender.female,
                      ),
                      birthday: data['birthday'],
                    );

                    controller.register(email, password, image!, model);
                  },
          );
        }),
      ],
    );
  }

  Future<void> _pickAvatar() async {
    final image = await FileHelper.pickImage();
    if (image == null) return;
    log(image.path);

    if (!FileHelper.isFileSizeValid(image, maxMB: 5)) {
      CustomToast.warning('Image must be smaller than 5MB');

      return;
    }

    setState(() => this.image = image);
  }

  @override
  void dispose() {
    _ckpassword = '';
    _isVisible = false;
    _isConfirm = false;
    cController.dispose();
    pController.dispose();
    super.dispose();
  }
}
