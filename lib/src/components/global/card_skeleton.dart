import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.dividerColor.withValues(alpha: .15);
    return DirectionY(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderSkeleton(color),
        _ContentSkeleton(color),
        _FooterSkeleton(color),
      ],
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  final Color _color;
  const _HeaderSkeleton(this._color);

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      children: [
        // avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),

        // name + time
        Expanded(
          child: DirectionY(
            children: [
              Container(height: 12, width: 120, color: _color),
              const SizedBox(height: 6),
              Container(height: 10, width: 80, color: _color),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentSkeleton extends StatelessWidget {
  final Color _color;
  const _ContentSkeleton(this._color);

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      children: [
        Container(height: 14, width: double.infinity, color: _color),
        const SizedBox(height: 8),

        Container(height: 14, width: double.infinity, color: _color),
        const SizedBox(height: 8),

        Container(height: 14, width: 200, color: _color),
        const SizedBox(height: 12),

        // media placeholder
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

class _FooterSkeleton extends StatelessWidget {
  final Color _color;
  const _FooterSkeleton(this._color);

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      children: List.generate(4, (_) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(width: 36, height: 12, color: _color),
        );
      }),
    );
  }
}
