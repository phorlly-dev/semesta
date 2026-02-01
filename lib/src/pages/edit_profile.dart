import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/components/user/profile_editable_header.dart';
import 'package:semesta/src/widgets/main/data_form.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/block_overlay.dart';
import 'package:semesta/src/widgets/sub/dated_picker.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';
import 'package:semesta/src/widgets/sub/inputable.dart';

class EditProfilePage extends StatefulWidget {
  final String _uid;
  const EditProfilePage(this._uid, {super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _ka = 'avatar';
  final _kc = 'cover';
  final _kf = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    final data = uctrl.dataMapping[widget._uid];
    if (data != null) uctrl.message.value = data.name;
    super.initState();
  }

  @override
  void dispose() {
    uctrl.message.value = '';
    grepo.clearFor(_ka);
    grepo.clearFor(_kc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = uctrl.dataMapping[widget._uid];
      if (data == null) return const AnimatedLoader(cupertino: true);

      final name = uctrl.message.value;
      final loading = pctrl.isLoading.value;
      final avatar = grepo.cacheFor(_ka).value;
      final cover = grepo.cacheFor(_kc).value;

      return Stack(
        children: [
          PageLayout(
            header: AppNavBar(
              height: 42,
              middle: Text("Edit profile"),
              end: TextButton(
                onPressed: () {},
                child: Text(
                  loading ? 'Saving...' : 'Save',
                  style: TextStyle(
                    color: name.isNotEmpty
                        ? context.primaryColor
                        : context.dividerColor,
                  ),
                ),
              ),
            ),
            content: CustomScrollView(
              slivers: [
                ProfileEditableHeader(
                  avatar == null
                      ? MediaSource.network(data.avatar)
                      : MediaSource.file(avatar.path),
                  onAvatar: () {
                    CustomModal(
                      context,
                      hasAction: false,
                      hidable: true,
                      children: [
                        OptionButton(
                          'Take photo',
                          icon: Icons.camera_alt_outlined,
                          onTap: () => context.asset(_ka),
                        ),
                        OptionButton(
                          'Choose existing photo',
                          icon: Icons.camera,
                          onTap: () async {
                            await grepo.fromPicture(_ka);
                          },
                        ),
                      ],
                    );
                  },
                  cover == null
                      ? MediaSource.network(data.banner)
                      : MediaSource.file(cover.path),
                  onCover: () {
                    CustomModal(
                      context,
                      hasAction: false,
                      hidable: true,
                      children: [
                        OptionButton(
                          'Take photo',
                          icon: Icons.camera_alt_outlined,
                          onTap: () => context.asset(_kc),
                        ),
                        OptionButton(
                          'Choose existing photo',
                          icon: Icons.camera,
                          onTap: () async {
                            await grepo.fromPicture(_kc);
                          },
                        ),
                      ],
                    );
                  },
                ),

                SliverToBoxAdapter(child: const SizedBox(height: 48)),
                SliverToBoxAdapter(
                  child: DataForm(
                    _kf,
                    autovalidate: AutovalidateMode.onUserInteraction,
                    children: [
                      Inputable(
                        'name',
                        // autofocus: true,
                        initValue: data.name,
                        hint: 'Name cannot be blank',
                        onChanged: (value) {
                          uctrl.message.value = value!;
                        },
                      ),
                      Inputable('bio', initValue: data.bio, maxLines: 3),
                      Inputable('location', initValue: data.location),
                      Inputable('website', initValue: data.website),
                      DatedPicker(
                        'dob',
                        lable: 'Date of birth',
                        initValue: data.dob ?? now,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (loading) const BlockOverlay('Saving'),
        ],
      );
    });
  }
}
