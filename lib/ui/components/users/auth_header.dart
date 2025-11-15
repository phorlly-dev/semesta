import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final bool isCreate;
  const AuthHeader({super.key, required this.isCreate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.lock_outline, size: 80, color: const Color(0xFF4A9EFF)),
        const SizedBox(height: 8),
        Text(
          isCreate ? 'Create Account' : 'Welcome Back',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          isCreate ? 'Sign up to get started' : 'Sign in to continue',
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
