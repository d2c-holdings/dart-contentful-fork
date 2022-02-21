import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'entry.dart';
import 'system_fields.dart';
part 'asset.g.dart';

@JsonSerializable()
class Asset extends Entry<AssetFields> {
  Asset({
    required SystemFields sys,
    AssetFields? fields,
  }) : super(sys: sys, fields: fields);

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);
}

@JsonSerializable()
class AssetFields extends Equatable {
  AssetFields({
    required this.title,
    required this.file,
  });

  final String? title;
  final AssetFile? file;

  @override
  List<Object?> get props => [title, file];

  factory AssetFields.fromJson(Map<String, dynamic> json) =>
      _$AssetFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$AssetFieldsToJson(this);
}

@JsonSerializable()
class AssetFile extends Equatable {
  AssetFile({
    required this.fileName,
    required this.contentType,
    required this.url,
    required this.details,
  });

  final String fileName;
  final String contentType;
  final String url;
  final AssetFileDetails details;

  @override
  List<Object?> get props => [fileName, contentType, url, details];

  factory AssetFile.fromJson(Map<String, dynamic> json) =>
      _$AssetFileFromJson(json);

  Map<String, dynamic> toJson() => _$AssetFileToJson(this);
}

@JsonSerializable()
class AssetFileDetails extends Equatable {
  AssetFileDetails({
    required this.size,
    this.image,
  });

  final int size;
  final AssetFileDetailsImage? image;

  @override
  List<Object?> get props => [size, image];

  factory AssetFileDetails.fromJson(Map<String, dynamic> json) =>
      _$AssetFileDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AssetFileDetailsToJson(this);
}

@JsonSerializable()
class AssetFileDetailsImage extends Equatable {
  AssetFileDetailsImage({
    required this.height,
    required this.width,
  });

  final int height;
  final int width;

  @override
  List<Object?> get props => [height, width];

  factory AssetFileDetailsImage.fromJson(Map<String, dynamic> json) =>
      _$AssetFileDetailsImageFromJson(json);

  Map<String, dynamic> toJson() => _$AssetFileDetailsImageToJson(this);
}
