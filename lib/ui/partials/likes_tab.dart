import 'package:flutter/material.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/components/global/private_post_card.dart';
import 'package:semesta/ui/widgets/keep_alive_client.dart';

class LikesTab extends StatelessWidget {
  final PostModel post;
  const LikesTab({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return KeepAliveClient(child: PrivatePostCard(post: post));
  }
}
