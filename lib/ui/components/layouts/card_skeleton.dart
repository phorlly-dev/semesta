import 'package:flutter/material.dart';

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).dividerColor.withValues(alpha: 0.15);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderSkeleton(color),
          _ContentSkeleton(color),
          _FooterSkeleton(color),
        ],
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  final Color color;
  const _HeaderSkeleton(this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),

        // name + time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 12, width: 120, color: color),
              const SizedBox(height: 6),
              Container(height: 10, width: 80, color: color),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentSkeleton extends StatelessWidget {
  final Color color;
  const _ContentSkeleton(this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 14, width: double.infinity, color: color),
        const SizedBox(height: 8),
        Container(height: 14, width: double.infinity, color: color),
        const SizedBox(height: 8),
        Container(height: 14, width: 200, color: color),

        const SizedBox(height: 12),

        // media placeholder
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

class _FooterSkeleton extends StatelessWidget {
  final Color color;
  const _FooterSkeleton(this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (_) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(width: 36, height: 12, color: color),
        );
      }),
    );
  }
}
