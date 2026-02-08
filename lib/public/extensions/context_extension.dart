import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/repositories/generic_repository.dart';
import 'package:semesta/public/functions/option_modal.dart';
import 'package:semesta/public/functions/theme_manager.dart';
import 'package:semesta/public/functions/visible_option.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

extension BuildContextX on BuildContext {
  AsWait openProfile(String uid, bool yourself) async {
    await pushNamed(
      routes.profile.name,
      pathParameters: {'id': uid},
      queryParameters: {'yourself': yourself.toString()},
    );
  }

  AsWait openById(RouteNode route, String id) async {
    await pushNamed(route.name, pathParameters: {'id': id});
  }

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

  AsWait openPreview(RouteNode route, String id, [int idx = 0]) async {
    await pushNamed(
      route.name,
      pathParameters: {'id': id},
      queryParameters: {'index': idx.toString()},
    );
  }

  FollowState state(Follow type) => FollowState.render(this, type);
  Follow follow(bool iFollow, bool theyFollow) {
    if (iFollow) {
      return Follow.following;
    } else if (!iFollow && theyFollow) {
      return Follow.followBack;
    } else {
      return Follow.follow;
    }
  }

  String get location => GoRouterState.of(this).matchedLocation;

  ThemeData get theme => Theme.of(this);
  TextTheme get text => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  MediaQueryData get query => MediaQuery.of(this);

  ThemeMode get themeMode => watch<ThemeManager>().themeMode;
  void toggleTheme() => read<ThemeManager>().toggleTheme(this);

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
  Color get errorColor => colors.error;
  Color get primaryColor => colors.primary;
  Color get outlineColor => colors.outline;
  Color get secondaryColor => colors.secondary;
  Color get defaultColor => theme.scaffoldBackgroundColor;
  Color get dividerColor => theme.dividerColor.withValues(alpha: 0.5);
  Color? get navigatColor => theme.bottomNavigationBarTheme.backgroundColor;

  double get width => query.size.width;
  double get height => query.size.height;

  VisibleOption get _tap => VisibleOption(this);
  IconData icon(Visible v) => _tap.getIcon(v);
  void show(Visible option, {ValueChanged<Visible>? onChanged}) {
    _tap.showModal(VisibleToPost.render(option).option, onChanged);
  }

  OptionModal get _open => OptionModal(this);
  void repost(ActionsView actions) => _open.repostOptions(actions);
  void image(String path, ProgressDialog pd) => _open.imageOptions(path, pd);

  void current(ActionsView actions, {bool profiled = false}) {
    _open.currentOptions(actions, profiled: profiled);
  }

  void target(StatusView status, ActionsView actions, {bool profiled = true}) {
    _open.tagetOptions(status, actions, profiled: profiled);
  }

  void share(ActionsView actions) => _open.shareOptions(actions);

  AsWait sheet({
    List<Widget> children = const [],
    MainAxisSize mainAxisSize = MainAxisSize.min,
  }) => showModalBottomSheet(
    context: this,
    backgroundColor: theme.cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DirectionY(
        mainAxisSize: mainAxisSize,
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
}
