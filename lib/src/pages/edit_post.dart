import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/block_overlay.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/animated_button.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';

class EditPostPage extends StatefulWidget {
  final String _pid;
  const EditPostPage(this._pid, {super.key});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late Visible _option;
  late VisibleToPost _visible;
  late final TextEditingController _input;

  @override
  void initState() {
    super.initState();

    final post = pctrl.dataMapping[widget._pid];
    if (post != null) {
      _option = post.visible;
      _visible = VisibleToPost.render(_option);
      _input = TextEditingController(text: post.title);
    } else {
      _option = Visible.everyone;
      _input = TextEditingController();
      _visible = VisibleToPost.public();
    }

    pctrl.message.value = _input.text;
  }

  @override
  void dispose() {
    _input.dispose();
    pctrl.message.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final post = pctrl.dataMapping[widget._pid];
      final user = uctrl.dataMapping[post?.uid ?? ''];

      if (post == null || user == null) {
        return const AnimatedLoader(cupertino: true);
      }

      final isLoading = pctrl.isLoading.value;
      final hasText = pctrl.message.value.isNotEmpty;

      return Stack(
        children: [
          PageLayout(
            header: AppNavBar(
              middle: const Text('Edit post'),
              end: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimatedButton(
                  label: isLoading ? 'Saving…' : 'Save',
                  bgColor: hasText ? Colors.green : Colors.blueGrey,
                  textColor: context.defaultColor,
                  onPressed: hasText
                      ? () async {
                          final updated = post.copy(
                            edited: true,
                            visible: _option,
                            title: _input.text.trim(),
                          );

                          await pctrl.saveChange(updated);
                          await pctrl.reloadPost();
                          if (context.mounted) context.pop();
                        }
                      : null,
                ),
              ),
            ),

            content: DirectionX(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              children: [
                AvatarAnimation(MediaSource.network(user.avatar)),
                const SizedBox(width: 8),

                Expanded(
                  child: TextField(
                    controller: _input,
                    autofocus: true,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "What's new?",
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    style: const TextStyle(fontSize: 16, height: 1.4),
                    onChanged: (v) => pctrl.message.value = v,
                  ),
                ),
              ],
            ),

            footer: DirectionY(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BreakSection(),

                OptionButton(
                  '${_visible.label} can reply',
                  icon: _visible.icon,
                  sizeIcon: 18,
                  canPop: false,
                  color: Colors.blueAccent,
                  style: context.text.bodyMedium?.copyWith(
                    color: Colors.blueAccent[100],
                  ),
                  onTap: () => context.show(
                    _option,
                    onChanged: (opt) {
                      setState(() {
                        _option = opt;
                        _visible = VisibleToPost.render(_option);
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),

          if (isLoading) const BlockOverlay('Saving'),
        ],
      );
    });
  }
}
