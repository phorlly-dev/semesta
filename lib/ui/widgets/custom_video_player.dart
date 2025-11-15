import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/loader.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String video;
  const CustomVideoPlayer({super.key, required this.video});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(widget.video),
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..setLooping(true)
          ..initialize()
              .then((_) {
                if (mounted) setState(() {});
              })
              .catchError((_) {
                setState(() => hasError = true);
              });
  }

  @override
  Widget build(BuildContext context) {
    if (hasError || _controller.value.hasError) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Text("⚠️ Cannot play this video"),
      );
    }

    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: 60,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
            ],
          )
        : const Loader();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
