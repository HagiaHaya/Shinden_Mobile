import 'dart:async';

import 'package:http/http.dart' as http;

import '../API.dart';

Future<String> getVKUploadVideo(String link) async {
  var api = API.getNullableInstance();
  http.Response response = await http.get(link, headers: api.headers);
  RegExp exp = new RegExp("url([0-9]{1,3})\":\"([^\"]*)", multiLine: true);
  int res = 0;
  String url;
  exp.allMatches(response.body).forEach((match) {
    if (int.parse(match.group(1)) > res) {
      url = match.group(2);
    }
  });
  return url.replaceAll("\\/", "/");
}
