import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Getters/Anime.dart';
import '../Getters/CertainAnime.dart';
import 'AnimeDescView.dart';

class AnimeMainView extends StatefulWidget {
  final List<Animes> anime;

  AnimeMainView({Key key, this.anime});

  @override
  AnimeMainViewState createState() => AnimeMainViewState(this.anime);
}

class AnimeMainViewState extends State<AnimeMainView> {
  final List<Animes> anime;
  String nazwa = '';

  _isUpdated(name) {
    setState(() {
      nazwa = name;
    });
  }

  AnimeMainViewState(this.anime);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return new ListView(children: <Widget>[
      Swiper(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return new ClipRRect(
            borderRadius: new BorderRadius.circular(20.0),
            child: FadeInImage.memoryNetwork(
              image: anime[index].getimageURL(),
              fit: BoxFit.fill,
              placeholder: kTransparentImage,
            ),
          );
        },
        itemCount: anime.length,
        autoplay: true,
        autoplayDisableOnInteraction: true,
        duration: 300,
        fade: 0.8,
        layout: SwiperLayout.CUSTOM,
        customLayoutOption:
            new CustomLayoutOption(startIndex: -1, stateCount: 3)
                .addRotate([0, 0.0, 0]).addTranslate([
          new Offset(-310.0, 20.0),
          new Offset(0.0, 0.0),
          new Offset(310.0, 20.0)
        ]),
        itemWidth: 300.0,
        itemHeight: queryData.size.height * 0.65,
        onIndexChanged: (index) {
          nazwa = anime[index].getName();
          _isUpdated(nazwa);
        },
        onTap: (index) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TryThis(
                      link: anime[index].getLink(),
                      name: anime[index].getName())));
        },
      ),
      Text(
        nazwa,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 15.0,
        ),
      )
    ]);
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
