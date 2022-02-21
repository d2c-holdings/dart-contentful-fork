# contentful-dart

[![pub package](https://img.shields.io/pub/v/contentful.svg)](https://pub.dartlang.org/packages/contentful)

This Dart package is a small abstraction on top of the Contentful Delivery API.

## Usage

To use this plugin, install `contentful` as a dependency in your `pubspec.yaml`.

## API

The following example uses `equatable` and `json_annotation` to create a
Contentful Entry model. For more information about `json_annotation`, see:
https://pub.dev/packages/json_serializable

Contentful adds system fields to their JSON responses, so you need to create a
separate fields class and pass it to the `Entry<T>` class generic.

You can also add relationships as a field attribute and they will get injected
if they are included in the JSON response. See here for more details:
https://www.contentful.com/developers/docs/concepts/links/

```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:contentful/contentful.dart';

part 'event.g.dart';

@JsonSerializable()
class Event extends Entry<EventFields> {
  Event({
    SystemFields sys,
    EventFields fields,
  }) : super(sys: sys, fields: fields);

  static Event fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

@JsonSerializable()
class EventFields extends Equatable {
  EventFields({
    this.title,
    this.slug,
    this.relations,
  }) : super([title, slug, relations]);

  final String title;
  final String slug;
  final List<Event> relations;

  static EventFields fromJson(Map<String, dynamic> json) =>
      _$EventFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$EventFieldsToJson(this);
}
```

Here is how you would use your `Event` class.

```dart
import 'package:contentful/contentful.dart';
import 'event.dart';

class EventRepository {
  EventRepository(this.contentful);
  final Client contentful;

  Future<Event> findBySlug(String slug) async {
    final collection = await contentful.getEntries<Event>({
      'content_type': 'event',
      'fields.slug': slug,
      'limit': '1',
      'include': '10',
    }, Event.fromJson);

    return collection.items.first;
  }
}

Future<void> main() async {
  final repo = EventRepository(Client(
    BearerTokenHTTPClient('token'),
    spaceId: 'space-id',
  ));

  final event = await repo.findBySlug('myevent');
  print('Title: ${event.fields.title}');
}
```
