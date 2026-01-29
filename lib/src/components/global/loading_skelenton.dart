import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class LoadingSkelenton extends StatelessWidget {
  final int count;
  const LoadingSkelenton({this.count = 6, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, idx) => const _FeedSkeleton(),
    );
  }
}

class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        DirectionX(
          children: [
            const _SkeletonWave(
              width: 44,
              height: 44,
              radius: BorderRadius.all(Radius.circular(22)),
            ),
            const SizedBox(width: 12),
            DirectionY(
              children: const [
                _SkeletonWave(width: 120, height: 14),
                SizedBox(height: 6),
                _SkeletonWave(width: 80, height: 12),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        const _SkeletonWave(width: double.infinity, height: 14),
        const SizedBox(height: 8),
        const _SkeletonWave(width: 240, height: 14),
        const SizedBox(height: 14),
        const _SkeletonWave(width: double.infinity, height: 180),
      ],
    );
  }
}

class _SkeletonWave extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius radius;
  const _SkeletonWave({
    required this.width,
    required this.height,
    this.radius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<_SkeletonWave> createState() => _SkeletonWaveState();
}

class _SkeletonWaveState extends State<_SkeletonWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.radius,
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _ctrl.value * 2, 0),
              end: Alignment(1.0 + _ctrl.value * 2, 0),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade200,
                Colors.grey.shade300,
              ],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }
}
