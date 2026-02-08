import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class ReferencedToPost extends StatelessWidget {
  final String _uid;
  const ReferencedToPost(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = uctrl.dataMapping[_uid];
      return data == null
          ? const SizedBox.shrink()
          : DisplayParent(
              name: data.uname,
              onTap: () async {
                await context.openProfile(
                  data.id,
                  pctrl.currentedUser(data.id),
                );
              },
            );
    });
  }
}

class DisplayParent extends StatelessWidget {
  final String message, name;
  final bool commented;
  final Color? color;
  final VoidCallback? onTap;
  const DisplayParent({
    super.key,
    this.message = 'Replying to',
    required this.name,
    this.commented = true,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      spacing: 6,
      padding: const EdgeInsets.only(bottom: 4),
      children: [
        Text(
          message,
          style: TextStyle(color: context.secondaryColor, fontSize: 16),
        ),
        if (commented)
          Username(
            name,
            color: color ?? context.primaryColor,
            onTap: onTap,
            maxChars: 24,
          )
        else
          Animated(
            onTap: onTap,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: context.secondaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
