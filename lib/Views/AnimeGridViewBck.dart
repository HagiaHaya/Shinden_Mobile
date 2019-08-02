import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Getters/Anime.dart';
import '../Getters/CertainAnime.dart';
import 'AnimeDescView.dart';

class AnimeGridView extends StatelessWidget {
  final List<Animes> anime;

  AnimeGridView({Key key, this.anime}) : super(key: key);

  Card getStructuredGridCell(Animes anime, BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return new Card(
        borderOnForeground: false,
        color: Colors.white10,
        elevation: 1.5,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TryThis(
                            link: anime.getLink(), name: anime.getName())));
              },
              child: new ClipRRect(
                borderRadius: new BorderRadius.circular(20.0),
                child: new FadeInImage.memoryNetwork(
                  height: queryData.size.width * 0.75,
                  image: anime.getimageURL(),
                  fit: BoxFit.fill,
                  placeholder: kTransparentImage,
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: queryData.size.width * 0.4,
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      shrinkWrap: true,
      children: List.generate(anime.length, (index) {
        return getStructuredGridCell(anime[index], context);
      }),
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
