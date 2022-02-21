// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      sys: SystemFields.fromJson(json['sys'] as Map<String, dynamic>),
      fields: json['fields'] == null
          ? null
          : AssetFields.fromJson(json['fields'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'sys': instance.sys,
      'fields': instance.fields,
    };

AssetFields _$AssetFieldsFromJson(Map<String, dynamic> json) => AssetFields(
      title: json['title'] as String?,
      file: json['file'] == null
          ? null
          : AssetFile.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetFieldsToJson(AssetFields instance) =>
    <String, dynamic>{
      'title': instance.title,
      'file': instance.file,
    };

AssetFile _$AssetFileFromJson(Map<String, dynamic> json) => AssetFile(
      fileName: json['fileName'] as String,
      contentType: json['contentType'] as String,
      url: json['url'] as String,
      details:
          AssetFileDetails.fromJson(json['details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetFileToJson(AssetFile instance) => <String, dynamic>{
      'fileName': instance.fileName,
      'contentType': instance.contentType,
      'url': instance.url,
      'details': instance.details,
    };

AssetFileDetails _$AssetFileDetailsFromJson(Map<String, dynamic> json) =>
    AssetFileDetails(
      size: json['size'] as int,
      image: json['image'] == null
          ? null
          : AssetFileDetailsImage.fromJson(
              json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetFileDetailsToJson(AssetFileDetails instance) =>
    <String, dynamic>{
      'size': instance.size,
      'image': instance.image,
    };

AssetFileDetailsImage _$AssetFileDetailsImageFromJson(
        Map<String, dynamic> json) =>
    AssetFileDetailsImage(
      height: json['height'] as int,
      width: json['width'] as int,
    );

Map<String, dynamic> _$AssetFileDetailsImageToJson(
        AssetFileDetailsImage instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
    };
