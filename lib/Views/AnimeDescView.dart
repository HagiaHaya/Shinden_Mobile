import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Getters/Anime.dart';
import '../Getters/Bonded.dart';
import '../Getters/CertainAnime.dart';
import '../Getters/Episodes.dart';
import 'AnimeBondedView.dart';
import 'AnimeEpisodesView.dart';
import 'AnimeGridView.dart';

class AnimeDesc extends StatefulWidget {
  final CertainAnime anime;

  AnimeDesc({Key key, this.anime}) : super(key: key);

  AnimeDescState createState() => AnimeDescState(anime);
}

class AnimeDescState extends State<AnimeDesc> {
  bool pressedDesc = false;
  int descTimes = 0;
  bool pressedMore = false;
  int moreTimes = 0;
  bool showPicture = true;
  int streamsTimes = 0;
  bool showStreams = false;
  bool showBonded = false;
  int bondedTimes = 0;
  final CertainAnime anime;

  AnimeDescState(this.anime);

  Container getStructuredContainer(CertainAnime anime, BuildContext context) {
    return new Container(
        child: new Column(
      children: <Widget>[
        showPicture
            ? Column(children: <Widget>[
                SizedBox(height: 20),
                FadeInImage.memoryNetwork(
                    image: anime.getimageURL(),
                    fit: BoxFit.fill,
                    placeholder: kTransparentImage)
              ])
            : SizedBox(),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlineButton(
                color: Colors.black38,
                splashColor: Colors.indigo,
                child: Text('Opis',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.left),
                onPressed: () {
                  if (descTimes % 2 == 0) {
                    setState(() {
                      pressedDesc = true;
                      pressedMore = false;
                      showPicture = false;
                      showStreams = false;
                      showBonded = false;
                      bondedTimes = 0;
                      moreTimes = 0;
                      streamsTimes = 0;
                    });
                  } else {
                    setState(() {
                      showBonded = false;
                      pressedDesc = false;
                      pressedMore = false;
                      showPicture = true;
                      showStreams = false;
                      bondedTimes = 0;
                      moreTimes = 0;
                      streamsTimes = 0;
                    });
                  }
                  descTimes++;
                },
              ),
            ),
            Expanded(
              child: OutlineButton(
                color: Colors.black38,
                splashColor: Colors.indigo,
                child: Text('Odcinki',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.left),
                onPressed: () {
                  setState(() {
                    if (streamsTimes % 2 == 0) {
                      setState(() {
                        showStreams = true;
                        showBonded = false;
                        pressedDesc = false;
                        pressedMore = false;
                        showPicture = false;
                        bondedTimes = 0;
                        descTimes = 0;
                        moreTimes = 0;
                      });
                    } else {
                      setState(() {
                        showStreams = false;
                        showBonded = false;
                        pressedDesc = false;
                        pressedMore = false;
                        showPicture = true;
                        descTimes = 0;
                        bondedTimes = 0;
                        moreTimes = 0;
                      });
                    }
                    streamsTimes++;
                  });
                },
              ),
            ),
            Expanded(
              child: OutlineButton(
                color: Colors.black38,
                splashColor: Colors.indigo,
                child: Text('Powiązane',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.left),
                onPressed: () {
                  if (bondedTimes % 2 == 0) {
                    setState(() {
                      pressedMore = false;
                      showBonded = true;
                      showStreams = false;
                      pressedDesc = false;
                      showPicture = false;
                      moreTimes = 0;
                      streamsTimes = 0;
                      descTimes = 0;
                    });
                  } else {
                    setState(() {
                      pressedMore = false;
                      showBonded = false;
                      showStreams = false;
                      pressedDesc = false;
                      showPicture = true;
                      moreTimes = 0;
                      streamsTimes = 0;
                      descTimes = 0;
                    });
                  }
                  bondedTimes++;
                },
              ),
            ),
            Expanded(
              child: OutlineButton(
                color: Colors.black38,
                splashColor: Colors.indigo,
                child: Text('Więcej',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.left),
                onPressed: () {
                  if (moreTimes % 2 == 0) {
                    setState(() {
                      pressedMore = true;
                      showBonded = false;
                      showStreams = false;
                      pressedDesc = false;
                      showPicture = false;
                      bondedTimes = 0;
                      streamsTimes = 0;
                      descTimes = 0;
                    });
                  } else {
                    setState(() {
                      pressedMore = false;
                      showBonded = false;
                      showStreams = false;
                      pressedDesc = false;
                      showPicture = true;
                      bondedTimes = 0;
                      streamsTimes = 0;
                      descTimes = 0;
                    });
                  }
                  moreTimes++;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        pressedDesc
            ? Center(
                child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: SingleChildScrollView(
                  child: Text(
                    anime.getDescription(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ))
            : SizedBox(),
        pressedMore
            ? Center(
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Ocena',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          anime.getRate() + '/10',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 24.0,
                          ),
                        ),
                        Text(
                          anime.getQuantity(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Tagi: ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: anime.getTags().length,
                            itemBuilder: (context, idx) {
                              return new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new GestureDetector(
                                      child: Text(
                                        anime.getTags()[idx],
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TryThis(
                                                    link: 'https://shinden.pl/series?genres-type=all&genres=' +
                                                        'i' +
                                                        anime
                                                            .getLinks()[idx]
                                                            .replaceAll(
                                                                new RegExp(
                                                                    '[^0-9]+'),
                                                                ''),
                                                    name:
                                                        anime.getTags()[idx])));
                                      },
                                    ),
                                    SizedBox(height: 8),
                                  ]);
                            })
                      ],
                    )))
            : SizedBox(),
        showStreams
            ? SingleChildScrollView(
                child: FutureBuilder<List<Episodes>>(
                future: Episodes.open(anime.getEpisodes()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new AnimeEpisodes(
                          anime: snapshot.data,
                          mainname: anime.getName(),
                          img: anime.getimageURL(),
                        )
                      : new Center(
                          child:
                              new SpinKitWave(color: Colors.white, size: 50.0));
                },
              ))
            : SizedBox(),
        showBonded
            ? SingleChildScrollView(
                child: FutureBuilder<List<BondedAnimes>>(
                future: BondedAnimes.open(
                    anime.getEpisodes().replaceAll('/all-episodes', '')),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new AnimeBondedView(
                          anime: snapshot.data,
                        )
                      : new Center(
                          child:
                              new SpinKitWave(color: Colors.white, size: 50.0));
                },
              ))
            : SizedBox(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: getStructuredContainer(anime, context));
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
        title: Text(name),
      ),
      body: new FutureBuilder<List<Animes>>(
        future: Animes.loadFromUrl(link),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new AnimeGridView(anime: snapshot.data, link: link)
              : new Center(
                  child: new SpinKitWave(color: Colors.white, size: 50.0));
        },
      ),
    );
  }
}
