import 'package:contentful/contentful.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

part 'client_test.g.dart';

class ContentfulHTTPClientMock extends Mock implements ContentfulHTTPClient {}

@JsonSerializable()
class TestEntry extends Entry<TestFields> {
  TestEntry(
    SystemFields sys,
    TestFields fields,
  ) : super(sys: sys, fields: fields);

  static TestEntry fromJson(Map<String, dynamic> json) =>
      _$TestEntryFromJson(json);

  Map<String, dynamic> toJson() => _$TestEntryToJson(this);
}

@JsonSerializable()
class TestFields extends Equatable {
  final int value;
  final TestEntry? other;

  TestFields(this.value, this.other);

  @override
  List<Object?> get props => [value, other];

  static TestFields fromJson(Map<String, dynamic> json) =>
      _$TestFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$TestFieldsToJson(this);
}

void main() {
  final httpClientMock = ContentfulHTTPClientMock();
  final spaceID = 'spaceID';
  final host = 'host.com';
  final environment = 'environment';
  final entryType = 'test';
  final baseUrl = Uri.https(host, 'some-custom-path/');
  final contentfulHost = 'cdn.contentful.com';

  group('[getEntry]', () {
    final entryID = '1';

    final queryParameters = {'flag': 'true'};

    final testData =
        '{"sys": { "id": "$entryID", "type": "$entryType" }, "fields": { "value": 1 }}';

    final expectedEntry = TestEntry(
      SystemFields(id: entryID, type: 'test'),
      TestFields(1, null),
    );

    final expectedUrl = Uri(
      scheme: 'https',
      host: host,
      path:
          'some-custom-path/spaces/$spaceID/environments/$environment/entries/$entryID',
      queryParameters: queryParameters,
    );

    test('uses default contentful host baseURL, when no baseURL is passed',
        () async {
      final expectedUrl = Uri(
        scheme: 'https',
        host: contentfulHost,
        path: 'spaces/$spaceID/environments/$environment/entries/$entryID',
        queryParameters: queryParameters,
      );

      final response = http.Response(testData, 200);

      when(() => httpClientMock.get(expectedUrl))
          .thenAnswer((_) async => response);

      final sut = Client(
        httpClientMock,
        spaceId: spaceID,
        environment: environment,
      );

      await sut.getEntry(
        entryID,
        TestEntry.fromJson,
        params: queryParameters,
      );

      verify(() => httpClientMock.get(expectedUrl)).called(1);
    });

    test('on success, exposes parsed data', () async {
      final response = http.Response(testData, 200);

      when(() => httpClientMock.get(expectedUrl))
          .thenAnswer((_) async => response);

      final sut = Client(
        httpClientMock,
        baseURL: baseUrl,
        spaceId: spaceID,
        environment: environment,
      );

      final fetchedEntry = await sut.getEntry(
        entryID,
        TestEntry.fromJson,
        params: queryParameters,
      );

      expect(fetchedEntry, equals(expectedEntry));
    });

    test('on fail, throws exception', () async {
      final response = http.Response('{"error": "Not found"}', 404);
      var threwException = false;

      when(() => httpClientMock.get(expectedUrl))
          .thenAnswer((_) async => response);

      final sut = Client(
        httpClientMock,
        baseURL: baseUrl,
        spaceId: spaceID,
        environment: environment,
      );

      try {
        await sut.getEntry(
          entryID,
          TestEntry.fromJson,
          params: queryParameters,
        );

        fail('expected getEntry to throw');
      } on Exception {
        threwException = true;
      }

      expect(threwException, true);
    });
  });

  group('[getEntries]', () {
    final queryParameters = {'flag': 'true'};
    final expectedUrl = Uri(
      scheme: 'https',
      host: host,
      path:
          'some-custom-path/spaces/$spaceID/environments/$environment/entries',
      queryParameters: queryParameters,
    );
    final firstEntryID = 'A';
    final secondEntryID = 'B';

    final secondEntry = TestEntry(
      SystemFields(id: secondEntryID, type: 'test'),
      TestFields(1, null),
    );

    final firstEntry = TestEntry(
      SystemFields(id: firstEntryID, type: 'test'),
      TestFields(1, secondEntry),
    );

    final expectedEntries = EntryCollection<TestEntry>(
      total: 2,
      skip: 0,
      limit: 0,
      items: [firstEntry],
    );

    final rawFirstEntry = '''
          {
            "sys": { 
              "id": "$firstEntryID", 
              "type": "$entryType" 
            }, 
            "fields": { 
              "value": 1, 
              "other": {
                "sys": {
                  "type": "Link",
                  "linkType": "$entryType",
                  "id": "$secondEntryID"
                }
              } 
            }
          }
      ''';

    final rawSecondEntry = '''
          {
            "sys": { 
              "id": "$secondEntryID", 
              "type": "$entryType" 
            }, 
            "fields": { "value": 1 }
          }
      ''';

    final testData = '''
            { 
              "total": 2,
              "skip": 0,
              "limit": 0,
              "items": [
                $rawFirstEntry
              ],
              "includes": {
                "$entryType": [
                  $rawSecondEntry
                ]
              }
            }
      ''';

    test('uses default contentful host baseURL, when no baseURL is provided',
        () async {
      final expectedUrl = Uri(
        scheme: 'https',
        host: contentfulHost,
        path: 'spaces/$spaceID/environments/$environment/entries',
        queryParameters: queryParameters,
      );
      final response = http.Response(testData, 200);

      when(() => httpClientMock.get(expectedUrl))
          .thenAnswer((_) async => response);

      final sut = Client(
        httpClientMock,
        spaceId: spaceID,
        environment: environment,
      );

      await sut.getEntries(
        queryParameters,
        TestEntry.fromJson,
      );

      verify(() => httpClientMock.get(expectedUrl)).called(1);
    });

    test('on success, exposes parsed data', () async {
      final response = http.Response(testData, 200);

      when(() => httpClientMock.get(expectedUrl))
          .thenAnswer((_) async => response);

      final sut = Client(
        httpClientMock,
        baseURL: baseUrl,
        spaceId: spaceID,
        environment: environment,
      );

      final fetchedEntries = await sut.getEntries(
        queryParameters,
        TestEntry.fromJson,
      );

      expect(fetchedEntries, equals(expectedEntries));
    });

    test('on fail, throws exception', () async {
      final response = http.Response('{"error": "Not found"}', 404);
      var threwException = false;

      when(() => httpClientMock.get(expectedUrl))
          .thenAnswer((_) async => response);

      final sut = Client(
        httpClientMock,
        baseURL: baseUrl,
        spaceId: spaceID,
        environment: environment,
      );

      try {
        await sut.getEntries(
          queryParameters,
          TestEntry.fromJson,
        );

        fail('expected getEntry to throw');
      } on Exception {
        threwException = true;
      }

      expect(threwException, true);
    });
  });

  test('[close] Closes the httpClient', () {
    final sut = Client(
      httpClientMock,
      baseURL: baseUrl,
      spaceId: spaceID,
    );

    sut.close();

    verify(() => httpClientMock.close()).called(1);
  });

  tearDown(() {
    reset(httpClientMock);
  });
}
