import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class ReferencedToPost extends StatelessWidget {
  final String _uid;
  const ReferencedToPost(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: uctrl.loadUser(_uid),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final data = snapshot.data!;
        return DisplayParent(
          data.uname,
          onTap: () async {
            await context.openProfile(data.id, pctrl.currentedUser(data.id));
          },
        );
      },
    );
  }
}

class DisplayParent extends StatelessWidget {
  final String _data, message;
  final bool commented;
  final Color? color;
  final VoidCallback? onTap;
  const DisplayParent(
    this._data, {
    super.key,
    this.message = 'Replying to',
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
            _data,
            color: color ?? Colors.blueAccent,
            onTap: onTap,
            maxChars: 32,
          )
        else
          Animated(
            onTap: onTap,
            child: Text(
              _data,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: color ?? context.secondaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
