import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/auth/auth_foooter.dart';
import 'package:semesta/src/components/auth/auth_header.dart';
import 'package:semesta/src/components/auth/sign_in.dart';
import 'package:semesta/src/components/auth/sign_up.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/overlapping.dart';
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
  var _primary = false;
  final _kf = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = octrl.loading.value;
      return Overlapping(
        loading: loading,
        message: _primary ? 'Signing Up' : 'Signing In',
        child: PageLayout(
          content: DataForm(
            _kf,
            autovalidate: AutovalidateMode.onUserInteraction,
            children: [
              // Logo/Title
              AuthHeader(_primary),
              if (!_primary) const SizedBox(height: 12),

              //Input Fields
              _primary ? SignUp(_kf) : SignIn(_kf, loading: loading),

              // Forgot Password
              // if (!_primary)
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
              if (!_primary) _buildButtons(),

              // Toggle Sign In/Up
              AuthFoooter(
                _primary,
                onPressed: () => setState(() {
                  _primary = !_primary;
                  _kf.currentState?.reset();
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildButtons() {
    return DirectionY(
      size: MainAxisSize.min,
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
          icon: 'google.png'.toAsset(true),
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
