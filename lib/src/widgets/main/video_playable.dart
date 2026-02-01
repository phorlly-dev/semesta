import 'package:flutter/material.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayable extends StatefulWidget {
  final MediaSource _source;
  final bool showProgress;
  const VideoPlayable(this._source, {super.key, this.showProgress = false});

  @override
  State<VideoPlayable> createState() => _VideoPlayableState();
}

class _VideoPlayableState extends State<VideoPlayable> {
  late final VideoPlayerController _controller;
  bool _hasError = false;
  bool _muted = true;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget._source.path))
          ..setLooping(true)
          ..initialize()
              .then((_) => setState(() {}))
              .catchError((_) => setState(() => _hasError = true));
  }

  void _handleVisibility(double visibleFraction) {
    final isMostlyVisible = visibleFraction > 0.5; // 50% on screen
    final playing = _controller.value.isPlaying;
    if (isMostlyVisible && !playing) {
      _controller.play();
    } else if (!isMostlyVisible && playing) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = _controller.value;
    if (_hasError || player.hasError) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Text("⚠️ Cannot play this video"),
      );
    }

    return VisibilityDetector(
      key: ValueKey(widget._source.path),
      onVisibilityChanged: (info) => _handleVisibility(info.visibleFraction),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // --- Video player ---
          if (player.isInitialized)
            AspectRatio(
              aspectRatio: player.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: AnimatedLoader(bold: 1.8),
              ),
            ),

          // --- Progress Bar (only if preview mode) ---
          if (widget.showProgress && player.isInitialized)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: SmoothVideoProgress(
                controller: _controller,
                builder: (_, position, duration, child) {
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
                _muted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  _muted = !_muted;
                  _controller.setVolume(_muted ? 0 : 1);
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
