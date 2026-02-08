import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class AuthHeader extends StatelessWidget {
  final bool make;
  const AuthHeader(this.make, {super.key});

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 80, color: const Color(0xFF4A9EFF)),
        const SizedBox(height: 8),
        Text(
          make ? 'Create account' : 'Welcome back',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        Text(
          make ? 'Sign up to get started' : 'Sign in to continue',
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
}
