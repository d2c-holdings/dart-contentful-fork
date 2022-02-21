import 'package:dartz/dartz.dart';
import 'package:contentful/lib/conversion.dart' as convert;

Option<String> id(Map<String, dynamic> entry) => optionOf(entry['sys']?['id']);

Option<String> type(Map<String, dynamic> entry) =>
    optionOf(entry['sys']?['type']);

bool isLink(Map<String, dynamic> entry) => type(entry) == some('Link');
bool isRichText(Map<String, dynamic> entry) => entry['content'] != null;

Option<Map<String, dynamic>> Function(Map<String, dynamic>) mapKey(
  String key,
) =>
    (entry) => optionOf(entry[key]).map(convert.map);

final fields = mapKey('fields');

Option<Map<String, dynamic>> dataTarget(Map<String, dynamic> field) =>
    optionOf(field['data']?['target']);

Option<List<Map<String, dynamic>>> contentList(Map<String, dynamic> entry) =>
    optionOf(entry['content']).map(convert.listOfMaps);
