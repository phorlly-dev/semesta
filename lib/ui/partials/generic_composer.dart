import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/functions/post_action.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/components/posts/post_composer.dart';
import 'package:semesta/ui/widgets/actions_grouped.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/components/layouts/custom_app_bar.dart';
import 'package:semesta/ui/widgets/block_overlay.dart';
import 'package:semesta/ui/widgets/break_section.dart';
import 'package:semesta/ui/widgets/custom_text_button.dart';

class GenericComposer extends StatefulWidget {
  final ComposerType type;
  final Feed? parent;
  const GenericComposer({super.key, required this.type, this.parent});

  @override
  State<GenericComposer> createState() => _GenericComposerState();
}

class _GenericComposerState extends State<GenericComposer> {
  final _textContent = TextEditingController();
  late PostAction _action;

  int selected = 1;
  ReplyParams canReply = ReplyParams(
    icon: Icons.public,
    id: 1,
    label: 'Everyone',
    option: Visible.everyone,
    selected: true,
  );

  @override
  void initState() {
    _action = PostAction(widget.type);
    super.initState();
  }

  Future<void> _submit() async {
    final text = _textContent.text.trim();
    final files = grepo.assets.toList();
    final parent = widget.parent;

    _action.onSubmit(
      onPost: () async {
        final post = Feed(content: text, visible: canReply.option);

        await pctrl.save(post, files);
        if (mounted) context.pop();
        await pctrl.refreshPost();
      },
      onQuote: () async {
        final post = Feed(
          content: text,
          visible: canReply.option,
          pid: parent?.id ?? '',
          type: Create.quote,
        );

        await pctrl.save(post, files);
        if (mounted) context.pop();
        await pctrl.refreshPost();
      },
      onReply: () async {
        final post = Feed(
          content: text,
          visible: canReply.option,
          pid: parent?.id ?? '',
          type: Create.comment,
        );

        await pctrl.save(post, files);
        if (mounted) context.pop();
        await pctrl.refreshPost();
      },
    );
  }

  @override
  void dispose() {
    _textContent.dispose();
    grepo.assets.clear();
    pctrl.message.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final options = ReplyOption(context);

    return Obx(() {
      final author = pctrl.currentUser;
      final actor = pctrl.uCtrl.dataMapping[widget.parent?.uid ?? ''];
      final isLoading = pctrl.isLoading.value;
      final content = pctrl.message.value;
      final files = grepo.assets;

      // ✅ hide or disable button if text + files empty
      final hasContent = content.isNotEmpty || files.isNotEmpty;
      final isReply = widget.type == ComposerType.reply;
      final isRepost = widget.type == ComposerType.quote && !hasContent;

      return Stack(
        children: [
          LayoutPage(
            header: CustomAppBar(
              middle: Text(_action.getHeaderTitle()),
              end: Container(
                margin: EdgeInsets.only(right: 12),
                child: CustomTextButton(
                  onPressed: !hasContent ? null : _submit,
                  bgColor: !hasContent
                      ? Colors.lightBlueAccent
                      : Colors.blueAccent,
                  label: isLoading ? 'Posting...' : _action.getActionLabel(),
                  textColor: Colors.white,
                ),
              ),
            ),

            // ---- Main content ----
            content: PostComposer(
              audit: StatusView(author: author, actor: actor),
              content: _textContent,
              parent: widget.parent,
              assets: files.toList(),
              label: _action.getLabel(),
              onRemove: (index) => files.removeAt(index),
              isReply: isReply,
              onChanged: (value) {
                pctrl.message.value = value;
              },
            ),

            // ✅ Fixed bottom actions
            footer: Wrap(
              children: [
                // ---- Privacy row ----
                if (!isReply) ...[
                  BreakSection(bold: .3, height: 0),
                  ListTile(
                    leading: Icon(
                      canReply.icon,
                      color: isRepost
                          ? Colors.lightBlueAccent
                          : Colors.blueAccent,
                      size: 18,
                    ),
                    title: Text(
                      "${canReply.label} can reply",
                      style: text.bodyMedium?.copyWith(
                        color: isRepost
                            ? Colors.lightBlueAccent
                            : Colors.blueAccent[100],
                      ),
                    ),
                    onTap: isRepost
                        ? null
                        : () {
                            options.showModal(
                              selected: selected,
                              onSelected: (id, opt) {
                                setState(() {
                                  selected = id;
                                  canReply = options
                                      .select(selected, (id, opt) {})
                                      .firstWhere((e) => e.id == selected);
                                });
                              },
                            );
                          },
                  ),
                ],
                BreakSection(bold: .3, height: 1),

                ActionsGrouped(
                  onCamera: () => grepo.fromCamera(context),
                  onMedia: () => grepo.fromMedia(context),
                ),
              ],
            ),
          ),

          // ---- overlay ----
          isLoading ? BlockOverlay('Posting') : SizedBox.shrink(),
        ],
      );
    });
  }
}
