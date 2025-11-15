import 'package:flutter/material.dart';
import 'package:semesta/ui/partials/spec/post_section.dart';
import 'package:semesta/ui/partials/spec/todo_section.dart';
import 'package:semesta/ui/partials/spec/story_section.dart';
import 'package:semesta/ui/partials/gen/scroll_view.dart';
import 'package:semesta/ui/widgets/break_section.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:semesta/app/utils/format.dart';
// import 'package:semesta/core/controllers/auth_controller.dart';
// import 'package:semesta/ui/partials/_layout.dart';
// import 'package:semesta/ui/widgets/custom_clipboard.dart';
// import 'package:semesta/ui/widgets/custom_image.dart';
// import 'package:semesta/ui/widgets/loading.dart';

class Home extends StatelessWidget {
  final String userId;
  final ScrollController? scroller;
  const Home({super.key, this.scroller, required this.userId});

  @override
  Widget build(BuildContext context) {
    return AppScrollView(
      scroller: scroller,
      hasNav: true,
      children: [
        TodoSection(userId: userId),
        BreakSection(),
        StorySection(userId: userId),
        BreakSection(),
        PostSection(),
      ],
    );
  }
}
