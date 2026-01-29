import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/src/partials/image_preview.dart';
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
        isLoading: data == null,
        isEmpty: mediaList?.isEmpty ?? false,
        message: 'No media available',
        child: ImagePreview(
          mediaList?.map<String>((e) {
                return e.type == MediaType.image
                    ? e.display
                    : e.thumbnails['url'];
              }).toList() ??
              const [],
          id: _pid,
          initIndex: index,
        ),
      );
    });
  }
}
