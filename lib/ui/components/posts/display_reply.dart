// import 'package:flutter/material.dart';
// import 'package:semesta/app/functions/option_modal.dart';
// import 'package:semesta/app/utils/helper.dart';
// import 'package:semesta/ui/components/global/content_post_layer.dart';
// import 'package:semesta/ui/components/global/footer_post_layer.dart';
// import 'package:semesta/ui/components/users/user_info.dart';
// import 'package:semesta/ui/widgets/avatar_animation.dart';
// import 'package:semesta/ui/widgets/follow_button.dart';

// class DisplayReply extends StatelessWidget {
//   final CardVM vm;
//   const DisplayReply({super.key, required this.vm});

//   @override
//   Widget build(BuildContext context) {
//     final options = OptionModal(context);
//     final dividerColor = Theme.of(context).dividerColor.withValues(alpha: 0.5);
//     return AnimatedBuilder(
//       animation: vm,
//       builder: (ctx, cld) {
//         final header = vm.header;
//         final footer = vm.footer;
//         final content = vm.content;

//         final parent = content.parent;
//         final post = content.post;

//         return Padding(
//           padding: const EdgeInsets.only(left: 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (parent != null)
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // LEFT GUTTER (avatar + connector)
//                     SizedBox(
//                       width: 56,
//                       child: Column(
//                         children: [
//                           AvatarAnimation(imageUrl: parent.userAvatar),
//                           Container(width: 2, color: dividerColor, height: 400),
//                         ],
//                       ),
//                     ),

//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const SizedBox(width: 6),
//                               DisplayName(data: parent.displayName),
//                               SizedBox(width: 6),
//                               Status(created: parent.createdAt, hasIcon: false),

//                               Spacer(),
//                               Row(
//                                 children: [
//                                   // Show follow button only when viewing someone else
//                                   if (!header.owned)
//                                     FollowButton(
//                                       state: resolveState(
//                                         header.iFollow,
//                                         header.theyFollow,
//                                       ),
//                                       onPressed: () {},
//                                     ),

//                                   IconButton(
//                                     icon: const Icon(Icons.more_vert_outlined),
//                                     onPressed: () {
//                                       if (header.owned) {
//                                         options.currentOptions(
//                                           parent.id,
//                                           parent.userId,
//                                           isActive: footer.saved,
//                                           isPrivate: true,
//                                         );
//                                       } else {
//                                         options.anotherOptions(
//                                           parent,
//                                           isFollowing: header.iFollow,
//                                           isActive: footer.saved,
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),

//                           ContentPostLayer(post: parent),

//                           FooterPostLayer(vm: footer),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AvatarAnimation(imageUrl: post.userAvatar),

//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const SizedBox(width: 6),
//                             DisplayName(data: post.displayName),
//                             SizedBox(width: 6),
//                             Status(created: post.createdAt, hasIcon: false),

//                             Spacer(),
//                             Row(
//                               children: [
//                                 // Show follow button only when viewing someone else
//                                 if (!header.owned)
//                                   FollowButton(
//                                     state: resolveState(
//                                       header.iFollow,
//                                       header.theyFollow,
//                                     ),
//                                     onPressed: () {},
//                                   ),

//                                 IconButton(
//                                   icon: const Icon(Icons.more_vert_outlined),
//                                   onPressed: () {
//                                     if (header.owned) {
//                                       options.currentOptions(
//                                         post.id,
//                                         post.userId,
//                                         isActive: footer.saved,
//                                         option: post.visibility,
//                                         isPrivate: true,
//                                       );
//                                     } else {
//                                       options.anotherOptions(
//                                         post,
//                                         isFollowing: header.iFollow,
//                                         isActive: footer.saved,
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),

//                         ContentPostLayer(post: post),

//                         FooterPostLayer(vm: footer),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
