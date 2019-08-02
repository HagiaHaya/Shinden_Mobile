import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Getters/Episodes.dart';
import '../Getters/Hosts.dart';
import '../Views/AnimeHostsView.dart';

class AnimeEpisodes extends StatelessWidget {
  final List<Episodes> anime;
  final String mainname;
  final String img;

  AnimeEpisodes({Key key, this.anime, this.mainname, this.img})
      : super(key: key);

  Row getConstructedRow(Episodes anime, BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(anime.getNumber(),
            style: TextStyle(
              color: Colors.white70,
            )),
        Spacer(flex: 5),
        Row(
          children: <Widget>[
            Text(anime.getTitle(),
                style: TextStyle(
                  color: Colors.white70,
                )),
          ],
        ),
        Spacer(flex: 5),
        Text(anime.getEmission(),
            style: TextStyle(
              color: Colors.white70,
            )),
        Spacer(flex: 5),
        RaisedButton(
          color: Colors.black38,
          highlightColor: Colors.indigo,
          child: Text('Wybierz',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.left),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Probability(
                    probe: anime.getLink(),
                    name: (mainname.replaceAll('Anime: ', '') +
                        ' - ' +
                        anime.getTitle()),
                    img: img,
                  ),
                ));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: List.generate(anime.length, (index) {
        return getConstructedRow(anime[index], context);
      }),
    );
  }
}

class Probability extends StatelessWidget {
  final String probe;
  final String name;
  final String img;

  Probability({Key key, this.probe, this.name, this.img});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          backgroundColor: Colors.black38,
          title: Text('Serwisy'),
        ),
        body: new FutureBuilder<List<Hosts>>(
          future: Hosts.open(probe),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new AnimeHosts(anime: snapshot.data, name: name, img: img)
                : new Center(
                    child: new SpinKitWave(color: Colors.white, size: 50.0));
          },
        ));
  }
}
