import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Getters/Anime.dart';
import '../Getters/CertainAnime.dart';
import 'AnimeDescView.dart';

class AnimeMainView extends StatelessWidget {
  final List<Animes> anime;

  AnimeMainView({Key key, this.anime}) : super(key: key);

  Card getStructuredRowCell(Animes anime, BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return new Card(
      color: Colors.white10,
      elevation: 1.5,
      child: new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TryThis(link: anime.getLink(), name: anime.getName())));
        },
        child: new Column(
          children: <Widget>[
            new ClipRRect(
              borderRadius: new BorderRadius.circular(20.0),
              child: FadeInImage.memoryNetwork(
                image: anime.getimageURL(),
                fit: BoxFit.fill,
                width: queryData.size.width * 0.4,
                height: queryData.size.width * 0.4 * (350 + 11 + 16) / 225,
                placeholder: kTransparentImage,
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                child: new Text(
                  anime.name,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.0,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
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
          future: CertainAnime.open(link),
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
