import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class AuthFoooter extends StatelessWidget {
  final bool make;
  final VoidCallback? onPressed;
  const AuthFoooter(this.make, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          make ? 'Already have an account? ' : "Don't have an account? ",
          style: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            make ? 'Sign In' : 'Sign Up',
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
