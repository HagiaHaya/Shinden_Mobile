import 'dart:async';

import 'package:http/http.dart' as http;

import '../API.dart';

Future<String> getCDAUploadVideo(String link) async {
  var api = API.getNullableInstance();
  http.Response response = await http.get(link, headers: api.headers);
  var firstMatch =
      new RegExp("file\":\"([^\"]+\\.mp4)").firstMatch(response.body);
  return firstMatch.group(1).replaceAll("\\/", "/");
}
