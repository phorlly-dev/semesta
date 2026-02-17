import 'package:get/get.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension CacherX<T extends HasAttributes> on Cacher<T> {
  /// Replace the entire list of items in the cache with a new list, and then refresh the state.
  void set(List<T> initing) {
    assignAll(List<T>.from(initing));
    refresh();
  }

  /// Merge incoming items with existing ones based on their `currentId`,
  /// replacing existing items with the same ID, and then refresh the state.
  void merge(List<T> incoming) {
    if (incoming.isEmpty) return;

    // Build lookup from existing items
    final map = <String, T>{for (final item in this) item.currentId: item};

    // Insert / replace with incoming
    for (final item in incoming) {
      map[item.currentId] = item;
    }

    // Sort (newest first, or whatever your rule is)
    final merged = map.values.toList().sortOrder;

    assignAll(merged);
    refresh();
  }

  /// Append items to the existing list without replacing, and then refresh the state.
  void append(List<T> incoming) => addAll(incoming);
}

extension ListX<T extends HasAttributes> on List<T> {
  /// Sort a list of items by their `created` timestamp in descending order (newest first).
  List<T> get rankChronological {
    final list = [...this];
    list.sort((a, b) {
      final dateA = a.created;
      final dateB = b.created;

      // Handle null dates safely
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1; // null dates go to end
      if (dateB == null) return -1;

      return dateB.compareTo(dateA);
    });

    return list;
  }

  /// A helper method to rank items based on their age and a random jitter, used for feed ranking.
  List<T> rankFeed(int seed) {
    final copy = [...this];
    copy.sort((a, b) {
      final ra = _rank(a, seed);
      final rb = _rank(b, seed);

      return rb.compareTo(ra);
    });

    return copy;
  }

  /// A helper method to calculate a ranking score for an item based on its age and a random jitter, used for feed ranking.
  double _rank(T p, int seed) {
    final createdAt = p.created ?? now;
    final ageHours = now.difference(createdAt).inMinutes / 60;

    final base = 1 / (1 + ageHours); // freshness
    final jitter = ((p.currentId.hashCode ^ seed) & 0xffff) / 0xffff;

    return base * 0.6 + jitter * 0.4;
  }

  /// Sort a list of items by their `created` timestamp in descending order (newest first).
  List<T> get sortOrder {
    final list = [...this];
    list.sort((a, b) => b.created?.compareTo(a.created ?? now) ?? 0);

    return list;
  }
}

extension FeedListX on List<Feed> {
  /// Create a list of [FeedView] by matching the feeds with their parent
  /// and actor information from the controllers, and then applying the provided reactions to determine the action state for each feed.
  List<FeedView> fromActions({
    String? uid,
    FeedKind type = FeedKind.posts,
    List<Reaction> actions = const [],
  }) => map((feed) {
    final action = actions.followMe((value) => value.sid);
    return FeedView.fromState(
      feed,
      uid: uid,
      kind: type,
      action: action[feed.id],
    );
  }).toList().sortOrder;

  /// Create a list of [FeedView] by matching the feeds with their parent and actor information from the controllers.
  List<FeedView> fromFeeds([String? uid]) => map((post) {
    return switch (post.type) {
      Create.quote => FeedView(
        post,
        kind: FeedKind.quotes,
        created: post.createdAt,
        uid: uid ?? post.uid,
        rid: post.toId(kind: FeedKind.quotes),
      ),

      Create.reply => FeedView(
        post,
        kind: FeedKind.replies,
        created: post.createdAt,
        uid: uid ?? post.uid,
        rid: post.toId(kind: FeedKind.replies),
      ),

      Create.post => FeedView(
        post,
        rid: post.toId(),
        created: post.createdAt,
        uid: uid ?? post.uid,
      ),
    };
  }).whereType<FeedView>().toList().sortOrder;
}

extension AuthorListX on List<Author> {
  /// Create a list of [AuthedView<Author>] by matching the authors with the provided reactions.
  List<AuthedView> fromFollow(
    List<Reaction> actions,
    Defo<Reaction, String> selector,
  ) => map((user) {
    final action = actions.followMe(selector)[user.id];
    if (action == null) return null;

    return AuthedView(user, action);
  }).whereType<AuthedView>().toList();
}

extension ReactionListX on List<Reaction> {
  /// Create a mapping of reactions that match the selector, keyed by the value returned by the selector.
  Mapper<Reaction> followMe(Defo<Reaction, String> selector) {
    return getMap<Reaction>(this, selector);
  }

  /// Extract the keys of reactions that match the selector, returning a list of those keys.
  AsList toKeys(Defo<Reaction, String> selector) => map(selector).toArray;
}

extension IterableX<T> on Iterable<T> {
  /// Convert an Iterable to a List with unique elements, preserving order.
  List<T> get toArray => toSet().toList();
}
