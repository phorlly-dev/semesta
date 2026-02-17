import 'package:flutter/material.dart';
import 'package:semesta/app/models/hashtag.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';

class HashtagPanel extends StatelessWidget {
  final String value;
  final bool loading;
  final ValueNotifier<List<Hashtag>> hashtags;
  final ValueChanged<String>? onSelected;
  const HashtagPanel({
    super.key,
    this.onSelected,
    this.value = '',
    this.loading = false,
    required this.hashtags,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.texts.titleMedium?.copyWith(
      overflow: TextOverflow.ellipsis,
    );

    return ValueListenableBuilder(
      valueListenable: hashtags,
      builder: (_, items, child) {
        if (items.isEmpty && !loading) {
          return ListTile(
            title: Text(value, style: style),
            onTap: () => onSelected?.call(value),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            final hashtag = '#${item.name}';

            return ListTile(
              title: Text(hashtag, style: style),
              subtitle: item.trending
                  ? Text(
                      'Trending',
                      style: context.texts.bodyMedium?.copyWith(
                        color: context.hintColor,
                      ),
                    )
                  : null,
              onTap: () => onSelected?.call(hashtag),
            );
          },
        );
      },
    );
  }
}
