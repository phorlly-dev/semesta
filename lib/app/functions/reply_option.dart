import 'package:flutter/material.dart';
import 'package:semesta/app/utils/custom_bottom_sheet.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/ui/widgets/option_button.dart';

class ReplyOption {
  final BuildContext context;
  ReplyOption(this.context);

  void showModal({
    int selected = 1,
    required void Function(int value, Visible option) onSelected,
  }) {
    CustomBottomSheet<ReplyParams>(
      context,
      children: [
        const Text(
          'Who Can Reply?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pick who can reply to this post. Anyone mentioned can always reply.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),

        ...select(selected, onSelected).map((e) {
          return OptionButton(
            icon: e.icon,
            label: e.label,
            color: e.selected ? Colors.blueAccent : null,
            onTap: e.onTap,
            status: e.selected
                ? const Icon(Icons.check_circle, color: Colors.blueAccent)
                : const Icon(Icons.circle_outlined, color: Colors.grey),
          );
        }),
      ],
    );
  }

  int mapVisibleToId(Visible v) {
    switch (v) {
      case Visible.verified:
        return 2;
      case Visible.following:
        return 3;
      case Visible.mentioned:
        return 4;
      default:
        return 1;
    }
  }

  IconData mapToIcon(Visible v) {
    switch (v) {
      case Visible.verified:
        return Icons.verified;
      case Visible.following:
        return Icons.people_alt_outlined;
      case Visible.mentioned:
        return Icons.alternate_email_outlined;
      default:
        return Icons.public;
    }
  }

  List<ReplyParams> select(
    int selected,
    Function(int value, Visible option) onSelected,
  ) => [
    ReplyParams(
      icon: Icons.public,
      id: 1,
      label: 'Everyone',
      option: Visible.everyone,
      selected: selected == 1,
      onTap: () => onSelected(1, Visible.everyone),
    ),
    ReplyParams(
      icon: Icons.verified,
      id: 2,
      label: 'Verified Accounts',
      option: Visible.verified,
      selected: selected == 2,
      onTap: () => onSelected(2, Visible.verified),
    ),
    ReplyParams(
      icon: Icons.people_alt_outlined,
      id: 3,
      label: 'Accounts You Follow',
      option: Visible.following,
      selected: selected == 3,
      onTap: () => onSelected(3, Visible.following),
    ),
    ReplyParams(
      icon: Icons.alternate_email_outlined,
      id: 4,
      label: 'Only Accounts You Mention',
      selected: selected == 4,
      option: Visible.mentioned,
      onTap: () => onSelected(4, Visible.mentioned),
    ),
  ];
}
