import 'package:flutter/rendering.dart';

enum ComposerType { post, reply, quote }

class PostAction {
  final ComposerType type;
  PostAction(this.type);

  void onSubmit({
    required VoidCallback onPost,
    required VoidCallback onQuote,
    required VoidCallback onReply,
  }) {
    switch (type) {
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
    switch (type) {
      case ComposerType.reply:
        return 'Reply';
      case ComposerType.quote:
        return 'Repost';
      default:
        return 'Post';
    }
  }

  String getHeaderTitle() {
    switch (type) {
      case ComposerType.reply:
        return 'Reply to Post';
      case ComposerType.quote:
        return 'Repost';
      default:
        return 'Create Post';
    }
  }

  String getLabel() {
    switch (type) {
      case ComposerType.reply:
        return 'Post your reply';
      case ComposerType.quote:
        return 'Add a comment...';
      default:
        return "What's new?";
    }
  }
}
