import 'package:html/parser.dart' as parser;

import '../API.dart';

class Genres {
  String genre;
  String link;

  Genres(this.link, this.genre);

  static Future<List<Genres>> addGenres(String url) async {
    var api = await API.getInstance();
    String response = await api.get(url);
    var document = parser.parse(response);
    List<Genres> lista = [];
    document
        .getElementsByClassName('genre-list')[0]
        .getElementsByTagName('a')
        .forEach((li) {
      var idElements = li.attributes['data-id'];
      if (idElements.isEmpty) {
        return null;
      }
      var nameElements = li.text;
      if (nameElements.isEmpty) {
        return null;
      }
      String ajdi = idElements.toString();
      String nazwa = nameElements.toString();
      lista.add(new Genres(ajdi, nazwa));
      return lista;
    });
    return lista;
  }

  String getGenre() {
    return genre;
  }

  String getLink() {
    String newlink = 'i' + link;
    return newlink;
  }
}
