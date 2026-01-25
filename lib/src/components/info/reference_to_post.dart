import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/animated.dart';

class ReferenceToPost extends StatelessWidget {
  final String uid;
  const ReferenceToPost({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = uctrl.dataMapping[uid];
      if (data == null) return const SizedBox.shrink();

      return DisplayParent(
        name: data.uname,
        onTap: () async {
          await context.openProfile(data.id, pctrl.isCurrentUser(data.id));
        },
      );
    });
  }
}

class DisplayParent extends StatelessWidget {
  final String message, name;
  final bool commented;
  final VoidCallback? onTap;
  const DisplayParent({
    super.key,
    this.message = 'Replying to',
    required this.name,
    this.commented = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      spacing: 6,
      children: [
        Text(message, style: TextStyle(color: colors.secondary)),
        if (commented)
          Username(name, color: colors.primary, onTap: onTap, maxChars: 24)
        else
          Animated(
            onTap: onTap,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colors.secondary,
              ),
            ),
          ),
      ],
    );
  }
}
