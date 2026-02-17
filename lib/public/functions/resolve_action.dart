import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/utils/type_def.dart';

class ResolveAction {
  final Create _type;
  const ResolveAction(this._type);

  void onSubmit({
    required AsDef onPost,
    required AsDef onQuote,
    required AsDef onReply,
  }) => switch (_type) {
    Create.post => onPost.call(),
    Create.reply => onReply.call(),
    Create.quote => onQuote.call(),
  };

  String get getActionLabel => switch (_type) {
    Create.post => 'Post',
    Create.reply => 'Reply',
    Create.quote => 'Repost',
  };

  String get getTitle => switch (_type) {
    Create.quote => 'Repost',
    Create.post => 'Create post',
    Create.reply => 'Reply to post',
  };

  String get getLabel => switch (_type) {
    Create.post => "What's new?",
    Create.reply => 'Post your reply',
    Create.quote => 'Add a comment...',
  };
}
