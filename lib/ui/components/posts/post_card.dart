// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:semesta/app/routes/routes.dart';
// import 'package:semesta/core/controllers/post_controller.dart';
// import 'package:semesta/core/models/post_model.dart';
// import 'package:semesta/ui/components/posts/post_content.dart';
// import 'package:semesta/ui/components/posts/post_footer.dart';
// import 'package:semesta/ui/components/posts/post_header.dart';
// import 'package:semesta/ui/widgets/animated.dart';
// import 'package:semesta/ui/widgets/break_section.dart';

// class PostCard extends StatelessWidget {
//   final PostModel post;
//   final bool isProfile;

//   const PostCard({super.key, required this.post, this.isProfile = false});

//   @override
//   Widget build(BuildContext context) {
//     final route = Routes();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (post.displayName.isNotEmpty && post.type == PostType.repost)
//           _displayRepost(
//             context,
//             () => context.pushNamed(
//               route.profile.name,
//               pathParameters: {'id': post.userId},
//               queryParameters: {'parent': post.id},
//             ),
//           ),

//         // --- Header ---
//         PostHeader(
//           isProfile: isProfile,
//           post: post,
//           onProfile: isProfile
//               ? null
//               : () => context.pushNamed(
//                   route.profile.name,
//                   pathParameters: {'id': post.userId},
//                   queryParameters: {'parent': post.id},
//                 ),
//           onDetails: () {},
//         ),

//         // --- Content (text or background) ---
//         PostContent(
//           id: post.id,
//           title: post.content,
//           media: post.media.toList(),
//         ),

//         // --- Footer ---
//         PostFooter(postId: post.id),
//         const BreakSection(),
//       ],
//     );
//   }

//   Widget _displayRepost(BuildContext context, VoidCallback onTap) {
//     final theme = Theme.of(context);
//     final controller = Get.find<PostController>();
//     final isOwner = controller.userCtrl.isCurrentUser(post.userId);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32),
//       child: Animated(
//         onTap: onTap,
//         child: Row(
//           spacing: 6,
//           children: [
//             Icon(Icons.autorenew_rounded, color: theme.hintColor),
//             Text(
//               isOwner ? 'You reposted' : '${post.displayName} reposted',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w500,
//                 color: theme.hintColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
