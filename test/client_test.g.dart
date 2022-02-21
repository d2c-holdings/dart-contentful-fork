// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestEntry _$TestEntryFromJson(Map<String, dynamic> json) => TestEntry(
      SystemFields.fromJson(json['sys'] as Map<String, dynamic>),
      TestFields.fromJson(json['fields'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TestEntryToJson(TestEntry instance) => <String, dynamic>{
      'sys': instance.sys,
      'fields': instance.fields,
    };

TestFields _$TestFieldsFromJson(Map<String, dynamic> json) => TestFields(
      json['value'] as int,
      json['other'] == null
          ? null
          : TestEntry.fromJson(json['other'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TestFieldsToJson(TestFields instance) =>
    <String, dynamic>{
      'value': instance.value,
      'other': instance.other,
    };
