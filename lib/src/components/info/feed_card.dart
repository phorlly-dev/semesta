// import 'package:flutter/material.dart';
// import 'package:semesta/public/extensions/extension.dart';
// import 'package:semesta/public/extensions/model_extension.dart';
// import 'package:semesta/public/functions/option_modal.dart';
// import 'package:semesta/public/helpers/feed_view.dart';
// import 'package:semesta/public/helpers/utils_helper.dart';
// import 'package:semesta/src/components/global/media_gallery.dart';
// import 'package:semesta/src/components/post/actions_bar.dart';
// import 'package:semesta/src/widgets/sub/break_section.dart';

// class FeedCard extends StatelessWidget {
//   final bool primary;
//   final FeedStateView state;
//   const FeedCard(this.state, {super.key, this.primary = true});

//   @override
//   Widget build(BuildContext context) {
//     final options = OptionModal(context);

//     final s = state.status;
//     final c = state.content;
//     final a = state.actions;

//     final model = c.feed;
//     final parent = c.parent;
//     final media = model.media;

//     final author = s.author;
//     final actor = c.actor;
//     final authed = s.authed;

//     final hasParent = parent != null;
//     final hasActor = actor != null;

//     final quoted = hasParent && hasActor && model.hasQuote;
//     final commented = hasParent && model.hasComment && c.allowed;
//     final referenced = hasParent && model.hasComment && !c.allowed;

//     return Column(
//       children: [
//         RepostBanner(
//           target: a.target,
//           uid: c.uid,
//           onTap: (uid, yourself) async {
//             await context.openProfile(uid, yourself);
//           },
//         ),

//         if (commented) ...[
//           CommentCard(
//             feed: parent,
//             primary: primary,
//             onTap: (uid, yourself) async {
//               await context.openProfile(uid, yourself);
//             },
//           ),
//           SizedBox(height: 6),
//         ],

//         AnimatedBuilder(
//           animation: s,
//           builder: (context, child) {
//             return ChachedStatus(
//               model: model,
//               author: author,
//               status: referenced
//                   ? ReplyingTo(
//                       uid: parent.uid,
//                       onTap: (uid, yourself) async {
//                         await context.openProfile(uid, yourself);
//                       },
//                     )
//                   : null,
//               onProfile: () async {
//                 if (!canNavigateTo(author.id, c.uid) && !primary) return;
//                 await context.openProfile(author.id, authed);
//               },
//               onMenu: () {
//                 if (authed) {
//                   options.currentOptions(
//                     model,
//                     a.target,
//                     active: a.bookmarked,
//                     primary: primary,
//                   );
//                 } else {
//                   options.anotherOptions(
//                     model,
//                     a.target,
//                     status: s,
//                     primary: primary,
//                     name: author.name,
//                     iFollow: s.iFollow,
//                     active: a.bookmarked,
//                   );
//                 }
//               },
//             );
//           },
//         ),

//         if (media.isNotEmpty) MediaGallery(media: media, id: model.id),

//         if (quoted)
//           DisplayQuoted(quoted: parent, authed: s.authed, actor: actor),

//         ActionsBar(a),
//         const BreakSection(),
//       ],
//     );
//   }
// }
