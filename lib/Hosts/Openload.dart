import 'dart:async';
import 'dart:math';

import 'package:http/http.dart' as http;

Future<String> getOpenloadVideo(String url) async {
  http.Response response = await http.get(url);
  RegExp exp = new RegExp(
      "_0x30725e,\\(parseInt\\('([0-9]+)',8\\)-([0-9]+)\\+0x([0-9|a-f]+)-([0-9]+)\\)\\/\\(([0-9]+)-0x([0-9|a-f]+)\\)\\)",
      multiLine: true);

  Match match = exp.firstMatch(response.body);

  var key = int.parse(match.group(1), radix: 8);
  key -= int.parse(match.group(2), radix: 10);
  key += int.parse(match.group(3), radix: 16);
  key -= int.parse(match.group(4), radix: 10);
  key = (key /
          (int.parse(match.group(5), radix: 10) -
              int.parse(match.group(6), radix: 16)))
      .floor();

  RegExp exp2 = new RegExp("_1x4bfb36=parseInt\\('([0-7]+)',8\\)-([0-9]+)",
      multiLine: true);

  Match match2 = exp2.firstMatch(response.body);
  var key2 = int.parse(match2.group(1), radix: 8);
  key2 -= int.parse(match2.group(2), radix: 10);

  RegExp exp3 = new RegExp(
      "<p style=\"\" id=\".*\">(.*)</p>.*640K ought to be enough for anybody",
      multiLine: true);

  Match match3 =
      exp3.firstMatch(response.body.replaceAll("\r", "").replaceAll("\n", ""));

  var input = match3.group(1);
  var output = "";
  var _0x439a49a = input.substring(0, 72);
  var ke = [];
  for (var i = 0; i < _0x439a49a.length; i += 8) {
    ke.add(int.parse(_0x439a49a.substring(i, i + 8), radix: 16));
  }
  input = input.substring(72);
  var _0x439a49 = 0x0;
  var _0x145894 = 0x0;
  var aaa = ke;

  while (_0x439a49 < input.length) {
    var _0x5eb93a = 0x40;
    var _0x37c346 = 0x7f;
    var _0x896767 = 0x0;
    var _0x1a873b = 0x0;
    var _0x3d9c8e = 0x0;
    do {
      if (_0x439a49 + 1 >= input.length) {
        _0x5eb93a = 0x8f;
      }
      String _0x1fa71e = input.substring(_0x439a49, _0x439a49 + 2);
      _0x439a49 += 2;
      _0x3d9c8e = int.parse(_0x1fa71e, radix: 0x10);
      if (_0x1a873b < 30) {
        var _0x332549 = _0x3d9c8e & 0x3f;
        _0x896767 += _0x332549 << _0x1a873b;
      } else {
        var _0x332549 = _0x3d9c8e & 0x3f;
        _0x896767 += _0x332549 * pow(0x2, _0x1a873b);
      }
      _0x1a873b += 0x6;
    } while (_0x3d9c8e >= _0x5eb93a);

    var _0x30725e = (_0x896767 ^ aaa[_0x145894 % 0x9]);
    _0x30725e = (_0x30725e ^ key) ^ key2;
    var _0x2de433 = _0x5eb93a * 0x2 + _0x37c346;
    for (int i = 0x0; i < 4; i++) {
      var _0x1a9381 = _0x30725e & _0x2de433;
      var _0x1a0e90 = (8 * i).floor();
      _0x1a9381 = _0x1a9381 >> _0x1a0e90;
      var _0x3fa834 = (_0x1a9381 - 1);
      if (_0x3fa834 != 36) output += new String.fromCharCode(_0x3fa834);
      _0x2de433 = _0x2de433 << 8;
    }
    _0x145894 += 0x1;
  }
  return Future.value("https://oload.cloud/stream/" + output + "?mime=true");
}
