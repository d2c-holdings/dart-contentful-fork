import 'package:equatable/equatable.dart';
import 'system_fields.dart';

abstract class Entry<T> extends Equatable {
  Entry({
    required this.sys,
    this.fields,
  });

  final SystemFields? sys;
  final T? fields;

  @override
  List<Object?> get props => [sys, fields];
}

class EntryCollection<T> extends Equatable {
  EntryCollection({
    required this.total,
    required this.skip,
    required this.limit,
    required this.items,
  });

  final int total;
  final int skip;
  final int limit;
  final List<T> items;

  factory EntryCollection.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      EntryCollection(
        total: json['total'],
        skip: json['skip'],
        limit: json['limit'],
        items: json['items'].map<T>((jsonItem) => fromJson(jsonItem)).toList(),
      );

  @override
  List<Object?> get props => [total, skip, limit, items];
}
