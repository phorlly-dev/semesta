import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class AuthFoooter extends StatelessWidget {
  final bool isCreate;
  final VoidCallback? onPressed;
  const AuthFoooter(this.isCreate, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isCreate ? 'Already have an account? ' : "Don't have an account? ",
          style: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            isCreate ? 'Sign In' : 'Sign Up',
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
