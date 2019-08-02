import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'Login.dart';

class API {
  static API instance = null;
  Map<String, String> cookies = {};
  Map<String, String> headers = {
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36',
    'authority': 'shinden.pl',
    'pragma': 'no-cache',
    'referer': 'https://shinden.pl/',
    'accept-language': 'pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
    'cache-control': 'no-cache',
    'upgrade-insecure-requests': '1',
  };
  String xhrService;
  String basicAuth;

  static Future<API> getInstance() async {
    if (instance == null) {
      instance = new API();
      await instance.init();
    }
    return Future.value(instance);
  }

  static API getNullableInstance() {
    return instance;
  }

  init() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory(appDocDirectory.path).createSync();
    final dir = Directory(appDocDirectory.path + '/loginData');
    if (dir.existsSync()) {
      var file = File(dir.path + "/auth");
      var token = (await file.readAsString());
      cookies["sess_shinden"] = token;
    }
    await http
        .get("https://shinden.pl", headers: headers)
        .then((http.Response response) {
      updateCookie(response);
    });
    await http
        .get("https://shinden.pl", headers: headers)
        .then((http.Response response) {
      updateNickname(response);
      updateAvatar(response);
      RegExp exp = new RegExp("_Storage.basic =  '([^']+)';");
      Match match = exp.firstMatch(response.body);
      basicAuth = match.group(1);
      exp = new RegExp("_Storage.XHRService = '([^']+shinden[^']+)';");
      match = exp.firstMatch(response.body);
      xhrService = match.group(1);
    });
  }

  void updateCookie(http.Response response) {
    String allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }
      headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];
        if (key == 'path' || key == 'expires') return;
        this.cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += "; ";
      cookie += key + "=" + cookies[key];
    }
    cookie += '; cb-rodo=accepted';
    return cookie;
  }

  Future<String> get(String url) async {
    final response =
        await http.get(url, headers: headers).then((http.Response response) {
      updateCookie(response);
      return response;
    });
    return response.body;
  }

  Future<bool> loggedIn() async {
    var response = await http.get('https://shinden.pl/user', headers: headers);
    return response.statusCode != 404;
  }
}
