import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/action_button.dart';

class PostFooter extends StatelessWidget {
  final int like, comment, share;
  const PostFooter({
    super.key,
    required this.like,
    required this.comment,
    required this.share,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        // --- Reaction counts ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$like Likes'),
              Text('$comment Comments • $share Shares'),
            ],
          ),
        ),

        // --- Action Buttons ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionButton(
              icon: 'like-outline.png',
              label: 'Like',
              onPressed: () {},
              color: Colors.blueGrey[600],
            ),
            ActionButton(
              icon: 'comment.png',
              label: 'Comment',
              onPressed: () {},
              color: Colors.blueGrey[600],
            ),
            ActionButton(
              icon: 'share.png',
              label: 'Share',
              onPressed: () {},
              color: Colors.blueGrey[600],
            ),
          ],
        ),
      ],
    );
  }
}
