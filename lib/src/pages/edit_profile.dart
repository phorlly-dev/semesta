import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/repositories/generic_repository.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/components/user/profile_editable_header.dart';
import 'package:semesta/src/widgets/main/data_form.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/block_overlay.dart';
import 'package:semesta/src/widgets/sub/dated_picker.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';
import 'package:semesta/src/widgets/sub/grouped_options.dart';
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
      final has = name.isNotEmpty;
      final loading = uctrl.isLoading.value;
      final avatar = grepo.cacheFor(_ka).value;
      final cover = grepo.cacheFor(_kc).value;

      return Stack(
        children: [
          PageLayout(
            header: AppNavBar(
              middle: Text("Edit profile"),
              end: TextButton(
                onPressed: has
                    ? () async {
                        final state = _kf.currentState;
                        if (state == null || !state.saveAndValidate()) return;

                        final map = state.value;
                        final model = data.copy(
                          bio: map['bio'],
                          name: map['name'],
                          gender: map['gender'],
                          website: map['website'],
                          location: map['location'],
                          birthdate: map['birthdate'],
                        );

                        await uctrl.modifyProfile(model, avatar, cover);
                        if (context.mounted) context.pop();
                      }
                    : null,
                style: TextButton.styleFrom(
                  minimumSize: Size(16, 8),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
                child: Text(
                  loading ? 'Saving...' : 'Save',
                  style: TextStyle(
                    color: has ? context.primaryColor : context.dividerColor,
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
                          onTap: () {
                            context.imagePicker(_ka, from: PickMedia.camera);
                          },
                        ),
                        OptionButton(
                          'Choose existing photo',
                          icon: Icons.camera,
                          onTap: () => context.imagePicker(_ka),
                        ),
                      ],
                    );
                  },
                  cover == null
                      ? MediaSource.network(data.cover)
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
                          onTap: () {
                            context.imagePicker(
                              _kc,
                              width: 360,
                              height: 180,
                              from: PickMedia.camera,
                            );
                          },
                        ),
                        OptionButton(
                          'Choose existing photo',
                          icon: Icons.camera,
                          onTap: () {
                            context.imagePicker(_kc, width: 360, height: 180);
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
                    scrollable: false,
                    autovalidate: AutovalidateMode.onUserInteraction,
                    children: [
                      Inputable(
                        'name',
                        icon: Icons.person,
                        initValue: data.name,
                        hint: 'Name cannot be blank',
                        maxLength: 50,
                        counterText: '${name.length}/50',
                        onChanged: (value) {
                          uctrl.message.value = value!;
                        },
                      ),
                      Inputable('bio', initValue: data.bio, maxLines: 3),
                      Inputable(
                        'location',
                        initValue: data.location,
                        icon: Icons.location_on_outlined,
                      ),
                      GroupedOptions<Gender>(
                        'gender',
                        icon: Icons.group_outlined,
                        initValue: data.gender,
                        options: Gender.values.map((gender) {
                          return FormBuilderFieldOption(
                            value: gender,
                            child: Text(toCapitalize(gender.name)),
                          );
                        }).toList(),
                      ),
                      Inputable(
                        'website',
                        initValue: data.website,
                        keyboardType: TextInputType.url,
                      ),
                      DatedPicker(
                        'birthdate',
                        icon: Icons.calendar_month_outlined,
                        lable: 'Birthdata',
                        initValue: data.birthdate,
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
