import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/services/cached_service.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/components/layout/overlapping.dart';
import 'package:semesta/src/components/user/profile_editable_header.dart';
import 'package:semesta/src/widgets/main/data_form.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/dated_picker.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
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
    _initUser();
    super.initState();
  }

  AsWait _initUser() async {
    final data = await uctrl.loadUser(widget._uid);
    if (data != null) uctrl.message.value = data.name;
  }

  AsWait _submit(Author data, File? avatar, File? cover) async {
    final state = _kf.currentState;
    if (state == null || !state.saveAndValidate()) return;

    final map = state.value;
    final model = data.copyWith(
      bio: map['bio'],
      name: map['name'],
      gender: map['gender'],
      website: map['website'.normalizeUrl],
      location: map['location'],
      birthdate: map['birthdate'],
    );

    await uctrl.modifyProfile(model, avatar, cover);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = uctrl.isLoading.value;
      final has = uctrl.message.value.isNotEmpty;
      final avatarFile = grepo.cacheFor(_ka).value;
      final coverFile = grepo.cacheFor(_kc).value;

      return FutureBuilder(
        future: uctrl.loadUser(widget._uid),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return const AnimatedLoader(cupertino: true);

          final data = snapshot.data!;
          final cover = data.media.others;
          final as = avatarFile == null
              ? MediaSource.network(data.media.url)
              : MediaSource.file(avatarFile.path);
          final cs = coverFile == null && cover.isNotEmpty
              ? MediaSource.network(cover[0])
              : MediaSource.file(coverFile?.path ?? '');

          return Overlapping(
            loading: loading,
            child: PageLayout(
              header: AppNavBar(
                middle: Text("Edit profile"),
                end: TextButton(
                  onPressed: has
                      ? () => _submit(data, avatarFile, coverFile)
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
                    as,
                    cs,
                    onAvatar: _show,
                    onCover: () => _show(false),
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
                          onChanged: (value) =>
                              uctrl.message.value = value ?? '',
                        ),
                        Inputable('bio', initValue: data.bio, maxLines: 3),
                        _Suggestion(data.location),
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
          );
        },
      );
    });
  }

  void _show([bool primary = true]) {
    final k = primary ? _ka : _kc;
    final w = primary ? 240 : 360;
    final h = primary ? 240 : 180;

    context.dialog(
      hasAction: false,
      hidable: true,
      children: [
        OptionButton(
          'Take photo',
          icon: Icons.camera_alt_outlined,
          onTap: () {
            context.imagePicker(k, width: w, height: w, from: PickMedia.camera);
          },
        ),
        OptionButton(
          'Choose existing photo',
          icon: Icons.camera,
          onTap: () => context.imagePicker(k, width: w, height: h),
        ),
      ],
    );
  }

  @override
  void dispose() {
    uctrl.message.value = '';
    grepo
      ..clearFor(_ka)
      ..clearFor(_kc);
    super.dispose();
  }
}

class _Suggestion extends StatefulWidget {
  final String initValue;
  const _Suggestion(this.initValue);

  @override
  State<_Suggestion> createState() => _SuggestionState();
}

class _SuggestionState extends State<_Suggestion> {
  late final TextEditingController _location;
  final _suggestions = ValueNotifier<List<LocationSuggestion>>([]);

  Timer? _debounce;
  bool _loading = false;
  bool _selectionLocked = false;

  @override
  void initState() {
    super.initState();
    _location = TextEditingController(text: widget.initValue);
    _location.addListener(() {
      if (_selectionLocked && _location.selection.baseOffset >= 0) {
        _selectionLocked = false;
      }
    });
  }

  void _onChanged(String query) {
    if (_selectionLocked) return;

    _debounce?.cancel();
    if (query.trim().length < 2) {
      _suggestions.value = [];
      return;
    }

    _debounce = Timer(Durations.medium2, () async {
      if (!mounted) return;

      setState(() => _loading = true);
      try {
        final result = await grepo.fetchPlaces(query);
        _suggestions.value = result;
      } catch (_) {
        _suggestions.value = [];
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    });
  }

  void _selected(LocationSuggestion item) {
    _selectionLocked = true;

    _location.text = item.secondary.isEmpty
        ? item.primary
        : '${item.primary}, ${item.secondary}';

    _suggestions.value = [];
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      children: [
        Inputable(
          'location',
          controller: _location,
          icon: Icons.location_on_outlined,
          onChanged: (v) => _onChanged(v ?? ''),
        ),

        const SizedBox(height: 6),
        ValueListenableBuilder(
          valueListenable: _suggestions,
          builder: (_, items, child) {
            if (items.isEmpty && !_loading) return const SizedBox.shrink();

            return Container(
              constraints: const BoxConstraints(maxHeight: 260),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 16,
                    offset: Offset(0, 6),
                    color: Colors.black12,
                  ),
                ],
              ),
              child: _loading
                  ? const AnimatedLoader(cupertino: true)
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      separatorBuilder: (_, idx) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final item = items[i];
                        return ListTile(
                          dense: true,
                          title: Text(
                            item.primary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: item.secondary.isEmpty
                              ? null
                              : Text(
                                  item.secondary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          onTap: () => _selected(item),
                        );
                      },
                    ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _location.clear();
    _suggestions.value = [];
    super.dispose();
  }
}
