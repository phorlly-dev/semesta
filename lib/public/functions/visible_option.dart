import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class VisibleOption {
  final BuildContext _context;
  const VisibleOption(this._context);

  void showModal([
    Visible option = Visible.everyone,
    ValueChanged<Visible>? onChanged,
  ]) => _context.sheet(
    children: [
      DirectionY(
        mainAxisSize: MainAxisSize.min,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const Text(
            'Who can reply?',
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

      ..._selectOptions(onChanged).map((e) {
        final selected = option == e.option;
        return OptionButton(
          e.label,
          icon: e.icon,
          color: selected ? Colors.blueAccent : null,
          onTap: e.onTap,
          status: selected
              ? const Icon(Icons.check_circle, color: Colors.blueAccent)
              : const Icon(Icons.circle_outlined, color: Colors.grey),
        );
      }),

      const SizedBox(height: 16),
    ],
  );

  IconData getIcon(Visible v) => switch (v) {
    Visible.everyone => Icons.public,
    Visible.verified => Icons.verified,
    Visible.following => Icons.people_alt_outlined,
    Visible.mentioned => Icons.alternate_email_outlined,
  };

  List<VisibleToPost> _selectOptions([ValueChanged<Visible>? onChanged]) => [
    VisibleToPost.public(onChanged),
    VisibleToPost.verified(onChanged),
    VisibleToPost.following(onChanged),
    VisibleToPost.mentioned(onChanged),
  ];
}
