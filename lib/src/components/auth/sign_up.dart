import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/widgets/main/custom_button.dart';
import 'package:semesta/src/widgets/sub/dated_picker.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:semesta/src/widgets/sub/avatar_editale.dart';
import 'package:semesta/src/widgets/sub/inputable.dart';

class SignUp extends StatefulWidget {
  final GlobalKey<FormBuilderState> _key;
  const SignUp(this._key, {super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _ckpassword = '', _name = '';
  var _visible = false;
  var _confirm = false;
  final _pinput = TextEditingController();
  final _cinput = TextEditingController();
  final _uinput = TextEditingController();
  final _focus = FocusNode();
  final _key = 'avatar';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final form = widget._key;
      final file = grepo.cacheFor(_key).value;
      final loading = octrl.loading.value;

      return DirectionY(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarEditale(
            MediaSource.file(file?.path ?? ''),
            onTap: () => context.imagePicker(_key, editable: false),
          ),

          Inputable(
            'name',
            focusNode: _focus,
            hint: 'Name cannot be blank',
            icon: Icons.person,
            maxLength: 50,
            counterText: '${_name.length}/50',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Name is required'),
              FormBuilderValidators.minLength(
                2,
                errorText: 'Name must be at least 2 characters',
              ),
            ]),
            onChanged: (value) {
              final name = value?.trim() ?? '';
              setState(() => _name = name);
              if (name.length >= 2) {
                final suggestion = name.toUsername;
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

          Inputable(
            'uname',
            hint: 'Username cannot be blank',
            controller: _uinput,
            icon: Icons.person_outline,
            maxLength: 56,
            counterText: '${_cinput.text.length}/56',
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
                    autoClose: 4,
                  );
                }
              }
            },
          ),

          DatedPicker(
            'birthdate',
            lable: 'Birthdate',
            icon: Icons.date_range,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'Birthdate is required',
              ),
              (value) {
                if (value == null) return null; // already handled by 'required'

                if (value.toAge < 13) {
                  return 'You must be at least 13 years old';
                }

                return null; // valid
              },
            ]),
          ),
          Inputable(
            'email',
            hint: 'Email cannot be blank',
            maxLength: 50,
            keyboardType: TextInputType.emailAddress,
            icon: Icons.email_outlined,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Email is required'),
              FormBuilderValidators.email(errorText: 'Enter a valid email'),
            ]),
          ),

          Inputable(
            'password',
            controller: _pinput,
            maxLength: 32,
            hint: 'Password cannot be blank',
            keyboardType: TextInputType.visiblePassword,
            icon: Icons.lock_outline_rounded,
            obscureText: !_visible,
            onChanged: (value) {
              setState(() => _ckpassword = value ?? '');

              // Trigger revalidation of confirm when password changes
              form.currentState?.fields['confirm']?.validate();
            },
            suffix: IconButton(
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

          Inputable(
            'confirm',
            controller: _cinput,
            maxLength: 32,
            hint: 'Confirm must be match password',
            keyboardType: TextInputType.visiblePassword,
            icon: Icons.lock_outline_rounded,
            obscureText: !_confirm,
            suffix: IconButton(
              icon: Icon(
                _confirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: context.hintColor,
              ),
              onPressed: () => setState(() => _confirm = !_confirm),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please confirm your password';
              }

              if (val != _ckpassword) return 'Passwords do not match';

              return null;
            },
          ),
          const SizedBox(height: 12),

          // Sign Up Button
          CustomButton(
            enableShadow: true,
            icon: Icons.create_new_folder,
            label: loading ? 'Signing Up...' : 'Sign Up',
            color: context.colors.secondary,
            onPressed: loading
                ? null
                : () async {
                    final state = form.currentState;
                    if (state == null || !state.saveAndValidate()) return;

                    final map = state.value;
                    final uname = await grepo.getUniqueName(map['uname']);
                    final model = Author(
                      uname: uname,
                      name: map['name'],
                      email: map['email'],
                      birthdate: map['birthdate'],
                    );

                    await octrl.register(model, map['password'], file);
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
    grepo.clearFor(_key);
    _cinput.dispose();
    _pinput.dispose();
    _uinput.dispose();
    super.dispose();
  }
}
