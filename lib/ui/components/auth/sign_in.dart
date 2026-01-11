import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/ui/widgets/custom_button.dart';
import 'package:semesta/ui/widgets/loading_animated.dart';
import 'package:semesta/ui/widgets/text_input.dart';

class SignIn extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  const SignIn(this.formKey, {super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var _visible = false;
  final _input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          controller: _input,
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          obscureText: !_visible,
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

        const SizedBox(height: 12),

        // Sign In Button
        Obx(() {
          final isLoading = octrl.isLoading.value;
          return CustomButton(
            enableShadow: true,
            icon: isLoading ? LoadingAnimated() : Icons.login_rounded,
            label: isLoading ? 'Signing In...' : 'Sign In',
            color: Theme.of(context).colorScheme.primary,
            onPressed: isLoading
                ? null
                : () async {
                    final state = widget.formKey.currentState;
                    if (state == null || !state.saveAndValidate()) return;

                    final data = state.value;
                    await octrl.login(data['email'], data['password']);
                  },
          );
        }),

        SizedBox(height: 24),
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
