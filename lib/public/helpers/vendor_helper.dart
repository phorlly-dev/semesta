import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

List<FeedView> mapFollowActions(
  List<Feed> feeds, {
  String? uid,
  FeedKind type = FeedKind.posted,
  List<Reaction> actions = const [],
}) => feeds
    .map((feed) {
      final action = followActions(actions, (value) => value.currentId);
      return FeedView.from(feed, uid: uid, kind: type, action: action[feed.id]);
    })
    .toList()
    .sortOrder;

List<AuthedView> mapToFollow(
  List<Author> users,
  List<Reaction> reactions,
  Defo<Reaction, String> selector,
) => users
    .map((user) {
      final action = followActions(reactions, selector)[user.id];
      if (action == null) return null;

      return AuthedView(user, action);
    })
    .whereType<AuthedView>()
    .toList();

List<FeedView> mapToFeed(List<Feed> feeds, [String? uid]) => feeds
    .map((post) {
      final parent = pctrl.dataMapping[post.pid];
      final actor = uctrl.dataMapping[parent?.uid ?? ''];

      return switch (post.type) {
        Create.quote => FeedView(
          post,
          actor: actor,
          parent: parent,
          kind: FeedKind.quoted,
          created: post.createdAt,
          uid: uid ?? actor?.id ?? post.uid,
          rid: post.toId(kind: FeedKind.quoted),
        ),

        Create.reply => FeedView(
          post,
          actor: actor,
          parent: parent,
          kind: FeedKind.replied,
          created: post.createdAt,
          uid: uid ?? actor?.id ?? post.uid,
          rid: post.toId(kind: FeedKind.replied),
        ),

        Create.post => FeedView(
          post,
          created: post.createdAt,
          rid: post.toId(),
          uid: uid ?? actor?.id ?? post.uid,
        ),
      };
    })
    .whereType<FeedView>()
    .toList();

Mapper<Reaction> followActions(
  List<Reaction> actions,
  Defo<Reaction, String> selector,
) => getMap<Reaction>(actions, selector);

AsList getKeys(List<Reaction> actions, Defo<Reaction, String> selector) {
  return actions.map(selector).toSet().toList();
}
