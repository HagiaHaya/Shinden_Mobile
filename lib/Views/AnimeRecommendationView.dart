import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Getters/CertainAnime.dart';
import '../Getters/Recommendation.dart';
import 'AnimeDescView.dart';

class AnimeRecommendationView extends StatelessWidget {
  final List<Recommendation> anime;

  AnimeRecommendationView({Key key, this.anime}) : super(key: key);

  Card getStructuredRowCell(Recommendation anime, BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return new Card(
      color: Colors.white10,
      elevation: 1.5,
      child: new Column(
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TryThis(
                          link: anime.getFirstLink(),
                          name: anime.getFirstName())));
            },
            child: new Column(
              children: <Widget>[
                new ClipOval(
                  child: FadeInImage.memoryNetwork(
                    image: anime.getFirstImage(),
                    fit: BoxFit.fill,
                    width: queryData.size.width * 0.3,
                    height: queryData.size.width * 0.3,
                    placeholder: kTransparentImage,
                  ),
                ),
                new Center(
                  child: new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      child: new Center(
                        child: new Text(
                          anime.getFirstName(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.0,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Text(
            'DO',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20.0,
            ),
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          SizedBox(height: 15),
          new GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TryThis(
                          link: anime.getSecondLink(),
                          name: anime.getSecondName())));
            },
            child: new Column(
              children: <Widget>[
                new ClipOval(
                  child: FadeInImage.memoryNetwork(
                    image: anime.getSecondImage(),
                    fit: BoxFit.fill,
                    width: queryData.size.width * 0.3,
                    height: queryData.size.width * 0.3,
                    placeholder: kTransparentImage,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    child: new Center(
                      child: new Text(
                        anime.getSecondName(),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.0,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: new Row(
        children: List.generate(anime.length, (index) {
          return getStructuredRowCell(anime[index], context);
        }),
      ),
    );
  }
}

class TryThis extends StatelessWidget {
  final String link;
  final String name;

  TryThis({Key key, this.link, this.name});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          backgroundColor: Colors.black38,
          title: Text(
            name,
          ),
        ),
        body: new FutureBuilder<CertainAnime>(
          future: CertainAnime.open(link.substring(0, link.length - 1)),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new AnimeDesc(anime: snapshot.data)
                : new Center(
                    child: new SpinKitWave(color: Colors.white, size: 50.0));
          },
        ));
  }
}
