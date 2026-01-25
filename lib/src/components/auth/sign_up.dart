import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/src/widgets/main/custom_button.dart';
import 'package:semesta/src/widgets/sub/date_time_input.dart';
import 'package:semesta/src/widgets/sub/image_picker.dart';
import 'package:semesta/src/widgets/sub/loading_animated.dart';
import 'package:semesta/src/widgets/sub/text_input.dart';

class SignUp extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  const SignUp(this.formKey, {super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _ckpassword = '';
  var _visible = false;
  var _confirm = false;
  final _pinput = TextEditingController();
  final _cinput = TextEditingController();
  final _uinput = TextEditingController();
  final _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final form = widget.formKey;
      final isLoading = octrl.isLoading.value;

      return Column(
        children: [
          ImagePicker(onTap: grepo.fromPicture, image: grepo.file.value),

          TextInput(
            'name',
            focusNode: _focus,
            prefixIcon: const Icon(Icons.person),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Name is required'),
              FormBuilderValidators.minLength(
                2,
                errorText: 'Name must be at least 2 characters',
              ),
            ]),
            onChanged: (value) {
              final name = value?.trim() ?? '';
              if (name.length >= 2) {
                final suggestion = grepo.getUname(name);
                if (_uinput.text != suggestion) {
                  _uinput.value = _uinput.value.copyWith(
                    text: suggestion,
                    selection: TextSelection.collapsed(
                      offset: suggestion.length,
                    ),
                    composing: TextRange.empty,
                  );
                }
              } else if (name.isEmpty) {
                _uinput.clear();
              }
            },
          ),

          TextInput(
            'uname',
            controller: _uinput,
            prefixIcon: const Icon(Icons.person_outline),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Username is required'),
              FormBuilderValidators.minLength(
                2,
                errorText: 'Username must be at least 4 characters',
              ),
            ]),
            onChanged: (value) async {
              final v = value?.trim() ?? '';
              if (v.length >= 2) {
                final exists = await grepo.unameExists(v);
                if (exists) {
                  CustomToast.warning(
                    'Oops',
                    title: 'This username is already taken',
                    duration: 6,
                  );
                }
              }
            },
          ),

          // RadioGroupInput(
          //   name: 'gender',
          //   icon: Icons.group_outlined,
          //   initValue: Gender.female.name,
          //   items: Gender.values.map((g) {
          //     return FormBuilderFieldOption(
          //       value: g.name,
          //       child: Text(toCapitalize(g.name)),
          //     );
          //   }).toList(),
          // ),
          DateTimeInput(
            'dob',
            lable: 'Date of Birth',
            icon: Icons.date_range,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'Date of Birth is required',
              ),
              (value) {
                if (value == null) return null; // already handled by 'required'
                final age =
                    now.year -
                    value.year -
                    ((now.month < value.month ||
                            (now.month == value.month && now.day < value.day))
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
            'email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Email is required'),
              FormBuilderValidators.email(errorText: 'Enter a valid email'),
            ]),
          ),

          TextInput(
            'password',
            controller: _pinput,
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            obscureText: !_visible,
            onChanged: (value) {
              setState(() => _ckpassword = value ?? '');

              // Trigger revalidation of confirm when password changes
              form.currentState?.fields['confirm']?.validate();
            },
            suffixIcon: IconButton(
              icon: Icon(
                _visible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() => _visible = !_visible),
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
            'confirm',
            controller: _cinput,
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            obscureText: !_confirm,
            suffixIcon: IconButton(
              icon: Icon(
                _confirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() => _confirm = !_confirm),
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
          CustomButton(
            enableShadow: true,
            icon: isLoading ? LoadingAnimated() : Icons.create_new_folder,
            label: isLoading ? 'Signing Up...' : 'Sign Up',
            color: Theme.of(context).colorScheme.secondary,
            onPressed: isLoading
                ? null
                : () async {
                    final state = form.currentState;
                    if (state == null || !state.saveAndValidate()) return;

                    final data = state.value;
                    final email = data['email'];
                    final password = data['password'];
                    final uname = await grepo.getUniqueName(data['uname']);

                    final model = Author(
                      uname: uname,
                      email: email,
                      dob: data['dob'],
                      name: data['name'],
                    );

                    await octrl.register(
                      email,
                      password,
                      grepo.file.value!,
                      model,
                    );
                  },
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _ckpassword = '';
    _visible = false;
    _confirm = false;
    _cinput.dispose();
    _pinput.dispose();
    _uinput.dispose();
    super.dispose();
  }
}
