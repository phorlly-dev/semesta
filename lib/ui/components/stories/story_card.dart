import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/utils/format.dart';
import 'package:semesta/core/models/story_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:video_player/video_player.dart';

class StoryCard extends StatefulWidget {
  final StoryModel story;
  final UserModel? user;
  final bool isOwner;

  const StoryCard({
    super.key,
    required this.story,
    this.user,
    this.isOwner = false,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  VideoPlayerController? _controller;
  bool _isVideoReady = false;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  void _initializeMedia() {
    final videos = widget.story.media;
    if (videos.isNotEmpty && videos.first.type == 'video') {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(videos.first.url))
            ..initialize().then((_) {
              if (mounted) setState(() => _isVideoReady = true);
            });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final user = widget.user;
    final borderRadius = BorderRadius.circular(14);

    final mediaUrl = story.media.isNotEmpty ? story.media.first : null;
    final avatarUrl = user?.avatar ?? '';

    return Animated(
      onTap: () {
        context.pushNamed(
          Routes().storyDetail.name,
          extra: {'user': user?.toMap(), 'story': story.toMap()},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 110,
        height: 190,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🖼️ Image or 🎞️ Video
            if (mediaUrl != null && mediaUrl.type == 'image')
              FadeInImage(
                image: NetworkImage(mediaUrl.url),
                placeholder: AssetImage(setImage('placeholder.png')),
                fit: BoxFit.cover,
              )
            else if (_controller != null && _isVideoReady)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              Container(
                color: Colors.grey[700],
                child: const Center(
                  child: Icon(Icons.image_outlined, color: Colors.white30),
                ),
              ),

            // 🌓 Gradient overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // 🧍 User + label
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isOwner
                              ? Colors.blueAccent
                              : Colors.purpleAccent,
                          width: 2.5,
                        ),
                      ),
                      child: AvatarAnimation(imageUrl: avatarUrl, size: 36),
                    ),
                  ),
                  Text(
                    widget.isOwner
                        ? 'Your story'
                        : ((user?.name?.trim().isEmpty ?? true)
                              ? 'Unknown'
                              : user!.name!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
