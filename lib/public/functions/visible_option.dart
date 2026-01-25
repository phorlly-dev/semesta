import 'package:flutter/material.dart';
import 'package:semesta/public/utils/custom_bottom_sheet.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/src/widgets/main/option_button.dart';

class VisibleOption {
  final BuildContext _context;
  const VisibleOption(this._context);

  void showModal({
    int selected = 1,
    required void Function(int value, Visible option) onSelected,
  }) {
    CustomBottomSheet<VisibleToPost>(
      _context,
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
            e.label,
            icon: e.icon,
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

  List<VisibleToPost> select(
    int selected,
    Function(int value, Visible option) onSelected,
  ) => [
    VisibleToPost(
      icon: Icons.public,
      id: 1,
      label: 'Everyone',
      option: Visible.everyone,
      selected: selected == 1,
      onTap: () => onSelected(1, Visible.everyone),
    ),
    VisibleToPost(
      icon: Icons.verified,
      id: 2,
      label: 'Verified Accounts',
      option: Visible.verified,
      selected: selected == 2,
      onTap: () => onSelected(2, Visible.verified),
    ),
    VisibleToPost(
      icon: Icons.people_alt_outlined,
      id: 3,
      label: 'Accounts You Follow',
      option: Visible.following,
      selected: selected == 3,
      onTap: () => onSelected(3, Visible.following),
    ),
    VisibleToPost(
      icon: Icons.alternate_email_outlined,
      id: 4,
      label: 'Only Accounts You Mention',
      selected: selected == 4,
      option: Visible.mentioned,
      onTap: () => onSelected(4, Visible.mentioned),
    ),
  ];
}
