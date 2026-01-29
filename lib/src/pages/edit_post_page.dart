import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/layout/_layout_page.dart';
import 'package:semesta/src/components/layout/custom_app_bar.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';
import 'package:semesta/src/widgets/sub/block_overlay.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/custom_text_button.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:semesta/src/widgets/sub/loading_animated.dart';

class EditPostPage extends StatefulWidget {
  final String _pid;
  const EditPostPage(this._pid, {super.key});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late final TextEditingController _input;
  late Visible _visibleOption;
  late int _visibleId;

  @override
  void initState() {
    super.initState();

    final post = pctrl.dataMapping[widget._pid];
    if (post != null) {
      _visibleOption = post.visible;
      _input = TextEditingController(text: post.title);
      _visibleId = context.tap.mapVisibleToId(post.visible);
    } else {
      _input = TextEditingController();
      _visibleOption = Visible.everyone;
      _visibleId = 1;
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
        return const LoadingAnimated(cupertino: true);
      }

      final isLoading = pctrl.isLoading.value;
      final hasText = pctrl.message.value.isNotEmpty;

      return Stack(
        children: [
          LayoutPage(
            header: CustomAppBar(
              middle: const Text('Edit Post'),
              end: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CustomTextButton(
                  label: isLoading ? 'Updating…' : 'Update',
                  bgColor: hasText ? Colors.green : Colors.blueGrey,
                  textColor: Colors.white,
                  onPressed: hasText
                      ? () async {
                          final updated = post.copy(
                            edited: true,
                            title: _input.text.trim(),
                            visible: _visibleOption,
                          );

                          await pctrl.saveChange(post, updated.to());
                          if (context.mounted) context.pop();
                          await pctrl.reloadPost;
                        }
                      : null,
                ),
              ),
            ),

            content: DirectionX(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              children: [
                AvatarAnimation(user.avatar),
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
                  '${_visibleOption.name.capitalize} can reply',
                  icon: context.tap.mapToIcon(_visibleOption),
                  sizeIcon: 18,
                  canPop: false,
                  color: Colors.blueAccent,
                  style: context.text.bodyMedium?.copyWith(
                    color: Colors.blueAccent[100],
                  ),
                  onTap: () {
                    context.tap.showModal(
                      selected: _visibleId,
                      onSelected: (id, opt) {
                        setState(() {
                          _visibleId = id;
                          _visibleOption = opt;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),

          if (isLoading) const BlockOverlay('Updating'),
        ],
      );
    });
  }
}
