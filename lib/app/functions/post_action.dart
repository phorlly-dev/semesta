import 'package:flutter/rendering.dart';

enum ComposerType {
  post, // new post
  reply, // replying to another post
  repost, // reposting with/without comment
  quote, // quoting another post (optional)
}

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
      default:
        onPost.call();
    }
  }

  String getActionLabel() {
    switch (type) {
      case ComposerType.reply:
        return 'Reply';
      case ComposerType.repost:
        return 'Repost';
      default:
        return 'Post';
    }
  }

  String getHeaderTitle() {
    switch (type) {
      case ComposerType.reply:
        return 'Reply to Post';
      case ComposerType.repost:
        return 'Repost';
      default:
        return 'Create Post';
    }
  }

  String getLabel() {
    switch (type) {
      case ComposerType.reply:
        return 'Post your reply';
      case ComposerType.repost:
        return 'Add a comment...';
      default:
        return "What's new?";
    }
  }
}
