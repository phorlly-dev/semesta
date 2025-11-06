import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:semesta/app/utils/custom_snack_bar.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/ui/partials/_layout.dart';
import 'package:semesta/ui/widgets/custom_button.dart';
import 'package:semesta/ui/widgets/data_form.dart';
import 'package:semesta/ui/widgets/text_input.dart';

class Auth extends StatefulWidget {
  final AuthController controller;

  const Auth({super.key, required this.controller});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormBuilderState>();
  var _isSignUp = false;
  var _ckpassword = '';
  var _isVisible = false;
  var _isConfirm = false;
  final pController = TextEditingController();
  final cController = TextEditingController();

  void _resetPasswordFields() {
    pController.clear();
    cController.clear();
    setState(() => _ckpassword = '');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final controller = widget.controller;

    return Layout(
      content: DataForm(
        formKey: _formKey,
        autovalidate: AutovalidateMode.onUserInteraction,
        children: [
          // Logo/Title
          _buildHeader(),
          const SizedBox(height: 8),

          //Input Fields
          _buildAuth(),

          // Forgot Password
          // if (!_isSignUp)
          //   Align(
          //     alignment: Alignment.centerRight,
          //     child: TextButton(
          //       onPressed: () {},
          //       child: Text(
          //         'Forgot Password?',
          //         style: TextStyle(
          //           color: const Color(0xFF4A9EFF),
          //           fontSize: 14,
          //         ),
          //       ),
          //     ),
          //   ),
          const SizedBox(height: 6),

          Obx(() {
            final err = controller.hasError.value;
            if (err.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar(context, message: err, type: MessageType.error);
                _resetPasswordFields();
                controller.hasError.value = ''; // clear so it won’t repeat
              });
            }

            return const SizedBox.shrink(); // placeholder widget
          }),

          // Sign In/Up Button
          CustomButton(
            icon: _isSignUp ? Icons.create_new_folder : Icons.login_rounded,
            label: _isSignUp ? 'Sign Up' : 'Sign In',
            onPressed: () {
              final state = _formKey.currentState;
              if (state?.saveAndValidate() ?? false) {
                final data = state!.value;
                final email = data['email'];
                final password = data['password'];

                if (_isSignUp) {
                  controller.register(email, password);
                } else {
                  controller.login(email, password);
                }
              }
            },
            backgroundColor: _isSignUp ? colors.secondary : colors.primary,
          ),

          const SizedBox(height: 16),
          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[700])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('OR', style: TextStyle(color: Colors.grey[400])),
              ),
              Expanded(child: Divider(color: Colors.grey[700])),
            ],
          ),

          // Social Sign-In Buttons
          CustomButton(
            icon: Icons.g_mobiledata,
            label: 'Continue with Google',
            onPressed: () => controller.loginWithGoogle(),
            backgroundColor: Colors.green,
          ),
          CustomButton(
            icon: Icons.facebook,
            label: 'Continue with Facebook',
            onPressed: () => controller.loginWithFacebook(),
            backgroundColor: Colors.blueAccent,
          ),

          // Toggle Sign In/Up
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.lock_outline, size: 80, color: const Color(0xFF4A9EFF)),
        const SizedBox(height: 8),
        Text(
          _isSignUp ? 'Create Account' : 'Welcome Back',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          _isSignUp ? 'Sign up to get started' : 'Sign in to continue',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAuth() {
    final form = _formKey.currentState;
    return Wrap(
      children: [
        TextInput(
          name: 'email',
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Email is required'),
            FormBuilderValidators.email(errorText: 'Enter a valid email'),
          ]),
        ),

        TextInput(
          name: 'password',
          label: 'Password',
          controller: pController,
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          obscureText: !_isVisible,
          onChanged: (value) {
            setState(() => _ckpassword = value ?? '');

            // Trigger revalidation of confirm_password when password changes
            form?.fields['confirm']?.validate();
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

        if (_isSignUp)
          TextInput(
            name: 'confirm',
            label: 'Confirm',
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
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isSignUp ? 'Already have an account? ' : "Don't have an account? ",
          style: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isSignUp = !_isSignUp;
              _formKey.currentState?.reset();
              _resetPasswordFields();
            });
          },
          child: Text(
            _isSignUp ? 'Sign In' : 'Sign Up',
            style: const TextStyle(
              color: Color(0xFF4A9EFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
