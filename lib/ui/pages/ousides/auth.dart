import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:semesta/app/utils/format.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/ui/components/users/auth_foooter.dart';
import 'package:semesta/ui/components/users/auth_header.dart';
import 'package:semesta/ui/components/users/sign_in.dart';
import 'package:semesta/ui/components/users/sign_up.dart';
import 'package:semesta/ui/partials/gen/_layout.dart';
import 'package:semesta/ui/widgets/custom_button.dart';
import 'package:semesta/ui/widgets/data_form.dart';

class Auth extends StatefulWidget {
  final AuthController controller;

  const Auth({super.key, required this.controller});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormBuilderState>();
  var _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Layout(
      content: DataForm(
        formKey: _formKey,
        autovalidate: AutovalidateMode.onUserInteraction,
        children: [
          // Logo/Title
          AuthHeader(isCreate: _isSignUp),
          if (!_isSignUp) const SizedBox(height: 12),

          //Input Fields
          _isSignUp
              ? SignUp(controller: controller, formKey: _formKey)
              : SignIn(controller: controller, formKey: _formKey),

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
          if (!_isSignUp) _buildButtons(controller),

          // Toggle Sign In/Up
          AuthFoooter(
            isCreate: _isSignUp,
            onPressed: () => setState(() {
              _isSignUp = !_isSignUp;
              _formKey.currentState?.reset();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(AuthController controller) {
    return Wrap(
      children: [
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
          icon: setImage('google.png', true),
          label: 'Continue with Google',

          // onPressed: controller.loginWithGoogle,
          color: Colors.green,
          spaceY: 8,
          enableShadow: true,
        ),
        CustomButton(
          icon: Icons.facebook,
          label: 'Continue with Facebook',
          onPressed: controller.loginWithFacebook,
          color: Colors.blueAccent,
          enableShadow: true,
        ),
      ],
    );
  }
}
