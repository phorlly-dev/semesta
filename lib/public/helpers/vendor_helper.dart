import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

List<FeedView> mapFollowActions(
  List<Feed> feeds, {
  String? uid,
  FeedKind type = FeedKind.posted,
  List<Reaction> actions = const [],
}) {
  return feeds
      .map((feed) {
        final action = followActions(actions, (value) => value.currentId);
        return FeedView.from(
          feed,
          uid: uid,
          kind: type,
          action: action[feed.id],
        );
      })
      .toList()
      .sortOrder;
}

List<AuthedView> mapToFollow(
  List<Author> users,
  List<Reaction> reactions,
  FnP<Reaction, String> selector,
) {
  return users
      .map((user) {
        final action = followActions(reactions, selector)[user.id];
        if (action == null) return null;

        return AuthedView(user, action);
      })
      .whereType<AuthedView>()
      .toList();
}

List<FeedView> mapToFeed(List<Feed> feeds, [String? uid]) {
  return feeds
      .map((post) {
        switch (post.type) {
          case Create.quote:
            return FeedView(
              post,
              uid: uid ?? post.uid,
              kind: FeedKind.quoted,
              created: post.createdAt,
              actor: uctrl.dataMapping[post.uid],
              parent: pctrl.dataMapping[post.pid],
              rid: getRowId(kind: FeedKind.quoted, pid: post.id),
            );

          case Create.reply:
            return FeedView(
              post,
              uid: uid ?? post.uid,
              kind: FeedKind.replied,
              created: post.createdAt,
              actor: uctrl.dataMapping[post.uid],
              parent: pctrl.dataMapping[post.pid],
              rid: getRowId(kind: FeedKind.replied, pid: post.id),
            );

          default:
            return FeedView(
              post,
              uid: uid ?? post.uid,
              created: post.createdAt,
              rid: getRowId(pid: post.id),
            );
        }
      })
      .whereType<FeedView>()
      .toList();
}

Map<String, Reaction> followActions(
  List<Reaction> actions,
  FnP<Reaction, String> selector,
) => {for (final action in actions) selector(action): action};

AsList getKeys(List<Reaction> actions, FnP<Reaction, String> selector) =>
    actions.map(selector).toSet().toList();
