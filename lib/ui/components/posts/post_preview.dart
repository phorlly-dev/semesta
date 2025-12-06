import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/custom_image.dart';
import 'package:semesta/ui/widgets/media_gallery.dart';
import 'package:semesta/ui/widgets/text_grouped.dart';

class PostPreview extends StatelessWidget {
  final PostModel post;
  final bool isRepost;

  const PostPreview({super.key, required this.post, this.isRepost = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Column(
      children: [
        if (isRepost)
          Wrap(
            children: [
              ListTile(
                leading: AvatarAnimation(imageUrl: post.userAvatar),
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 6,
                    children: [
                      TextGrouped(
                        first: post.displayName,
                        second: limitText('@${post.username}', 16),
                      ),
                      Icon(Icons.circle, size: 3.2, color: theme.hintColor),
                      Text(
                        timeAgo(post.createdAt),
                        style: text.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium,
                ),
              ),

              MediaGallery(media: [post.media[0]], id: post.id, spaceX: 0),
            ],
          )
        else
          ListTile(
            leading: AvatarAnimation(imageUrl: post.userAvatar),
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 6,
                children: [
                  TextGrouped(
                    first: post.displayName,
                    second: limitText('@${post.username}', 16),
                  ),
                  Icon(Icons.circle, size: 3.2, color: theme.hintColor),
                  Text(
                    timeAgo(post.createdAt),
                    style: text.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.bodyMedium,
            ),
            trailing: post.media.isNotEmpty
                ? CustomImage(
                    image: post.media[0].display,
                    borderRadius: BorderRadius.circular(8),
                    width: 56,
                  )
                : null,
          ),
      ],
    );
  }
}
