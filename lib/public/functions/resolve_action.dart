import 'package:semesta/public/utils/type_def.dart';

enum ComposerType { post, reply, quote }

class ResolveAction {
  final ComposerType _type;
  const ResolveAction(this._type);

  void onSubmit({
    required AsDef onPost,
    required AsDef onQuote,
    required AsDef onReply,
  }) => switch (_type) {
    ComposerType.post => onPost.call(),
    ComposerType.reply => onReply.call(),
    ComposerType.quote => onQuote.call(),
  };

  String get getActionLabel => switch (_type) {
    ComposerType.post => 'Post',
    ComposerType.reply => 'Reply',
    ComposerType.quote => 'Repost',
  };

  String get getTitle => switch (_type) {
    ComposerType.quote => 'Repost',
    ComposerType.post => 'Create Post',
    ComposerType.reply => 'Reply to Post',
  };

  String get getLabel => switch (_type) {
    ComposerType.post => "What's new?",
    ComposerType.reply => 'Post your reply',
    ComposerType.quote => 'Add a comment...',
  };
}
