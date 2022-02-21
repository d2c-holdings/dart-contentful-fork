import 'dart:async';
import 'dart:convert';
import 'package:contentful/includes.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:contentful/lib/conversion.dart' as convert;
import 'package:contentful/models/entry.dart';

abstract class ContentfulHTTPClient {
  Future<http.Response> get(Uri url, {Map<String, String>? headers});
  void close();
}

class BearerTokenHTTPClient extends http.BaseClient
    implements ContentfulHTTPClient {
  BearerTokenHTTPClient(this.accessToken) : _inner = http.Client();

  final http.Client _inner;
  final String accessToken;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
    return _inner.send(request);
  }
}

class Client {
  Client(
    this._httpClient, {
    required this.spaceId,
    Uri? baseURL,
    this.environment = 'master',
  }) : baseURL = baseURL ?? Uri.https('cdn.contentful.com', '');

  final ContentfulHTTPClient _httpClient;
  final String spaceId;
  final Uri baseURL;
  final String environment;

  Uri _resolveUri(String path, {Map<String, dynamic>? params}) =>
      baseURL.resolveUri(baseURL.resolveUri(Uri(
        path: 'spaces/$spaceId/environments/$environment$path',
        queryParameters: params,
      )));

  void close() => _httpClient.close();

  Future<T> getEntry<T>(
    String id,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? params,
  }) async {
    final response =
        await _httpClient.get(_resolveUri('/entries/$id', params: params));
    if (response.statusCode >= 400) {
      throw Exception('getEntry failed');
    }
    return fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  Future<EntryCollection<T>> getEntries<T>(
    Map<String, dynamic> query,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response =
        await _httpClient.get(_resolveUri('/entries', params: query));

    if (response.statusCode >= 400) {
      throw Exception('getEntries failed');
    }

    Map<String, dynamic> jsonr = json.decode(utf8.decode(response.bodyBytes));

    // If it has includes, then resolve all the links inside the items
    jsonr = optionOf(jsonr['includes'])
        .map(convert.map)
        .map(Includes.fromJson)
        .map((includes) => includes.resolveLinks(jsonr['items'], level: 0, maxLevel: int.tryParse(query["include"] ?? "")))
        .fold(
          () => jsonr,
          (items) => {
            ...jsonr,
            'items': items,
          },
        );

    return EntryCollection.fromJson(jsonr, fromJson);
  }
}
