import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:semesta/app/services/cached_service.dart';
import 'package:semesta/public/extensions/file_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/app/services/storage_service.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class GenericRepository extends IStorageService {
  Wait<bool> dataExisting(String value) {
    return existing(mentions, value.toLowerCase());
  }

  Wait<String> uniqueName(String name) async {
    var uname = name;
    while (await dataExisting(uname)) {
      uname = name.toUsername;
    }

    return uname;
  }

  Wait<bool> existing(String col, String doc) {
    return db.collection(col).doc(doc).get().then((value) => value.exists);
  }

  Wait<Media?> pushFile(
    String path, [
    File? file,
    StoredIn type = StoredIn.image,
  ]) async {
    if (file == null) return null;
    return switch (type) {
      StoredIn.avatar => uploadFile(
        file,
        path.setPath(StoredIn.avatar),
        file.setName(StoredIn.avatar),
      ),
      StoredIn.image => uploadFile(
        file,
        path.setPath(StoredIn.image),
        file.setName(StoredIn.image),
      ),
      StoredIn.video => uploadFile(
        file,
        path.setPath(StoredIn.video),
        file.setName(StoredIn.video),
      ),
      StoredIn.cover => uploadFile(
        file,
        path.setPath(StoredIn.cover),
        file.setName(StoredIn.cover),
      ),
      StoredIn.thumbnail => uploadFile(
        file,
        path.setPath(StoredIn.thumbnail),
        file.setName(StoredIn.thumbnail),
      ),
    };
  }

  Wait<Media?> uploadVideoWithThumbnail(String path, File videoFile) async {
    // 1. Gen thumbnail
    final thumbFile = await genThumbnail(videoFile);
    if (thumbFile == null) return null;

    // 2. Upload thumbnail
    final thumb = await pushFile(path, thumbFile, StoredIn.thumbnail);
    if (thumb == null) return null;

    // 3. Upload video
    final videoUrl = await pushFile(path, videoFile, StoredIn.video);
    if (videoUrl == null) return null;

    // 5. Final Media
    return Media(
      path: videoUrl.path,
      url: videoUrl.url,
      type: MediaType.video,
      others: [thumb.url, thumb.path],
    );
  }

  Waits<Media> uploadMedia(String path, [List<AssetEntity>? assets]) async {
    List<Media> medialist = [];
    final files = assets ?? this.assets.toList();
    if (files.isEmpty) return const [];

    for (final asset in files.toList()) {
      final file = await asset.file;
      if (file == null) continue;

      final ext = file.getExtension;
      final img = ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
      final vid = ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext);

      if (!img && !vid) continue;

      final url = img
          ? await pushFile(path, file)
          : await uploadVideoWithThumbnail(path, file);

      if (url == null || url.url.isEmpty) continue;

      medialist.add(
        Media(
          path: url.path,
          url: url.url,
          others: url.others,
          type: img ? MediaType.image : MediaType.video,
        ),
      );
    }

    return medialist.toList();
  }

  AsWait mediaPicker(
    BuildContext context, {
    bool tapRecording = false,
    bool enableRecording = false,
    PickMedia from = PickMedia.gallery,
    FlashMode flashMode = FlashMode.off,
    ImageFormatGroup formatGroup = ImageFormatGroup.unknown,
    CameraLensDirection lensDirection = CameraLensDirection.back,
  }) => handler(() async {
    switch (from) {
      case PickMedia.camera:
        final asset = await pickCamera(
          context,
          enableRecording: enableRecording,
          flashMode: flashMode,
          formatGroup: formatGroup,
          lensDirection: lensDirection,
          tapRecording: tapRecording,
        );
        if (asset != null) assets.add(asset);
        break;

      case PickMedia.gallery:
        final media = await pickMedia(context);
        if (media.isEmpty) return;

        // --- Prevent duplicates ---
        if (unique(media, assets)) assets.addAll(media);
        break;
    }
  }, message: "Failed to pick media");

  AsWait imagePicker(
    BuildContext context,
    String key, {
    int width = 240,
    int height = 240,
    bool editable = false,
    bool tapRecording = false,
    bool enableRecording = false,
    PickMedia from = PickMedia.gallery,
    FlashMode flashMode = FlashMode.off,
    ImageFormatGroup formatGroup = ImageFormatGroup.unknown,
    CameraLensDirection lensDirection = CameraLensDirection.back,
  }) => handler(() async {
    // Get the image file based on source
    final image = await _fromSource(
      context,
      from,
      enableRecording: enableRecording,
      flashMode: flashMode,
      formatGroup: formatGroup,
      lensDirection: lensDirection,
      tapRecording: tapRecording,
    );
    if (image == null) return;

    // Validate file size
    if (!image.maxSize(5)) {
      CustomToast.warning('Image must be smaller than 5MB');
      return;
    }

    // Check if context is still mounted before proceeding
    if (!context.mounted) return;

    // Process and cache the image
    return _options(
      context,
      image,
      key,
      editable: editable,
      width: width,
      height: height,
    );
  }, message: 'Failed to pick image');

  /// Retrieves image from the specified source
  Wait<File?> _fromSource(
    BuildContext context,
    PickMedia from, {
    bool tapRecording = true,
    bool enableRecording = true,
    FlashMode flashMode = FlashMode.off,
    CameraLensDirection lensDirection = CameraLensDirection.back,
    ImageFormatGroup formatGroup = ImageFormatGroup.unknown,
  }) async {
    switch (from) {
      case PickMedia.camera:
        final asset = await pickCamera(
          context,
          enableRecording: enableRecording,
          flashMode: flashMode,
          formatGroup: formatGroup,
          lensDirection: lensDirection,
          tapRecording: tapRecording,
        );
        return await asset?.file;

      case PickMedia.gallery:
        return await pickImage();
    }
  }

  /// Processes (crops if needed) and caches the image
  AsWait _options(
    BuildContext context,
    File image,
    String key, {
    required int width,
    required int height,
    required bool editable,
  }) async {
    editable
        ? await imagedCropper(
            context,
            image,
            width: width,
            height: height,
            onCropped: (value) => cacheFor(key).value = value,
          )
        : cacheFor(key).value = image;
  }
}
