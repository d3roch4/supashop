import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supashop/pages/login/login_page.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/util/util.dart';

class HttpClientAuth implements http.Client {
  var client = http.Client();
  AuthenticationService authService = Get.find();
  final bool anonymous;

  HttpClientAuth({this.anonymous = false});

  Future<Map<String, String>> insertDefaultsHeaders(
      Map<String, String>? headers) async {
    headers ??= {};
    if (!anonymous && !headers.containsKey('Authorization')) {
      var accessToken = await authService.getAccessTokenIfValid();
      if (accessToken == null) {
        var loginSuccess = await Get.toNamed(LoginPage.routePath);
        if (loginSuccess == null) throw Exception('AccessToken is expired');
        accessToken = (await authService.getAccessToken()) ?? '';
      }
      if (accessToken.isNotEmpty) headers['Authorization'] = accessToken;
    }
    if (!headers.containsKey('Content-Type'))
      headers['Content-Type'] = 'application/json';
    return headers;
  }

  Uri insertOriginUrl(Uri path) {
    var baseUri = Uri.parse(kApiUrlBase);
    var url = path.replace(
      scheme: baseUri.scheme,
      path: '${baseUri.path}${path.path}',
      host: baseUri.host,
      port: baseUri.port,
    );
    return url;
  }

  @override
  void close() {
    client.close();
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return client.delete(insertOriginUrl(url),
        headers: await insertDefaultsHeaders(headers),
        body: body,
        encoding: encoding);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return client.get(insertOriginUrl(url),
        headers: await insertDefaultsHeaders(headers));
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
    return client.head(insertOriginUrl(url),
        headers: await insertDefaultsHeaders(headers));
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return client.patch(insertOriginUrl(url),
        headers: await insertDefaultsHeaders(headers),
        body: body,
        encoding: encoding);
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return client.post(insertOriginUrl(url),
        headers: await insertDefaultsHeaders(headers),
        body: body,
        encoding: encoding);
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return client.put(insertOriginUrl(url),
        headers: await insertDefaultsHeaders(headers),
        body: body,
        encoding: encoding);
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    return client.read(insertOriginUrl(url),
        headers: await insertDefaultsHeaders(headers));
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
    return client.readBytes(insertOriginUrl(url),
        headers: await insertDefaultsHeaders(headers));
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    insertDefaultsHeaders(request.headers);
    var response = await client.send(request);
    return response;
  }
}