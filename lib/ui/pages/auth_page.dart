import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:semesta/app/functions/format_helper.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/ui/components/auth/auth_foooter.dart';
import 'package:semesta/ui/components/auth/auth_header.dart';
import 'package:semesta/ui/components/auth/sign_in.dart';
import 'package:semesta/ui/components/auth/sign_up.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/widgets/block_overlay.dart';
import 'package:semesta/ui/widgets/custom_button.dart';
import 'package:semesta/ui/widgets/data_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var _isSignUp = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = octrl.isLoading.value;
      return Stack(
        children: [
          LayoutPage(
            content: DataForm(
              formKey: _formKey,
              autovalidate: AutovalidateMode.onUserInteraction,
              children: [
                // Logo/Title
                AuthHeader(isCreate: _isSignUp),
                if (!_isSignUp) const SizedBox(height: 12),

                //Input Fields
                _isSignUp ? SignUp(_formKey) : SignIn(_formKey),

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
                if (!_isSignUp) _buildButtons(),

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
          ),

          // ---- overlay ----
          isLoading
              ? BlockOverlay(_isSignUp ? 'Signing Up' : 'Signing In')
              : SizedBox.shrink(),
        ],
      );
    });
  }

  Widget _buildButtons() {
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
        // CustomButton(
        //   icon: Icons.facebook,
        //   label: 'Continue with Facebook',
        //   onPressed: controller.loginWithFacebook,
        //   color: Colors.blueAccent,
        //   enableShadow: true,
        // ),
      ],
    );
  }
}
