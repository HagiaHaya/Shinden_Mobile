import 'package:html/parser.dart' as parser;

import '../API.dart';

void main() {
  Animes.mainList();
}

class Animes {
  String imageURL;
  String name;
  String link;

  Animes(this.name, this.imageURL, this.link);

  static Future<List<Animes>> loadFromUrl(url) {
    Future<List<Animes>> lista = Animes.doMagic(url);
    return lista;
  }

  static Future<List<Animes>> search(name) {
    Future<List<Animes>> lista =
        Animes.doMagic('https://shinden.pl/series?search=' + name);

    return lista;
  }

  static Future<List<Animes>> mainList() {
    Future<List<Animes>> lista;
    lista = Animes.getMainList('https://shinden.pl');
    return lista;
  }

  static Future<List<Animes>> doMagic(String url) async {
    var api = await API.getInstance();
    String response = await api.get(url);
    var document = parser.parse(response);
    List<Animes> lista = [];
    document.getElementsByClassName('div-row').forEach((row) {
      var titleElements =
          row.getElementsByClassName('desc-col')[0].getElementsByTagName('h3');
      if (titleElements.isEmpty) {
        return null;
      }
      var imgElements = row.getElementsByClassName('cover-col')[0].children;
      if (imgElements.isEmpty) {
        return null;
      }
      String nazwa = titleElements[0].getElementsByTagName("a")[0].text;
      String linkacz = 'https://shinden.pl' +
          titleElements[0].getElementsByTagName("a")[0].attributes['href'];
      String obrazek = 'https://shinden.pl' +
          imgElements[0]
              .attributes['style']
              .replaceAll('background-image: url(', '')
              .replaceAll(')', '')
              .replaceAll('100x100', '225x350');
      lista.add(new Animes(nazwa, obrazek, linkacz));
      return lista;
    });
    return lista;
  }

  static Future<List<Animes>> getMainList(String url) async {
    var api = await API.getInstance();
    String response = await api.get(url);
    var document = parser.parse(response);
    List<Animes> lista = [];
    document
        .getElementsByClassName('current-season-tiles')[0]
        .getElementsByTagName('a')
        .forEach((row) {
      var titleElements = row
          .getElementsByClassName('tile-title')[0]
          .getElementsByTagName('span');
      if (titleElements.isEmpty) {
        return null;
      }
      var imgElements = row.attributes['style'];
      if (imgElements.isEmpty) {
        return null;
      }
      var linkElements = row.attributes['href'];
      if (linkElements.isEmpty) {
        return null;
      }
      String nazwa = titleElements[0].text;
      String linkacz = 'https://shinden.pl' + linkElements;
      String obrazek = 'https://shinden.pl' +
          imgElements
              .replaceAll('background-image:url(', '')
              .replaceAll(')', '');
      lista.add(new Animes(nazwa, obrazek, linkacz));
      return lista;
    });
    return lista;
  }

  String toString() {
    return name;
  }

  String getName() {
    return name;
  }

  String getimageURL() {
    return imageURL;
  }

  String getLink() {
    return link;
  }
}
