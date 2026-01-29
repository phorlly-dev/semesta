import 'package:flutter/material.dart';
import 'package:semesta/public/utils/custom_bottom_sheet.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class VisibleOption {
  final BuildContext _context;
  const VisibleOption(this._context);

  void showModal({
    int selected = 1,
    required FnP2<int, Visible, void> onSelected,
  }) {
    CustomBottomSheet<VisibleToPost>(
      _context,
      children: [
        DirectionY(
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
          ],
        ),

        const SizedBox(height: 16),

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
        const SizedBox(height: 16),
      ],
    );
  }

  int mapVisibleToId(Visible v) {
    return switch (v) {
      Visible.verified => 2,
      Visible.following => 3,
      Visible.mentioned => 4,
      _ => 1,
    };
  }

  IconData mapToIcon(Visible v) {
    return switch (v) {
      Visible.verified => Icons.verified,
      Visible.following => Icons.people_alt_outlined,
      Visible.mentioned => Icons.alternate_email_outlined,
      _ => Icons.public,
    };
  }

  List<VisibleToPost> select(
    int selected,
    FnP2<int, Visible, void> onSelected,
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
