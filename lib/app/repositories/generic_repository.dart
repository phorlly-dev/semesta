import 'dart:io';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/app/services/storage_service.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class GenericRepository extends IStorageService {
  final file = Rxn<File>();
  final assets = <AssetEntity>[].obs;
  final _rand = Random();
  final faker = Faker();
  final mentions = RegExp(r'@([A-Za-z0-9_]+)');

  String getRandom(List<String> items) {
    if (items.isEmpty) return 'unknown';
    return items[_rand.nextInt(items.length)];
  }

  String get fakeName => faker.person.name();
  String get fakeTitle => faker.lorem.sentence();

  String getUname(String name) {
    // Normalize: remove spaces/special chars
    final base = name.trim().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    final suffix = now.millisecondsSinceEpoch.toString().substring(10);

    return '$base$suffix';
  }

  Future<bool> unameExists(String username) {
    return isExists(unames, username);
  }

  Future<String> getUniqueName(String name) async {
    var username = getUname(name);
    while (await unameExists(username)) {
      username = getUname(name);
    }

    return username;
  }

  Future<bool> isExists(String col, String doc) async {
    final docs = await db.collection(col).doc(doc).get();

    return docs.exists;
  }

  Future<Media?> uploadProfile(String path, File file) async {
    return uploadFile(
      file: file,
      folderName: '$avatars/$path',
      fileName: genFileName('avatar', file: file),
    );
  }

  Future<Media?> uploadImage(String path, File file) async {
    return uploadFile(
      file: file,
      folderName: '$images/$path',
      fileName: genFileName('image', file: file),
    );
  }

  Future<Media?> uploadThumbnail(String path, File file) async {
    return uploadFile(
      file: file,
      folderName: '$thumbnails/$path',
      fileName: genFileName('thumbnail', file: file),
    );
  }

  Future<Media?> uploadVideo(String path, File file) async {
    return uploadFile(
      file: file,
      folderName: '$videos/$path',
      fileName: genFileName('video', file: file),
    );
  }

  Future<Media?> uploadVideoWithThumbnail(String path, File videoFile) async {
    // 1. Gen thumbnail
    final thumbFile = await genThumbnail(videoFile);
    if (thumbFile == null) return null;

    // 2. Upload thumbnail
    final thumb = await uploadThumbnail(path, thumbFile);
    if (thumb == null) return null;

    // 3. Upload video
    final videoUrl = await uploadVideo(path, videoFile);
    if (videoUrl == null) return null;

    // 5. Final Media
    return Media(
      display: videoUrl.display,
      path: videoUrl.path,
      thumbnails: {'path': thumb.path, 'url': thumb.display},
      type: MediaType.video,
    );
  }

  Future<List<Media>> uploadMedia(
    String path, [
    List<AssetEntity>? assets,
  ]) async {
    List<Media> medialist = [];
    final files = assets ?? this.assets.toList();
    if (files.isEmpty) return [];

    for (final asset in files.toList()) {
      final file = await asset.file;
      if (file == null) continue;

      final ext = getExtension(file);
      final isImage = ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
      final isVideo = ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext);

      if (!isImage && !isVideo) continue;

      final url = isImage
          ? await uploadImage(path, file)
          : await uploadVideoWithThumbnail(path, file);

      if (url == null || url.display.isEmpty) continue;

      medialist.add(
        Media(
          path: url.path,
          display: url.display,
          thumbnails: url.thumbnails,
          type: isImage ? MediaType.image : MediaType.video,
        ),
      );
    }

    return medialist.toList();
  }

  Future<void> fromPicture() async {
    final image = await pickImage();
    if (image == null) return;

    if (!isFileSizeValid(image, maxMB: 5)) {
      CustomToast.warning('Image must be smaller than 5MB');

      return;
    }

    file.value = image;
  }

  Future<void> fromVideo() async {
    final video = await pickVideo();
    if (video == null) return;

    if (!isFileSizeValid(video)) {
      CustomToast.warning('Video must be smaller than 10MB');

      return;
    }

    file.value = video;
  }

  Future<void> fromMedia(BuildContext context) async {
    final media = await pickMedia(context);

    if (media.isEmpty) return;

    // --- Prevent duplicates ---
    if (isUnique(media, assets)) assets.addAll(media);
  }

  Future<void> fromCamera(BuildContext context) async {
    final asset = await pickFromCamera(context);

    if (asset != null) assets.add(asset);
  }
}
