import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:croppy/croppy.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:semesta/app/controllers/highlight_controller.dart';
import 'package:semesta/app/models/hashtag.dart';
import 'package:semesta/app/models/mention.dart';
import 'package:semesta/public/extensions/file_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

typedef Filer = Rxn<File>;

enum PickMedia { camera, gallery }

abstract mixin class ICachedService {
  final element = ''.obs;
  final loading = false.obs;
  final mentioned = false.obs;
  final hashtaged = false.obs;
  final input = HighlightController();

  final rand = Random();
  late final Dio dio = Dio();
  final assets = <AssetEntity>[].obs;
  final Mapper<Filer> _cache = {};

  bool get showPanel {
    final has = element.value.isNotEmpty;
    if ((mentioned.value || hashtaged.value || has) && !loading.value) {
      return true;
    } else {
      return false;
    }
  }

  CancelToken? _cancelToken;
  Filer cacheFor(String key) {
    return _cache.putIfAbsent(key, () => Filer());
  }

  void clearFor(String key) {
    final cache = cacheFor(key);

    cache.value = null;
    cache.refresh();
  }

  String getRandom(AsList items) {
    if (items.isEmpty) return 'unknown';
    return items[rand.nextInt(items.length)];
  }

  Waits<LocationSuggestion> fetchPlaces(String input) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    // cities
    final res = await dio.get(
      http,
      cancelToken: _cancelToken,
      queryParameters: {'input': input, 'types': '(cities)', 'key': api},
    );

    final sf = 'structured_formatting';
    return (res.data['predictions'] as List)
        .map(
          (p) => LocationSuggestion(
            p[sf]['main_text'],
            p[sf]['secondary_text'] ?? '',
            placeId: p['place_id'],
          ),
        )
        .cast<LocationSuggestion>()
        .toList();
  }

  AsWait getFile(String url, Defox<int, int, void>? onProgress) async {
    // Download
    final res = await dio.get(
      url,
      onReceiveProgress: onProgress,
      options: Options(responseType: ResponseType.bytes, followRedirects: true),
    );

    // Save to gallery
    final state = await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(res.data),
      quality: 100,
      isReturnImagePathOfIOS: true,
      name: url.contains('.mp4') ? 'VIDEO'.toName : 'IMAGE'.toName,
    );

    // Feedback
    if (state["isSuccess"] == false) throw StateError('Failed to save image');
  }

  AsWait imagedCropper(
    BuildContext context,
    File value, {
    ValueChanged<File>? onCropped,
    int width = 240,
    int height = 240,
  }) => showAdaptiveImageCropper(
    context,
    imageProvider: FileImage(value),
    allowedAspectRatios: [CropAspectRatio(width: width, height: height)],
    postProcessFn: (result) async {
      final file = await _formatedFile(result, value.getName);
      onCropped?.call(file);

      return result;
    },
  );

  Wait<File?> genThumbnail(File file) => handler(() async {
    final dir = await getTemporaryDirectory();
    final path = await VideoThumbnail.thumbnailFile(
      video: file.path,
      thumbnailPath: dir.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 720, // keep reasonable
      quality: 75,
      timeMs: 1000, // ⏱️ 1s into the video
    );

    return path != null ? File(path) : null;
  }, message: 'Failed to ganerate thumbnail');

  bool unique(List<AssetEntity> from, List<AssetEntity> to) {
    bool has = false;
    for (final f in from) {
      if (!to.any((t) => t.id == f.id)) {
        has = true;
      }
    }

    return has;
  }

  Timer? _debounce;
  void onValChanged(
    String value, {
    ValueChanged<List<Mention>>? onMetion,
    ValueChanged<List<Hashtag>>? onHashtag,
  }) {
    _debounce?.cancel();
    final cursor = _cursor;
    if (cursor < 0) return;

    final mentions = <Mention>[];
    final hastags = <Hashtag>[];
    _debounce = Timer(Durations.medium2, () async {
      loading.value = true;
      try {
        element.value = '';
        final prefix = value.trigger(cursor);
        final text = value.substring(0, cursor);

        if (prefix == '@') {
          mentioned.value = true;
          hashtaged.value = false;

          final match = text.matchedFirst(r'@(\w*)$');
          if (match != null) {
            final groped = match.group(1)!;
            element.value = '@$groped';
            mentions.addAll(await uctrl.loadMentions(groped));
            onMetion?.call(mentions);
          }
        } else if (prefix == '#') {
          hashtaged.value = true;
          mentioned.value = false;

          final match = text.matchedFirst(r'#(\w*)$');
          if (match != null) {
            final groped = match.group(1)!;
            element.value = '#$groped';
            hastags.addAll(await pctrl.loadHashtags(groped));
            onHashtag?.call(hastags);
          }
        } else {
          hidePanel();
        }
      } catch (_) {
        mentions.clear();
        hastags.clear();
        hidePanel();
      } finally {
        loading.value = false;
      }
    });
  }

  void insertToken(String value) {
    final cursor = _cursor;
    final text = input.text;

    final before = text.substring(0, cursor);
    final after = text.substring(cursor);
    final match = before.matchedFirst();
    if (match == null) return;

    final start = match.start + match.group(1)!.length;
    input.value = TextEditingValue(
      text: text.replaceRange(start, cursor, '$value ') + after,
      selection: TextSelection.collapsed(offset: start + value.length + 1),
    );

    hidePanel();
  }

  Wait<File> _formatedFile(CropImageResult cropped, [String? fileName]) async {
    final byte = await cropped.uiImage.toByteData(format: ImageByteFormat.png);
    if (byte == null) {
      throw Exception('Failed to convert cropped image to byte data');
    }

    final temp = await Directory.systemTemp.createTemp();
    final file = File('${temp.path}/${fileName ?? 'avatar.png'}');
    await file.writeAsBytes(byte.buffer.asUint8List());

    return file;
  }

  void hidePanel() {
    hashtaged.value = false;
    mentioned.value = false;
    element.value = '';
  }

  int get _cursor {
    final selection = input.selection;
    final cursor = selection.baseOffset;

    return cursor;
  }
}
