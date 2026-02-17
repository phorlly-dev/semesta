import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/services/cached_service.dart';
import 'package:semesta/public/functions/option_modal.dart';
import 'package:semesta/public/functions/theme_manager.dart';
import 'package:semesta/public/functions/visible_option.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

enum MessageType { info, error, success }

extension BuildContextX on BuildContext {
  /// A helper method to navigate to a profile page, with an option to indicate if it's the user's own profile.
  AsWait openProfile(String uid, bool yourself) async {
    await pushNamed(
      routes.profile.name,
      pathParameters: {'id': uid},
      queryParameters: {'yourself': yourself.toString()},
    );
  }

  /// A helper method to navigate to a feed detail page by its ID.
  AsWait openById(RouteNode route, String id) async {
    await pushNamed(route.name, pathParameters: {'id': id});
  }

  /// A helper method to navigate to a follow list page (followers or following) with the specified user ID and type.
  AsWait openFollow(
    RouteNode route,
    String id, {
    String name = '',
    int idx = 0,
  }) => pushNamed(
    route.name,
    pathParameters: {'id': id},
    queryParameters: {'name': name, 'index': idx.toString()},
  );

  /// A helper method to navigate to a feed detail page by its ID, with an optional index parameter for comments or media.
  AsWait openPreview(RouteNode route, String id, [int idx = 0]) async {
    await pushNamed(
      route.name,
      pathParameters: {'id': id},
      queryParameters: {'index': idx.toString()},
    );
  }

  /// Follow state renderer, used to determine the follow/unfollow button state based on the current relationship with the user.
  FollowState renderedFollow(Follow type) => FollowState.render(this, type);

  /// Location and Theme getters, used to easily access the current route location and theme data from the context.
  String get location => GoRouterState.of(this).matchedLocation;

  TextTheme get texts => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;

  /// ThemeMode getter and toggle method, used to get the current theme mode and toggle between light and dark themes.
  ThemeMode get themeMode => watch<ThemeManager>().themeMode;
  void toggleTheme() => read<ThemeManager>().toggleTheme(this);

  /// Media picker methods, used to open the media picker for selecting images or videos, with various configuration options.
  AsWait mediaPicker({
    bool tapRecording = true,
    bool enableRecording = true,
    PickMedia from = PickMedia.gallery,
    FlashMode flashMode = FlashMode.off,
    ImageFormatGroup formatGroup = ImageFormatGroup.unknown,
    CameraLensDirection lensDirection = CameraLensDirection.back,
  }) => grepo.mediaPicker(
    this,
    from: from,
    flashMode: flashMode,
    formatGroup: formatGroup,
    tapRecording: tapRecording,
    lensDirection: lensDirection,
    enableRecording: enableRecording,
  );

  /// A helper method to open the image picker for selecting images, with various configuration options.
  AsWait imagePicker(
    String key, {
    int width = 240,
    int height = 240,
    bool editable = true,
    bool tapRecording = false,
    bool enableRecording = false,
    PickMedia from = PickMedia.gallery,
    FlashMode flashMode = FlashMode.off,
    ImageFormatGroup formatGroup = ImageFormatGroup.unknown,
    CameraLensDirection lensDirection = CameraLensDirection.back,
  }) => grepo.imagePicker(
    this,
    key,
    from: from,
    width: width,
    height: height,
    editable: editable,
    flashMode: flashMode,
    formatGroup: formatGroup,
    tapRecording: tapRecording,
    lensDirection: lensDirection,
    enableRecording: enableRecording,
  );

  Color get hintColor => theme.hintColor;
  Color get cardColor => theme.cardColor;
  Color get errorColor => colors.error;
  Color get primaryColor => colors.primary;
  Color get outlineColor => colors.outline;
  Color get secondaryColor => colors.secondary;
  Color get defaultColor => theme.scaffoldBackgroundColor;
  Color get dividerColor => theme.dividerColor.withValues(alpha: 0.5);
  Color? get navigatColor => theme.bottomNavigationBarTheme.backgroundColor;

  VisibleOption get _tap => VisibleOption(this);
  IconData toIcon(Visible v) => _tap.getIcon(v);
  void openVisible(Visible option, [ValueChanged<Visible>? onChanged]) {
    _tap.showModal(VisibleToPost.render(option).option, onChanged);
  }

  OptionModal get _open => OptionModal(this);
  void openRepost(ActionsView actions) => _open.repostOptions(actions);
  void openMedia({
    VoidCallback? onSave,
    VoidCallback? onShare,
    VoidCallback? onReport,
  }) => _open.mediaOptions(onSave, onShare, onReport);

  void openCurrent(ActionsView actions, {bool profiled = false}) {
    _open.currentOptions(actions, profiled: profiled);
  }

  void openTarget(
    StatusView status,
    ActionsView actions, {
    bool profiled = true,
  }) => _open.targetOptions(status, actions, profiled: profiled);

  void openShare(ActionsView actions) => _open.shareOptions(actions);

  /// A helper method to show a SnackBar with a message, color-coded by message type (info, success, error),
  /// and automatically dismissing after a specified duration.
  void alert(
    String message, {
    int autoClose = 3,
    double textSize = 16,
    MessageType type = MessageType.info,
  }) {
    final color = switch (type) {
      MessageType.success => Colors.lightGreen[800],
      MessageType.error => Colors.redAccent[400],
      MessageType.info => Colors.blueAccent[400],
    };

    final snack = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      duration: Duration(seconds: autoClose),
    );

    ScaffoldMessenger.of(this).showSnackBar(snack);
  }

  /// A helper method to show a modal bottom sheet with a list of options, used for various actions like reposting,
  /// sharing, or viewing media details.
  Wait<T?> openSheet<T extends Object>({
    List<Widget> children = const [],
    MainAxisSize size = MainAxisSize.min,
  }) => showModalBottomSheet<T>(
    context: this,
    backgroundColor: theme.cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DirectionY(
        size: size,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          ...children,
        ],
      ),
    ),
  );

  /// A helper method to show a confirmation dialog with customizable title, content, and actions,
  /// used for confirming destructive actions like deleting a post or unfollowing a user.
  Wait<T?> dialog<T extends Object>({
    Color? color,
    String? label,
    String? title,
    bool full = false,
    bool hidable = false,
    bool hasAction = true,
    VoidCallback? onConfirm,
    IconData icon = Icons.delete,
    List<Widget> children = const [],
    MainAxisSize size = MainAxisSize.min,
  }) => showDialog<T>(
    context: this,
    fullscreenDialog: full,
    barrierDismissible: hidable,
    builder: (context) => AlertDialog(
      title: title != null ? Text(title, textAlign: TextAlign.center) : null,
      content: SingleChildScrollView(
        child: Form(
          key: GlobalKey<FormState>(),
          child: DirectionY(size: size, children: children),
        ),
      ),
      actions: hasAction
          ? [
              TextButton.icon(
                onPressed: () => context.pop(),
                icon: Icon(Icons.close, color: context.hintColor),
                label: Text(
                  'Cancel',
                  style: TextStyle(color: context.hintColor),
                ),
              ),
              TextButton.icon(
                onPressed: onConfirm,
                icon: Icon(icon, color: color),
                label: Text(label ?? 'Yes', style: TextStyle(color: color)),
              ),
            ]
          : null,
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
    ),
  );
}
