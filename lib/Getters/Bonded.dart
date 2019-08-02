import 'package:html/parser.dart' as parser;

import '../API.dart';

class BondedAnimes {
  String connectedName;
  String connectedLink;
  String connectedImg;
  String connectedThing;

  BondedAnimes(this.connectedName, this.connectedLink, this.connectedImg,
      this.connectedThing);

  static Future<List<BondedAnimes>> open(link) {
    return BondedAnimes.getBonded(link);
  }

  static Future<List<BondedAnimes>> getBonded(String url) async {
    var api = await API.getInstance();
    List<BondedAnimes> lista = [];
    String response = await api.get(url);
    var document = parser.parse(response);
    document
        .getElementsByClassName('box')[2]
        .getElementsByClassName('relation_t2t')
        .forEach((li) {
      String powimg = li
          .getElementsByTagName('figure')[0]
          .getElementsByTagName('img')[0]
          .attributes['src'];
      String powlink = li
          .getElementsByTagName('figure')[0]
          .getElementsByTagName('figcaption')[0]
          .getElementsByTagName('a')[0]
          .attributes['href'];
      String pownazwa = li
          .getElementsByTagName('figure')[0]
          .getElementsByTagName('figcaption')[0]
          .getElementsByTagName('a')[0]
          .attributes['title'];
      String powrzecz = li
          .getElementsByTagName('figure')[0]
          .getElementsByTagName('figcaption')[2]
          .text;
      if (pownazwa.isEmpty) {
        return null;
      }
      if (powimg.isEmpty) {
        return null;
      }
      if (powlink.isEmpty) {
        return null;
      }
      if (powrzecz.isEmpty) {
        return null;
      }
      lista.add(new BondedAnimes(pownazwa, powlink, powimg, powrzecz));
      return lista;
    });
    return lista;
  }

  String getConnectedName() {
    return connectedName;
  }

  String getConnectedThing() {
    return connectedThing;
  }

  String getConnectedImg() {
    return 'https://shinden.pl' + connectedImg.replaceAll('100x100', '225x350');
  }

  String getConnectedLink() {
    return 'https://shinden.pl' + connectedLink;
  }
}
