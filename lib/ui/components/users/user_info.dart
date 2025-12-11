import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format.dart';

class DisplayName extends StatelessWidget {
  final String data;
  const DisplayName({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      limitText(data, 24),
      style: TextStyle(
        fontSize: 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w700,
        color: colors.onSurface,
      ),
    );
  }
}

class Username extends StatelessWidget {
  final String data;
  const Username({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      '@${limitText(data, 16)}',
      style: TextStyle(
        fontSize: 14.2,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        color: colors.secondary,
      ),
    );
  }
}

class Status extends StatelessWidget {
  final DateTime? created;
  final IconData icon;
  const Status({super.key, this.created, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      spacing: 4.2,
      children: [
        Text(
          timeAgo(created),
          style: TextStyle(fontSize: 14.6, color: colors.secondary),
        ),
        Icon(Icons.circle, size: 3.2, color: colors.secondary),
        Icon(icon, size: 12, color: colors.primary),
      ],
    );
  }
}

class Bio extends StatelessWidget {
  final String data;
  const Bio({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        data,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 15,
          color: colors.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class FollowYou extends StatelessWidget {
  const FollowYou({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 28),
      child: Row(
        spacing: 8,
        children: [
          Icon(Icons.person, color: theme.hintColor),
          Text(
            'Follows you',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
