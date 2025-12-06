import 'dart:io';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:semesta/app/utils/custom_toast.dart';
import 'package:semesta/app/utils/file_helper.dart';
import 'package:semesta/core/models/media_model.dart';
import 'package:semesta/core/services/storage_service.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class GenericRepository extends StorageService {
  final file = Rxn<File>();
  final assets = <AssetEntity>[].obs;
  final _rand = Random();
  final faker = Faker();
  final _help = FileHelper();
  final mentions = RegExp(r'@([A-Za-z0-9_]+)');

  String getRandom(List<String> items) {
    if (items.isEmpty) return 'unknown';
    return items[_rand.nextInt(items.length)];
  }

  String get fakeName => faker.person.name();
  String get fakeTitle => faker.lorem.sentence();

  String generateUsername(String name) {
    // Normalize: lowercase, remove spaces/special chars
    final base = name.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '_',
    );
    final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(
      10,
    );

    return '$base$suffix'.toLowerCase();
  }

  Future<bool> usernameExists(String username) async =>
      isExists('usernames', username.toLowerCase());

  Future<String> getUniqueUsername(String name) async {
    var username = generateUsername(name);
    while (await usernameExists(username)) {
      username = generateUsername(name);
    }

    return username.toLowerCase();
  }

  Future<bool> isExists(String parent, String child) async {
    final docs = await firestore.collection(parent).doc(child).get();

    return docs.exists;
  }

  Future<MediaModel?> uploadProfile(String path, File file) async {
    return uploadFile(
      folderName: '$avatars/$path',
      file: file,
      fileName: generateFileName('avatar', file: file),
    );
  }

  Future<MediaModel?> uploadImage(String path, File file) async {
    return uploadFile(
      folderName: '$images/$path',
      file: file,
      fileName: generateFileName('image', file: file),
    );
  }

  Future<MediaModel?> uploadVideo(String path, File file) async {
    return uploadFile(
      folderName: '$videos/$path',
      file: file,
      fileName: generateFileName('video', file: file),
    );
  }

  Future<List<MediaModel>> uploadMedia(
    String path, [
    List<AssetEntity>? assets,
  ]) async {
    List<MediaModel> medialist = [];
    final files = assets ?? this.assets.toList();
    if (files.isEmpty) return [];

    for (final asset in files.toList()) {
      final file = await asset.file;
      if (file == null) continue;

      final ext = _help.getExtension(file);
      final isImage = ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
      final isVideo = ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext);

      if (!isImage && !isVideo) continue;

      final url = isImage
          ? await uploadImage(path, file)
          : await uploadVideo(path, file);

      if (url == null || url.display.isEmpty) continue;

      int width = 0, height = 0;
      if (isImage) {
        final decoded = await decodeImageFromList(await file.readAsBytes());
        width = decoded.width;
        height = decoded.height;
      } else {
        final video = VideoPlayerController.file(file);
        await video.initialize();
        width = video.value.size.width.toInt();
        height = video.value.size.height.toInt();
        video.dispose();
      }

      medialist.add(
        MediaModel(
          display: url.display,
          path: url.path,
          type: isImage ? MediaType.image : MediaType.video,
          width: width,
          height: height,
        ),
      );
    }

    return medialist.toList();
  }

  Future<void> fromPicture() async {
    final image = await _help.pickImage();
    if (image == null) return;

    if (!_help.isFileSizeValid(image, maxMB: 5)) {
      CustomToast.warning('Image must be smaller than 5MB');

      return;
    }

    file.value = image;
  }

  Future<void> fromVideo() async {
    final video = await _help.pickVideo();
    if (video == null) return;

    if (!_help.isFileSizeValid(video)) {
      CustomToast.warning('Video must be smaller than 10MB');

      return;
    }

    file.value = video;
  }

  Future<void> fromMedia(BuildContext context) async {
    final media = await _help.pickMedia(context);

    if (media == [] || media.isEmpty) return;

    // --- Prevent duplicates ---
    if (_help.isUnique(media, assets)) assets.addAll(media);
  }

  Future<void> fromCamera(BuildContext context) async {
    final asset = await _help.pickFromCamera(context);

    if (asset != null) assets.add(asset);
  }
}
