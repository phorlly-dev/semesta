import 'package:semesta/app/models/model.dart';
import 'package:semesta/public/extensions/json_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

class Mention extends IModel<Mention> {
  final String url;
  final String uname;
  final bool verified;
  const Mention({
    super.id,
    super.name,
    this.url = '',
    this.uname = '',
    super.createdAt,
    super.updatedAt,
    this.verified = false,
  });

  factory Mention.fromState(AsMap json) => Mention(
    id: json.id,
    name: json.name,
    url: json.asText('url'),
    uname: json.asText('uname'),
    verified: json.asBool('verified'),
    createdAt: json.created,
    updatedAt: json.updated,
  );

  @override
  AsMap toPayload() => {
    ...general,
    'url': url,
    'verified': verified,
    'name': name.trim(),
    'uname': uname.trim(),
  };

  @override
  Mention copyWith({
    String? id,
    String? url,
    String? name,
    String? uname,
    bool? verified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Mention(
    id: id ?? this.id,
    url: url ?? this.url,
    name: name ?? this.name,
    uname: uname ?? this.uname,
    verified: verified ?? this.verified,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? now,
  );

  @override
  List<Object?> get props => [...super.props, uname, url];
}
