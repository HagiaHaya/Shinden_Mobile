import 'dart:async';

import 'package:http/http.dart' as http;

Future<String> getMP4UploadVideo(String link) async {
  http.Response response = await http.get(link);
  RegExp exp = new RegExp("eval\((.*)\)\n", multiLine: true);
  var firstMatch = exp.firstMatch(response.body);
  var obfuscatedSource = firstMatch.group(1);
  exp = new RegExp("}\\('(.*)',([0-9]+),([0-9]+),'(.*)'.split");
  var match = exp.firstMatch(obfuscatedSource);
  var obfuscatedCode = match.group(1);
  var base = int.parse(match.group(2));
  var n = int.parse(match.group(3));
  var mappings = match.group(4);
  var split = mappings.split("|");
  while (n-- > 0) {
    if (split[n].isNotEmpty)
      obfuscatedCode = obfuscatedCode.replaceAll(
          new RegExp("\\b" + n.toRadixString(base) + "\\b"), split[n]);
  }
  exp = new RegExp("player.src\\(\"(.*)\"\\);player.poster");
  return exp.firstMatch(obfuscatedCode).group(1);
}
