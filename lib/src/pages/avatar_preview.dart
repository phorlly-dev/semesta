import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/partials/imaged_preview.dart';
import 'package:semesta/src/widgets/main/data_binder.dart';

class AvatarPreviewPage extends StatelessWidget {
  final String _uid;
  const AvatarPreviewPage(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: uctrl.loadUser(_uid),
      builder: (_, snapshot) {
        final data = snapshot.data;
        final media = data?.media;

        return DataBinder(
          isEmpty: media == null,
          loading: data == null,
          message: 'No avatar available',
          child: ImagedPreview([media?.url ?? ''], media: [media?.path ?? '']),
        );
      },
    );
  }
}
