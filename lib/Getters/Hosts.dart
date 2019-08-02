import 'dart:convert';

import 'package:html/parser.dart' as parser;

import '../API.dart';

//main() async{
//  List<Hosts> hosts = await Hosts.open('https://shinden.pl/episode/11579-seikon-no-qwaser-ii/view/91787');
//}
class Hosts {
  String service;
  String quality;
  String subtitles;
  String added;
  int id;

  Hosts(this.service, this.quality, this.subtitles, this.added, this.id);

  static Future<List<Hosts>> open(url) {
    Future<List<Hosts>> lista = Hosts.getHosts(url);
    return lista;
  }

  static Future<List<Hosts>> getHosts(String url) async {
    var api = await API.getInstance();
    String response = await api.get(url);
    var document = parser.parse(response);
    List<Hosts> lista = [];
    document
        .getElementsByClassName('table-responsive')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName("tr")
        .forEach((tr) {
      var service = tr.getElementsByClassName('ep-pl-name');
      if (service.isEmpty) {
        return null;
      }
      var quality = tr.getElementsByClassName('ep-pl-res');
      if (quality.isEmpty) {
        return null;
      }
      var subtitles = tr
          .getElementsByClassName('ep-pl-slang')[0]
          .getElementsByClassName('mobile-hidden');
      if (subtitles.isEmpty) {
        return null;
      }
      var added = tr.getElementsByClassName('ep-online-added');
      if (added.isEmpty) {
        return null;
      }
      var link = "";
      if (tr.getElementsByClassName('ep-buttons').isNotEmpty) {
        link = tr
            .getElementsByClassName('ep-buttons')[0]
            .getElementsByTagName("a")[0]
            .attributes["data-episode"];
      }
      var newlink = Info.fromJson(jsonDecode(link));
      String host = service[0].text;
      String jakosc = quality[0].text;
      String napisy = subtitles[0].text;
      String dodano = added[0].text;
      lista.add(new Hosts(host, jakosc, napisy, dodano, newlink.id));
      return lista;
    });
    return lista;
  }

  String toString() {
    return service;
  }

  String getService() {
    return service;
  }

  String getQuality() {
    return quality;
  }

  String getSubtitles() {
    return subtitles;
  }

  String getAdded() {
    return added;
  }

  int getID() {
    return id;
  }
}

class Info {
  final String source;
  final int id;

  Info({this.id, this.source});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      source: json['source'],
      id: int.parse(json['online_id']),
    );
  }
}
