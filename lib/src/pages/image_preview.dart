import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/partials/imaged_preview.dart';
import 'package:semesta/src/widgets/main/data_binder.dart';

class ImagePreviewPage extends StatelessWidget {
  final String _pid;
  final int index;
  const ImagePreviewPage(this._pid, {super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = pctrl.dataMapping[_pid];
      final mediaList = data?.media;

      return DataBinder(
        loading: data == null,
        isEmpty: mediaList?.isEmpty ?? false,
        message: 'No media available',
        child: ImagedPreview(
          mediaList?.map<String>((e) {
                return e.img ? e.display : e.thumbnails['url'];
              }).toList() ??
              const [],
          id: _pid,
          initIndex: index,
          media:
              mediaList?.map<String>((e) {
                return e.img ? e.path : e.thumbnails['path'];
              }).toList() ??
              const [],
        ),
      );
    });
  }
}
