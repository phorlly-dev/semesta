import 'package:flutter/rendering.dart';

enum ComposerType { post, reply, quote }

class ResolveAction {
  final ComposerType _type;
  const ResolveAction(this._type);

  void onSubmit({
    required VoidCallback onPost,
    required VoidCallback onQuote,
    required VoidCallback onReply,
  }) {
    switch (_type) {
      case ComposerType.reply:
        onReply.call();
        break;

      case ComposerType.quote:
        onQuote.call();
        break;

      case ComposerType.post:
        onPost.call();
    }
  }

  String getActionLabel() {
    switch (_type) {
      case ComposerType.reply:
        return 'Reply';
      case ComposerType.quote:
        return 'Repost';
      default:
        return 'Post';
    }
  }

  String getHeaderTitle() {
    switch (_type) {
      case ComposerType.reply:
        return 'Reply to Post';
      case ComposerType.quote:
        return 'Repost';
      default:
        return 'Create Post';
    }
  }

  String getLabel() {
    switch (_type) {
      case ComposerType.reply:
        return 'Post your reply';
      case ComposerType.quote:
        return 'Add a comment...';
      default:
        return "What's new?";
    }
  }
}
