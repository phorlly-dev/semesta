import 'package:flutter/material.dart';
import 'package:semesta/app/themes/app_colors.dart';
import 'package:semesta/app/themes/app_fonts.dart';

class CustomStatus extends StatelessWidget {
  final String text;
  final IconData icon;
  const CustomStatus({super.key, required this.text, this.icon = Icons.public});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: FontSize.paragraph,
            color: AppColors.blueGrey,
          ),
        ),
        Text(
          '•',
          style: TextStyle(
            color: AppColors.blueGrey,
            fontSize: FontSize.paragraph,
          ),
        ),
        Icon(icon, size: FontSize.details, color: AppColors.blueGrey),
      ],
    );
  }
}
