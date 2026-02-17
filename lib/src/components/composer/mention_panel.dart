import 'package:flutter/material.dart';
import 'package:semesta/app/models/mention.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class MentiionPanel extends StatelessWidget {
  final String value;
  final bool loading;
  final ValueChanged<String>? onSelected;
  final ValueNotifier<List<Mention>> _mentions;
  const MentiionPanel(
    this._mentions, {
    super.key,
    this.onSelected,
    this.value = '',
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.texts.titleMedium?.copyWith(
      overflow: TextOverflow.ellipsis,
    );

    return ValueListenableBuilder(
      valueListenable: _mentions,
      builder: (_, items, child) {
        if (items.isEmpty && !loading) {
          return ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: context.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search, color: Colors.white),
            ),
            title: Text("Find who you's looking for", style: style),
            subtitle: Text('Search for the person you want to mention'),
            onTap: () => onSelected?.call(value),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            final mention = '@${item.uname}';

            return loading
                ? const AnimatedLoader(cupertino: true)
                : InkWell(
                    child: DirectionY(
                      size: MainAxisSize.min,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      children: [
                        StreamBuilder(
                          stream: actrl.status$(item.id),
                          builder: (_, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            }

                            final state = snapshot.data!;
                            final label = state.followBanner;

                            return label.isNotEmpty
                                ? FollowBanner(title: label, start: 20)
                                : const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 2),

                        DirectionX(
                          children: [
                            AnimatedAvatar(MediaSource.network(item.url)),
                            const SizedBox(width: 12),

                            Expanded(
                              child: DirectionY(
                                children: [
                                  DirectionX(
                                    children: [
                                      DisplayName(item.name),

                                      if (item.verified) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.verified,
                                          size: 14,
                                          color: context.primaryColor,
                                        ),
                                      ],
                                    ],
                                  ),

                                  Username(item.uname),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => onSelected?.call(mention),
                  );
          },
        );
      },
    );
  }
}
