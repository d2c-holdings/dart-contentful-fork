import 'package:dartz/dartz.dart';
import 'package:contentful/lib/conversion.dart' as convert;
import 'package:contentful/lib/entry.dart' as entry_utils;

bool _isListOfLinks(dynamic list) {
  if (list is! List) {
    return false;
  } else if (list.isEmpty) {
    return false;
  }

  if (!(list.first is Map)) {
    return false;
  }

  return entry_utils.isLink(list.first);
}

class Includes {
  static Includes fromJson(Map<String, dynamic> json) =>
      Includes._(_IncludesMap.fromJson(json));

  Includes._(this.map);

  final _IncludesMap map;

  List<Map<String, dynamic>> resolveLinks(List<dynamic> items, {required int level, required int? maxLevel}) =>
      items.map(convert.map).map((item) => _walkMap(item, level: level, maxLevel: maxLevel)).toList();

  Map<String, dynamic> _walkMap(Map<String, dynamic> entry, {required int level, required int? maxLevel}) {
    if (maxLevel != null && level == maxLevel) return {};
    return entry_utils.isLink(entry)
        ? map.resolveLink(entry).fold(() => entry, (item) => _walkMap(item, level: level + 1, maxLevel: maxLevel))
        : entry_utils.fields(entry).fold(
          () => entry,
          (fields) =>
      {
        ...entry,
        'fields': fields.map((key, value) => _resolveEntryField(key, value, level: level, maxLevel: maxLevel)),
      },
    );
  }

  MapEntry<String, dynamic> _resolveEntryField(String key, dynamic object, {required int level, required int? maxLevel}) {
    if (_isListOfLinks(object)) {
      return MapEntry(key, resolveLinks(object, level: level + 1, maxLevel: maxLevel));
    } else if (object is! Map) {
      return MapEntry(key, object);
    }

    final fieldMap = some(convert.map(object));
    final resolveLink = () =>
        fieldMap.filter(entry_utils.isLink).bind(map.resolveLink).map((entry) => _walkMap(entry, level: level + 1, maxLevel: maxLevel));
    final resolveRichText =
        () => fieldMap.filter(entry_utils.isRichText).map(_walkRichText);

    return resolveLink().orElse(resolveRichText).fold(
          () => MapEntry(key, object),
          (field) => MapEntry(key, field),
    );
  }

  Map<String, dynamic> _walkRichText(Map<String, dynamic> doc) {
    final root = {
      ...doc,
      'data': entry_utils.dataTarget(doc).bind(map.resolveLink).fold(
            () => doc['data'],
            (entry) =>
        {
          ...doc['data'],
          'target': entry,
        },
      ),
    };

    return entry_utils
        .contentList(doc)
        .map((nodes) => nodes.map(_walkRichText))
        .fold(
          () => root,
          (nodes) =>
      {
        ...root,
        'content': nodes.toList(),
      },
    );
  }
}

Map<String, Map<String, dynamic>> _addEntriesToMap(Map<String, Map<String, dynamic>> map,
    List<Map<String, dynamic>> entries) =>
    entries.fold(
      map,
          (map, entry) =>
          entry_utils.id(entry).fold(
                () => map,
                (id) {
              map[id] = entry;
              return map;
            },
          ),
    );

class _IncludesMap {
  factory _IncludesMap.fromJson(Map<String, dynamic> includes) =>
      _IncludesMap._(
        includes.values.map(convert.listOfMaps).fold({}, _addEntriesToMap),
      );

  _IncludesMap._(this._map);

  final Map<String, Map<String, dynamic>> _map;

  Option<Map<String, dynamic>> resolveLink(Map<String, dynamic> link) =>
      entry_utils.id(link).bind((id) => optionOf(_map[id]));
}
