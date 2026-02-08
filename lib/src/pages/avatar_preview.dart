import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/partials/imaged_preview.dart';
import 'package:semesta/src/widgets/main/data_binder.dart';

class AvatarPreviewPage extends StatelessWidget {
  final String _uid;
  const AvatarPreviewPage(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = uctrl.dataMapping[_uid];
      final avatar = data?.avatar ?? '';

      return DataBinder(
        isEmpty: avatar.isEmpty,
        loading: data == null,
        message: 'No avatar available',
        child: ImagedPreview([avatar]),
      );
    });
  }
}
