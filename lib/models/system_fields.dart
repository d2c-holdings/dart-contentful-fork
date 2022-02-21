import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'link.dart';

part 'system_fields.g.dart';

@JsonSerializable()
class SystemFields extends Equatable {
  SystemFields({
    required this.id,
    required this.type,
    this.space,
    this.contentType,
    this.linkType,
    this.revision,
    this.createdAt,
    this.updatedAt,
    this.locale,
  });

  final String id;
  final String type;
  final Link? space;
  final Link? contentType;
  final String? linkType;
  final int? revision;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? locale;

  @override
  List<Object?> get props => [
        id,
        type,
        space,
        contentType,
        linkType,
        revision,
        createdAt,
        updatedAt,
        locale
      ];

  factory SystemFields.fromJson(Map<String, dynamic> json) =>
      _$SystemFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$SystemFieldsToJson(this);
}
