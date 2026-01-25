import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String _video;
  final bool showProgress;
  const CustomVideoPlayer(this._video, {super.key, this.showProgress = false});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final VideoPlayerController _controller;
  bool hasError = false;
  bool isVisible = false;
  bool muted = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget._video))
      ..setLooping(true)
      ..initialize()
          .then((_) {
            setState(() {});
          })
          .catchError((_) {
            setState(() => hasError = true);
          });
  }

  void _handleVisibility(double visibleFraction) {
    final isMostlyVisible = visibleFraction > 0.5; // 50% on screen
    if (isMostlyVisible && !_controller.value.isPlaying) {
      _controller.play();
    } else if (!isMostlyVisible && _controller.value.isPlaying) {
      _controller.pause();
    }
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

    return VisibilityDetector(
      key: ValueKey(widget._video),
      onVisibilityChanged: (info) => _handleVisibility(info.visibleFraction),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // --- Video player ---
          if (_controller.value.isInitialized)
            FittedBox(fit: BoxFit.cover, child: VideoPlayer(_controller))
          else
            const Center(child: CircularProgressIndicator()),

          // --- Progress Bar (only if preview mode) ---
          if (widget.showProgress && _controller.value.isInitialized)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: SmoothVideoProgress(
                controller: _controller,
                builder: (context, position, duration, _) {
                  return SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 2,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                    ),
                    child: Slider(
                      value: position.inMilliseconds.toDouble(),
                      max: duration.inMilliseconds.toDouble(),
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                      onChanged: (value) {
                        _controller.seekTo(
                          Duration(milliseconds: value.toInt()),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

          // --- Mute Button ---
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                muted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  muted = !muted;
                  _controller.setVolume(muted ? 0 : 1);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
