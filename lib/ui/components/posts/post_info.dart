import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/ui/components/globals/expandable_text.dart';
import 'package:semesta/ui/components/globals/media_gallery.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

typedef OpenProfile = Future<void> Function(String uid, bool self);

class DisplayQuoted extends StatelessWidget {
  final Feed quoted;
  final Author actor;
  final bool authed;
  final VoidCallback? onTap;
  final ValueChanged<String>? onTag;
  const DisplayQuoted({
    super.key,
    required this.quoted,
    this.authed = false,
    required this.actor,
    this.onTap,
    this.onTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 60, end: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          InkWell(
            radius: 56,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarAnimation(imageUrl: actor.avatar, size: 32),
                  SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            DisplayName(data: actor.name),
                            SizedBox(width: 6),

                            Username(data: actor.uname, maxChars: 32),
                            SizedBox(width: 4),

                            Status(created: quoted.createdAt, hasIcon: false),
                          ],
                        ),

                        if (quoted.content.isNotEmpty)
                          ExpandableText(
                            text: quoted.content,
                            trimLength: 120,
                            onTagTap: onTag,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (quoted.media.isNotEmpty) ...[
            SizedBox(height: 8),
            MediaGallery(
              media: quoted.media,
              id: quoted.id,
              start: 0,
              end: 0,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RepostBanner extends StatelessWidget {
  final ActionTarget target;
  final String uid;
  final OpenProfile? onTap;
  const RepostBanner({
    super.key,
    this.onTap,
    required this.target,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RepostView>(
      stream: actrl.repostStream$(target, uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final rxs = snapshot.data!;
        return DisplayRepost(
          displayName: rxs.authed ? 'You' : rxs.name,
          onTap: () async {
            await onTap?.call(rxs.uid, rxs.authed);
          },
        );
      },
    );
  }
}

class ReplyingTo extends StatelessWidget {
  final String uid;
  final OpenProfile? onTap;
  const ReplyingTo({super.key, this.onTap, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = uctrl.dataMapping[uid];
      if (data == null) return const SizedBox.shrink();

      return DisplayParent(
        name: data.uname,
        onTap: () async {
          await onTap?.call(data.id, pctrl.isCurrentUser(data.id));
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
          Username(
            data: name,
            color: colors.primary,
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
                color: colors.secondary,
              ),
            ),
          ),
      ],
    );
  }
}
