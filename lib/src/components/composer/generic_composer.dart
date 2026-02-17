import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/controllers/highlight_controller.dart';
import 'package:semesta/app/models/hashtag.dart';
import 'package:semesta/app/models/mention.dart';
import 'package:semesta/app/services/cached_service.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/resolve_action.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/src/components/composer/hashtag_panel.dart';
import 'package:semesta/src/components/composer/mention_panel.dart';
import 'package:semesta/src/components/composer/post_composer.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/components/layout/overlapping.dart';
import 'package:semesta/src/widgets/main/grouped_actions.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/animated_button.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class GenericComposer extends StatefulWidget {
  final Feed? parent;
  final Create _type;
  const GenericComposer(this._type, {super.key, this.parent});

  @override
  State<GenericComposer> createState() => _GenericComposerState();
}

class _GenericComposerState extends State<GenericComposer> {
  late ResolveAction _action;
  late final HighlightController _input;
  var _option = Visible.everyone;
  var _visible = VisibleToPost.public();
  final _mentions = ValueNotifier<List<Mention>>([]);
  final _hashtags = ValueNotifier<List<Hashtag>>([]);

  @override
  void initState() {
    _input = grepo.input;
    _action = ResolveAction(widget._type);
    super.initState();
  }

  void _submit() {
    final text = _input.text.trim();
    final files = grepo.assets.toList();
    final pid = widget.parent?.id ?? '';
    final hashtags = text.parseText.hashtags;
    final mentions = text.parseText.mentions;

    _action.onSubmit(
      onPost: () async {
        final post = Feed(
          title: text,
          visible: _option,
          hashtags: hashtags,
          mentions: mentions,
        );

        await pctrl.save(post, files);
        if (mounted) context.pop();
        await pctrl.refreshPost();
      },
      onQuote: () async {
        final post = Feed(
          pid: pid,
          title: text,
          visible: _option,
          type: Create.quote,
          hashtags: hashtags,
          mentions: mentions,
        );

        await pctrl.save(post, files);
        if (mounted) context.pop();
        await pctrl.refreshPost();
      },
      onReply: () async {
        final post = Feed(
          pid: pid,
          title: text,
          visible: _option,
          type: Create.reply,
          hashtags: hashtags,
          mentions: mentions,
        );

        await pctrl.save(post, files);
        if (mounted) context.pop();
        await pctrl.refreshPost();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final files = grepo.assets;
      final author = pctrl.currentUser;

      final content = pctrl.message.value;
      final loading = pctrl.isLoading.value;
      final mentioned = grepo.mentioned.value;
      final hashtaged = grepo.hashtaged.value;
      final paneled = grepo.showPanel;

      // ✅ hide or disable button if text + files empty
      final hasContent = content.isNotEmpty || files.isNotEmpty;
      final isReply = widget._type == Create.reply;
      final isRepost = widget._type == Create.quote && !hasContent;
      final color = isRepost ? Colors.lightBlueAccent : Colors.blueAccent[100];

      return Overlapping(
        loading: loading,
        message: 'Posting',
        child: PageLayout(
          color: context.cardColor,
          header: AppNavBar(
            middle: Text(_action.getTitle),
            end: AnimatedButton(
              onPressed: !hasContent ? null : _submit,
              bgColor: !hasContent ? Colors.lightBlueAccent : Colors.blueAccent,
              label: loading ? 'Posting...' : _action.getActionLabel,
              textColor: Colors.white,
            ),
          ),

          // ---- Main content ----
          content: Stack(
            children: [
              Positioned.fill(
                child: PostComposer(
                  author,
                  input: _input,
                  parent: widget.parent,
                  assets: files.toList(),
                  label: _action.getLabel,
                  onRemove: (index) => files.removeAt(index),
                  isReply: isReply,
                  onChanged: (value) {
                    pctrl.message.value = value;
                    grepo.onValChanged(
                      value,
                      onMetion: (mentions) => _mentions.value = mentions,
                      onHashtag: (hashtags) => _hashtags.value = hashtags,
                    );
                  },
                ),
              ),

              if (paneled) ...[
                Positioned(
                  top: .52.sh,
                  left: 0,
                  right: 0,
                  child: DirectionY(
                    color: context.cardColor,
                    size: MainAxisSize.min,
                    children: [
                      const BreakSection(height: 1, bold: .5),

                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: context.height * .5,
                        ),
                        child: mentioned
                            ? MentiionPanel(
                                _mentions,
                                value: grepo.element.value,
                                loading: grepo.loading.value,
                                onSelected: (value) {
                                  grepo.insertToken(value);
                                  _mentions.value = [];
                                },
                              )
                            : hashtaged
                            ? HashtagPanel(
                                hashtags: _hashtags,
                                value: grepo.element.value,
                                loading: grepo.loading.value,
                                onSelected: (value) {
                                  grepo.insertToken(value);
                                  _hashtags.value = [];
                                },
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // ✅ Fixed bottom actions
          footer: !paneled
              ? DirectionY(
                  size: MainAxisSize.min,
                  children: [
                    // ---- Privacy row ----
                    if (!isReply) ...[
                      OptionButton(
                        "${_visible.label} can reply",
                        icon: _visible.icon,
                        color: color,
                        canPop: false,
                        style: context.texts.bodyMedium?.copyWith(color: color),
                        sizeIcon: 18,
                        onTap: isRepost
                            ? null
                            : () => context.openVisible(_option, (opt) {
                                setState(() {
                                  _option = opt;
                                  _visible = VisibleToPost.render(_option);
                                });
                              }),
                      ),
                    ],
                    const BreakSection(),

                    GroupedActions(
                      onMedia: () => context.mediaPicker(),
                      onCamera: () {
                        context.mediaPicker(from: PickMedia.camera);
                      },
                    ),

                    const SizedBox(height: 18),
                  ],
                )
              : null,
        ),
      );
    });
  }

  @override
  void dispose() {
    _input.clear();
    _mentions.value = [];
    _hashtags.value = [];
    grepo
      ..hidePanel()
      ..input.clear()
      ..assets.clear();
    pctrl.message.value = '';
    super.dispose();
  }
}
