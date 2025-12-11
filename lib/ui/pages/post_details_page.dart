// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:semesta/app/routes/routes.dart';
// import 'package:semesta/core/models/post_model.dart';
// import 'package:semesta/core/models/user_model.dart';
// import 'package:semesta/ui/components/posts/post_footer.dart';
// import 'package:semesta/ui/components/posts/post_header.dart';
// import 'package:semesta/ui/components/global/_layout_page.dart';
// import 'package:semesta/ui/widgets/break_section.dart';
// import 'package:semesta/ui/widgets/custom_image.dart';
// import 'package:semesta/ui/widgets/expandable_text.dart';

// class PostDetailsPage extends StatelessWidget {
//   final UserModel user;
//   final PostModel post;
//   const PostDetailsPage({super.key, required this.user, required this.post});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutPage(
//       content: ListView(
//         children: [
//           SizedBox(height: 12),
//           PostHeader(post: post, isProfile: false),

//           if (post.content.isNotEmpty)
//             ExpandableText(text: post.content, trimLength: 89),
//           BreakSection(bold: 1, height: 2),
//           PostFooter(postId: post.id),

//           if (post.media.isNotEmpty)
//             ...post.media.map((v) {
//               return Column(
//                 children: [
//                   AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: CustomImage(
//                       image: v.display,
//                       onTap: () {
//                         context.pushNamed(
//                           Routes().imagesPreview.name,
//                           queryParameters: {'url': v.display},
//                         );
//                       },
//                     ),
//                   ),
//                   PostFooter(postId: post.id),
//                 ],
//               );
//             }),
//         ],
//       ),
//     );
//   }
// }
