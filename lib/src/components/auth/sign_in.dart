import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/widgets/main/custom_button.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:semesta/src/widgets/sub/inputable.dart';

class SignIn extends StatefulWidget {
  final bool loading;
  final GlobalKey<FormBuilderState> _key;
  const SignIn(this._key, {super.key, this.loading = false});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var _visible = false;
  final _input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      spacing: 8,
      crossAlignment: CrossAxisAlignment.center,
      children: [
        Inputable(
          'email',
          hint: 'Email cannot be blank',
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email_outlined,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Email is required'),
            FormBuilderValidators.email(errorText: 'Enter a valid email'),
          ]),
        ),

        Inputable(
          'password',
          controller: _input,
          hint: 'Password cannot be blank',
          keyboardType: TextInputType.visiblePassword,
          icon: Icons.lock_outline_rounded,
          obscureText: !_visible,
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
        const SizedBox(height: 12),

        // Sign In Button
        CustomButton(
          enableShadow: true,
          icon: Icons.login_rounded,
          label: widget.loading ? 'Signing In...' : 'Sign In',
          color: context.primaryColor,
          onPressed: () async {
            final state = widget._key.currentState;
            if (state == null || !state.saveAndValidate()) return;

            final data = state.value;
            await octrl.login(data['email'], data['password']);
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  @override
  void dispose() {
    _visible = false;
    _input.dispose();
    super.dispose();
  }
}
