import 'package:html/parser.dart' as parser;

import '../API.dart';

class Episodes {
  String number;
  String title;
  String emission;
  String link;

  Episodes(this.number, this.title, this.emission, this.link);

  static Future<List<Episodes>> open(url) {
    Future<List<Episodes>> lista = Episodes.getEpisodes(url);
    return lista;
  }

  static Future<List<Episodes>> getEpisodes(String url) async {
    var api = await API.getInstance();
    String response = await api.get(url);
    var document = parser.parse(response);
    List<Episodes> lista = [];
    document
        .getElementsByClassName('list-episode-checkboxes')[0]
        .getElementsByTagName("tr")
        .forEach((tr) {
      var title = tr.getElementsByClassName('ep-title');
      if (title.isEmpty) {
        return null;
      }
      var number = tr.getElementsByTagName('td');
      if (number.isEmpty) {
        return null;
      }
      var ep = tr.getElementsByClassName('ep-date');
      if (ep.isEmpty) {
        return null;
      }
      var link = "";
      if (tr.getElementsByClassName('button-group').isNotEmpty) {
        link = tr
            .getElementsByClassName('button-group')[0]
            .getElementsByTagName("a")[0]
            .attributes["href"];
      }
      String nazwa = title[0].text;
      String episod = ep[0].text;
      String numer = number[0].text;
      String dalej = 'https://shinden.pl' + link;
      lista.add(new Episodes(numer, nazwa, episod, dalej));
      return lista;
    });
    return lista;
  }

  String toString() {
    return title;
  }

  String getNumber() {
    return number;
  }

  String getTitle() {
    return title;
  }

  String getEmission() {
    return emission;
  }

  String getLink() {
    return link;
  }
}
