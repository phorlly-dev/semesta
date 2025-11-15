import 'package:flutter/material.dart';
import 'package:semesta/core/models/story_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryDetail extends StatefulWidget {
  final StoryModel story;
  final UserModel? user;

  const StoryDetail({super.key, required this.story, this.user});

  @override
  State<StoryDetail> createState() => _StoryDetailState();
}

class _StoryDetailState extends State<StoryDetail> {
  final StoryController _controller = StoryController();
  late final List<StoryItem> _storyItems;

  @override
  void initState() {
    super.initState();
    _storyItems = _buildStoryItems();
  }

  List<StoryItem> _buildStoryItems() {
    final media = widget.story.media;
    List<StoryItem> items = [];

    for (var m in media) {
      final url = m.url;
      if (url.isEmpty || !url.startsWith('http')) continue;

      if (url.endsWith('.mp4') || url.contains('video')) {
        items.add(
          StoryItem.pageVideo(
            url,
            controller: _controller,
            caption: Text(widget.story.title ?? ''),
          ),
        );
      } else if (url.endsWith('.jpg') ||
          url.endsWith('.png') ||
          url.contains('pexels')) {
        items.add(
          StoryItem.pageImage(
            url: url,
            controller: _controller,
            caption: Text(widget.story.title ?? ''),
          ),
        );
      } else {
        debugPrint("⚠️ Skipping invalid media: $url");
      }
    }

    return items;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          StoryView(
            storyItems: _storyItems,
            controller: _controller,
            repeat: false,
            onComplete: () => Navigator.pop(context),
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) Navigator.pop(context);
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      user?.avatar ?? 'https://i.pravatar.cc/100?img=1',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      user?.name ?? 'Unknown User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
