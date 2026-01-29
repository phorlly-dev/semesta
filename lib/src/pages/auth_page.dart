import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/auth/auth_foooter.dart';
import 'package:semesta/src/components/auth/auth_header.dart';
import 'package:semesta/src/components/auth/sign_in.dart';
import 'package:semesta/src/components/auth/sign_up.dart';
import 'package:semesta/src/components/layout/_layout_page.dart';
import 'package:semesta/src/widgets/sub/block_overlay.dart';
import 'package:semesta/src/widgets/main/custom_button.dart';
import 'package:semesta/src/widgets/main/data_form.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = octrl.isLoading.value;
      return Stack(
        children: [
          LayoutPage(
            content: DataForm(
              fkey,
              autovalidate: AutovalidateMode.onUserInteraction,
              children: [
                // Logo/Title
                AuthHeader(_isSignUp),
                if (!_isSignUp) const SizedBox(height: 12),

                //Input Fields
                _isSignUp ? SignUp(fkey) : SignIn(fkey, isLoading: isLoading),

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
                  _isSignUp,
                  onPressed: () => setState(() {
                    _isSignUp = !_isSignUp;
                    fkey.currentState?.reset();
                  }),
                ),
              ],
            ),
          ),

          // ---- overlay ----
          if (isLoading) BlockOverlay(_isSignUp ? 'Signing Up' : 'Signing In'),
        ],
      );
    });
  }

  Widget _buildButtons() {
    return DirectionY(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider
        DirectionX(
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
          icon: 'google.png'.asImage(true),
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
