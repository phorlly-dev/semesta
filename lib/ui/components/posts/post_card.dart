import 'package:flutter/material.dart';
import 'package:semesta/ui/components/posts/post_content.dart';
import 'package:semesta/ui/components/posts/post_footer.dart';
import 'package:semesta/ui/components/posts/post_header.dart';
import 'package:semesta/ui/widgets/break_section.dart';

class PostCard extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String? text;
  final String? backgroundUrl;
  final List<String>? imageUrls, videoUrls;
  final int likeCount;
  final int commentCount;
  final int shareCount;

  const PostCard({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.timeAgo,
    this.text,
    this.backgroundUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.imageUrls,
    this.videoUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header ---
        PostHeader(name: userName, avatar: userAvatar, created: timeAgo),

        // --- Content (text or background) ---
        PostContent(
          background: backgroundUrl,
          title: text,
          images: imageUrls,
          videos: videoUrls,
        ),

        // --- Footer ---
        PostFooter(like: likeCount, comment: commentCount, share: shareCount),
        const BreakSection(),
      ],
    );
  }
}
