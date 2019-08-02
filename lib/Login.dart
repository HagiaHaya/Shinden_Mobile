import 'dart:async';
import 'dart:io';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'API.dart';

Future<bool> getIn(String email, String pass) async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Directory(appDocDirectory.path).createSync();
  final dir = Directory(appDocDirectory.path + '/loginData');
  if (!dir.existsSync()) {
    dir.createSync();
  }
  var file = File(dir.path + "/auth");
  var api = await API.getInstance();
  String actionUrl = 'https://shinden.pl/main/0/login';
  Map<String, String> formData = new Map();
  formData['username'] = email;
  formData['password'] = pass;
  formData['remember'] = 'on';
  final loginPage =
      await http.post(actionUrl, headers: api.headers, body: formData);
  api.updateCookie(loginPage);
  final userPage =
      await http.get('https://shinden.pl/user/', headers: api.headers);

  file = await file.create();
  await file.writeAsString(api.cookies["sess_shinden"]);

  if (userPage.statusCode != 404) {
    await updateNickname(userPage);
    await updateAvatar(userPage);
  }
  return Future.value(userPage.statusCode != 404);
}

void updateNickname(Response userPage) async {
  var document = parser.parse(userPage.body);
  var elementsByClassName =
      document.getElementsByClassName('notif-total-notif');
  if (elementsByClassName.isEmpty) {
    return;
  }
  nickname =
      elementsByClassName[0].getElementsByClassName('mobile-visible')[0].text;
}

void updateAvatar(Response userPage) async {
  var document = parser.parse(userPage.body);
  var elementsByClassName =
      document.getElementsByClassName('notif-total-notif');
  if (elementsByClassName.isEmpty) {
    return;
  }
  avatar = elementsByClassName[0]
      .getElementsByTagName('img')[0]
      .attributes['src']
      .replaceAll('36x48', '225x350');
}

String nickname;
String avatar;

String get loggedUser {
  return nickname == null ? '' : nickname;
}

String get loggedAvatar {
  return avatar == null ? '' : 'https://shinden.pl' + avatar;
}
