import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/action_button.dart';

class FooterPostLayer extends StatelessWidget {
  final int valReply, valLike, valRepost, valview, valSave, valShare;
  final bool isLiked, isReposted, isSaved;
  final VoidCallback? onReply, onLike, onRepost, onView, onSave, onShare;

  const FooterPostLayer({
    super.key,
    this.valReply = 0,
    this.valLike = 0,
    this.valRepost = 0,
    this.valview = 0,
    this.valSave = 0,
    this.valShare = 0,
    this.onReply,
    this.onLike,
    this.onRepost,
    this.onView,
    this.onSave,
    this.onShare,
    this.isLiked = false,
    this.isReposted = false,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).hintColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Left group: engagement actions ---
          Wrap(
            spacing: 3.2,
            children: [
              // Comment
              ActionButton(
                icon: 'comment.png',
                label: valReply,
                iconColor: color,
                onPressed: onReply,
              ),

              // Like
              ActionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                label: valLike,
                isActive: isLiked,
                iconColor: isLiked ? Colors.redAccent : color,
                onPressed: onLike,
              ),

              // Repost
              ActionButton(
                icon: Icons.autorenew_rounded,
                label: valRepost,
                iconColor: isReposted ? Colors.green : color,
                isActive: isReposted,
                onPressed: onRepost,
              ),

              // Views
              ActionButton(
                icon: Icons.remove_red_eye_outlined,
                label: valview,
                iconColor: color,
                onPressed: onView,
              ),
            ],
          ),

          // --- Right group: secondary actions ---
          Wrap(
            children: [
              ActionButton(
                icon: isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                iconColor: isSaved ? Colors.blueAccent : color,
                label: valSave,
                isActive: isSaved,
                onPressed: onSave,
              ),

              // Share
              ActionButton(
                icon: Icons.ios_share_rounded,
                iconColor: color,
                label: valShare,
                onPressed: onShare,
              ),
            ],
          ),
          // Save
        ],
      ),
    );
  }
}
