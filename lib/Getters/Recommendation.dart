import 'package:html/parser.dart' as parser;

import '../API.dart';

//void main() {
//  Recommendation.recommendation();
//}

class Recommendation {
  String firstImage;
  String secondImage;
  String firstName;
  String secondName;
  String firstLink;
  String secondLink;

  Recommendation(this.firstName, this.secondName, this.firstImage,
      this.secondImage, this.firstLink, this.secondLink);

  static Future<List<Recommendation>> recommendation() {
    Future<List<Recommendation>> lista =
        Recommendation.getRecommendation('https://shinden.pl');
    return lista;
  }

  static Future<List<Recommendation>> getRecommendation(String url) async {
    var api = await API.getInstance();
    String response = await api.get(url);
    var document = parser.parse(response);
    List<Recommendation> lista = [];
    document
        .getElementsByClassName('l-container-secondary row')[0]
        .getElementsByClassName(
            'col-xs-12 col-sm-6 box carousel carousel-text recommends-slider')[0]
        .getElementsByClassName('carousel-slides')[0]
        .getElementsByTagName('li')
        .forEach((li) {
      var firstLinkElements = li
          .getElementsByClassName('carousel-text-data recomm')[0]
          .getElementsByClassName('recomm-item-title ')[0]
          .getElementsByTagName('a')[0]
          .attributes['href'];
      if (firstLinkElements.isEmpty) {
        return null;
      }
      var secondLinkElements = li
          .getElementsByClassName('carousel-text-data recomm')[0]
          .getElementsByClassName('recomm-item-title recomm-right')[0]
          .getElementsByTagName('a')[0]
          .attributes['href'];
      if (secondLinkElements.isEmpty) {
        return null;
      }
      var firstTitleElements = li
          .getElementsByClassName('carousel-text-data recomm')[0]
          .getElementsByClassName('recomm-item-title ')[0]
          .getElementsByTagName('a')[0]
          .text;
      if (firstTitleElements.isEmpty) {
        return null;
      }
      var secondTitleElements = li
          .getElementsByClassName('carousel-text-data recomm')[0]
          .getElementsByClassName('recomm-item-title recomm-right')[0]
          .getElementsByTagName('a')[0]
          .text;
      if (secondTitleElements.isEmpty) {
        return null;
      }
      var firstImgElements = li
          .getElementsByClassName('carousel-text-data recomm')[0]
          .getElementsByClassName('recomm-circle recomm-circle-zoom')[0]
          .getElementsByTagName('img')[0]
          .attributes['src'];
      if (firstImgElements.isEmpty) {
        return null;
      }
      var secondImgElements = li
          .getElementsByClassName('carousel-text-data recomm')[0]
          .getElementsByClassName(
              'recomm-circle recomm-circle-zoom recomm-right')[0]
          .getElementsByTagName('img')[0]
          .attributes['src'];
      if (secondImgElements.isEmpty) {
        return null;
      }
      String nazwa1 = firstTitleElements;
      String nazwa2 = secondTitleElements;
      String linkacz1 = 'https://shinden.pl' + firstLinkElements;
      String linkacz2 = 'https://shinden.pl' + secondLinkElements;
      String obrazek1 = 'https://shinden.pl' + firstImgElements;
      String obrazek2 = 'https://shinden.pl' + secondImgElements;
      lista.add(new Recommendation(
          nazwa1, nazwa2, obrazek1, obrazek2, linkacz1, linkacz2));
      return lista;
    });
    return lista;
  }

  String getFirstName() {
    return firstName;
  }

  String getSecondName() {
    return secondName;
  }

  String getFirstImage() {
    return firstImage;
  }

  String getSecondImage() {
    return secondImage;
  }

  String getFirstLink() {
    return firstLink.split('recommendations')[0];
  }

  String getSecondLink() {
    return secondLink.split('recommendations')[0];
  }
}
