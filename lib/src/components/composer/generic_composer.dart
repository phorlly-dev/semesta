import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/repositories/generic_repository.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/functions/resolve_action.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/composer/post_composer.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/widgets/main/grouped_action.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/block_overlay.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/animated_button.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class GenericComposer extends StatefulWidget {
  final Feed? parent;
  final ComposerType _type;
  const GenericComposer(this._type, {super.key, this.parent});

  @override
  State<GenericComposer> createState() => _GenericComposerState();
}

class _GenericComposerState extends State<GenericComposer> {
  late ResolveAction _action;
  final _input = TextEditingController();
  var _option = Visible.everyone;
  var _visible = VisibleToPost.public();

  @override
  void initState() {
    _action = ResolveAction(widget._type);
    super.initState();
  }

  AsWait _submit() async {
    final text = _input.text.trim();
    final files = grepo.assets.toList();
    final pid = widget.parent?.id ?? '';

    _action.onSubmit(
      onPost: () async {
        final post = Feed(title: text, visible: _option);

        await pctrl.save(post, files);
        await pctrl.refreshPost();
        if (mounted) context.pop();
      },
      onQuote: () async {
        final post = Feed(
          title: text,
          visible: _option,
          pid: pid,
          type: Create.quote,
        );

        await pctrl.save(post, files);
        await pctrl.refreshPost();
        if (mounted) context.pop();
      },
      onReply: () async {
        final post = Feed(
          title: text,
          visible: _option,
          pid: pid,
          type: Create.reply,
        );

        await pctrl.save(post, files);
        await pctrl.refreshPost();
        if (mounted) context.pop();
      },
    );
  }

  @override
  void dispose() {
    _input.dispose();
    grepo.assets.clear();
    pctrl.message.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final files = grepo.assets;
      final author = pctrl.currentUser;
      final content = pctrl.message.value;
      final loading = pctrl.isLoading.value;
      final actor = pctrl.uCtrl.dataMapping[widget.parent?.uid ?? author.id];

      // ✅ hide or disable button if text + files empty
      final hasContent = content.isNotEmpty || files.isNotEmpty;
      final isReply = widget._type == ComposerType.reply;
      final isRepost = widget._type == ComposerType.quote && !hasContent;
      final color = isRepost ? Colors.lightBlueAccent : Colors.blueAccent[100];

      return Stack(
        children: [
          PageLayout(
            header: AppNavBar(
              middle: Text(_action.getTitle),
              end: Container(
                margin: EdgeInsets.only(right: 12),
                child: AnimatedButton(
                  onPressed: !hasContent ? null : _submit,
                  bgColor: !hasContent
                      ? Colors.lightBlueAccent
                      : Colors.blueAccent,
                  label: loading ? 'Posting...' : _action.getActionLabel,
                  textColor: Colors.white,
                ),
              ),
            ),

            // ---- Main content ----
            content: PostComposer(
              StatusView(author, actor: actor),
              content: _input,
              parent: widget.parent,
              assets: files.toList(),
              label: _action.getLabel,
              onRemove: (index) => files.removeAt(index),
              isReply: isReply,
              onChanged: (value) {
                pctrl.message.value = value;
              },
            ),

            // ✅ Fixed bottom actions
            footer: DirectionY(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---- Privacy row ----
                if (!isReply) ...[
                  OptionButton(
                    "${_visible.label} can reply",
                    icon: _visible.icon,
                    color: color,
                    canPop: false,
                    style: context.text.bodyMedium?.copyWith(color: color),
                    sizeIcon: 18,
                    onTap: isRepost
                        ? null
                        : () => context.show(
                            _option,
                            onChanged: (opt) {
                              setState(() {
                                _option = opt;
                                _visible = VisibleToPost.render(_option);
                              });
                            },
                          ),
                  ),
                ],
                const BreakSection(),

                GroupedAction(
                  onMedia: () => context.mediaPicker(),
                  onCamera: () => context.mediaPicker(from: PickMedia.camera),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),

          // ---- overlay ----
          if (loading) BlockOverlay('Posting'),
        ],
      );
    });
  }
}
