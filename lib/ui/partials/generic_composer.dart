import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/post_action.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/core/repositories/generic_repository.dart';
import 'package:semesta/ui/components/posts/post_composer.dart';
import 'package:semesta/ui/components/posts/post_composer_footer.dart';
import 'package:semesta/ui/components/global/_layout_page.dart';
import 'package:semesta/ui/components/global/nav_bar_layer.dart';
import 'package:semesta/ui/widgets/block_overlay.dart';

class GenericComposer extends StatefulWidget {
  final ComposerType type;
  final PostModel? parent;
  const GenericComposer({super.key, required this.type, this.parent});

  @override
  State<GenericComposer> createState() => _GenericComposerState();
}

class _GenericComposerState extends State<GenericComposer> {
  final _controller = Get.find<PostController>();
  final _func = GenericRepository();
  final _textContent = TextEditingController();
  late PostAction _action;

  int selected = 1;
  ReplyParams canReply = ReplyParams(
    icon: Icons.public,
    id: 1,
    label: 'Everyone',
    option: PostVisibility.everyone,
    selected: true,
  );

  @override
  void initState() {
    _action = PostAction(widget.type);
    super.initState();
  }

  Future<void> _submit() async {
    final text = _textContent.text.trim();
    final files = _func.assets.toList();
    final parent = widget.parent;

    _action.onSubmit(
      onPost: () async {
        final post = PostModel(content: text, visibility: canReply.option);

        await _controller.save(post, files);
        if (mounted) context.pop();
        await _controller.many(force: true);
      },
      onQuote: () async {
        final post = PostModel(
          content: text,
          visibility: canReply.option,
          parentId: parent?.id ?? '',
          type: PostType.quote,
        );

        await _controller.save(post, files);
        if (mounted) context.pop();
        await _controller.many(force: true);
      },
      onReply: () async {
        final post = PostModel(
          content: text,
          visibility: canReply.option,
          parentId: parent?.id ?? '',
          type: PostType.reply,
        );

        await _controller.save(post, files);
        if (mounted) context.pop();
        await _controller.many(force: true);
      },
    );
  }

  @override
  void dispose() {
    _textContent.dispose();
    _func.assets.clear();
    _controller.infoMessage.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final options = ReplyOption(context);
    final user = _controller.currentUser!;

    return Obx(() {
      final isLoading = _controller.isLoading.value;
      final content = _controller.infoMessage.value;
      final files = _func.assets;

      // ✅ hide or disable button if text + files empty
      final hasContent = content.isNotEmpty || files.isNotEmpty;

      return Stack(
        children: [
          // ---- main content ----
          LayoutPage(
            header: NavBarLayer(
              middle: Text(_action.getHeaderTitle()),
              end: Container(
                margin: EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: !hasContent ? null : _submit,
                  style: TextButton.styleFrom(
                    backgroundColor: !hasContent
                        ? theme.colorScheme.outline
                        : Colors.blueAccent,
                  ),
                  child: Text(
                    isLoading ? 'Posting...' : _action.getActionLabel(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            // ---- Main content ----
            content: PostComposer(
              avatar: user.avatar,
              name: user.name,
              username: user.username,
              content: _textContent,
              assets: files.toList(),
              onRemove: (index) => files.removeAt(index),
              label: _action.getLabel(),
              parentPost: widget.parent,
              isReply: widget.type == ComposerType.reply,
              onChanged: (value) {
                _controller.infoMessage.value = value;
              },
            ),

            // ---- Privacy row ----
            popup: ListTile(
              dense: true,
              leading: Icon(canReply.icon, color: Colors.blueAccent, size: 18),
              title: Text(
                "${canReply.label} can reply",
                style: text.bodyMedium?.copyWith(color: Colors.blueAccent[100]),
              ),
              onTap: () {
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

            // ✅ Fixed bottom actions
            footer: PostComposerFooter(
              onCamera: () => _func.fromCamera(context),
              onMedia: () => _func.fromMedia(context),
            ),
          ),

          // ---- overlay ----
          isLoading ? BlockOverlay(title: 'Posting') : SizedBox.shrink(),
        ],
      );
    });
  }
}
