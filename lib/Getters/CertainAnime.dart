import 'package:html/parser.dart' as parser;

import '../API.dart';

class CertainAnime {
  String imageURL;
  String name;
  String description;
  String epizod;
  String rate;
  String quantity;
  List<String> tags;
  List<String> links;
  static List<String> _tag = [];
  static List<String> _link = [];

  CertainAnime(this.name, this.imageURL, this.description, this.epizod,
      this.rate, this.quantity, this.tags, this.links);

  static List<String> addTags(String tag) {
    _tag.add(tag);
    return _tag;
  }

  static List<String> addLinks(String link) {
    _link.add(link);
    return _link;
  }

  static Future<CertainAnime> open(link) {
    return CertainAnime.getAnime(link);
  }

  static Future<CertainAnime> getAnime(String url) async {
    var api = await API.getInstance();
    List<String> tagi = [];
    List<String> linki = [];
    String response = await api.get(url);
    var document = parser.parse(response);
    var title = document.getElementsByClassName('page-title');
    if (title.isEmpty) {
      return null;
    }
    var img = document
        .getElementsByClassName('title-cover')[0]
        .getElementsByClassName('info-aside-img');
    if (img.isEmpty) {
      return null;
    }
    var desc = document
        .getElementsByClassName('info-top')[0]
        .getElementsByTagName('p');
    String opis = "";
    if (desc.isNotEmpty) {
      opis = desc[0].text;
    }
    var ocena =
        document.getElementsByClassName('info-aside-rating-user')[0].text;
    var liczba = document.getElementsByClassName('h6')[0].text;
    void _tag = document
        .getElementsByClassName('tags')[0]
        .getElementsByTagName('li')
        .forEach((li) {
      return tagi = addTags(li.getElementsByTagName('a')[0].text);
    });
    void _link = document
        .getElementsByClassName('tags')[0]
        .getElementsByTagName('li')
        .forEach((li) {
      return linki =
          addLinks(li.getElementsByTagName('a')[0].attributes['href']);
    });
//    document.getElementsByClassName('box')[0].getElementsByTagName('ul')[0].getElementsByClassName('relation_t2t').forEach((li) {
//      var pownazwa = li.getElementsByTagName('a')[0].attributes['title'];
//      var powlink = li.getElementsByTagName('a')[0].attributes['href'];
//      if(pownazwa.isEmpty){
//        return null;
//      }
//      if(powlink.isEmpty){
//        return null;
//      }
//    });
    String nazwa = title[0].text;
    String obrazek = 'https://shinden.pl' + img[0].attributes['src'];
    String linked = url + '/all-episodes';
    return new CertainAnime(
        nazwa, obrazek, opis, linked, ocena, liczba, tagi, linki);
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

  String getDescription() {
    return description;
  }

  String getEpisodes() {
    return epizod;
  }

  String getRate() {
    return rate;
  }

  String getQuantity() {
    return quantity;
  }

  List<String> getTags() {
    _tag = [];
    return tags;
  }

  List<String> getLinks() {
    _link = [];
    return links;
  }
}
