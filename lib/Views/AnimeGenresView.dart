import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import '../Getters/Anime.dart';
import '../Getters/AnimeGenres.dart';
import 'AnimeGridView.dart';

class AnimeGenresView extends StatefulWidget {
  final List<Genres> genre;

  AnimeGenresView({Key key, this.genre}) : super(key: key);

  @override
  AnimeGenresState createState() => AnimeGenresState(genre);
}

class AnimeGenresState extends State<AnimeGenresView> {
  List<Genres> genres;
  List<bool> isChecked;
  Map<String, String> convertMap = new Map();
  String multipleidx;
  String multiplenames;

  AnimeGenresState(this.genres);

  bool pressedCheckbox = false;

  @override
  void initState() {
    List<String> allGenres = [];
    List<String> allLinks = [];
    for (int i = 0; i < genres.length; i++) {
      allGenres.add(genres[i].getGenre());
      allLinks.add(genres[i].getLink());
    }
    for (int i = 0; i < allGenres.length; i++) {
      convertMap[allGenres[i]] = allLinks[i];
    }
  }

  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      pressedCheckbox
          ? new OutlineButton(
              color: Colors.black38,
              splashColor: Colors.amberAccent,
              child: Text('Wyszukaj',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.left),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TryThis(
                            link:
                                'https://shinden.pl/series?genres-type=all&genres=' +
                                    multipleidx,
                            name: multiplenames)));
              },
            )
          : new OutlineButton(
              color: Colors.black38,
              splashColor: Colors.amberAccent,
              child: Text('Zaznacz kilka gatunków',
                  style: TextStyle(color: Colors.white30),
                  textAlign: TextAlign.left),
              onPressed: null),
      CheckboxGroup(
          activeColor: Colors.amberAccent,
          labels: genres.map((g) {
            return g.getGenre();
          }).toList(),
          itemBuilder: (Checkbox checkBox, Text label, int index) {
            return Row(children: <Widget>[
              new Expanded(
                  child: new GestureDetector(
                      child: label,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TryThis(
                                    link:
                                        'https://shinden.pl/series?genres-type=all&genres=' +
                                            genres[index].getLink(),
                                    name: genres[index].getGenre())));
                      })),
              SizedBox(width: 12.0),
              checkBox,
              SizedBox(width: 12.0),
            ]);
          },
          labelStyle: TextStyle(
            color: Colors.white70,
            fontSize: 30.0,
          ),
          onSelected: (List<String> checked) {
            _generateGenre(checked);
            setState(() {
              multiplenames = _generateNames(checked).replaceFirst(', ', '');
              multipleidx = _generateGenre(checked).replaceFirst('%3B', '');
              if (checked.length > 1) {
                pressedCheckbox = true;
              } else {
                pressedCheckbox = false;
              }
            });
          })
    ]);
  }

  String _generateNames(List<String> selected) {
    String slc = '';
    for (int i = 0; i < selected.length; i++) {
      slc = slc + ', ' + selected[i];
    }
    return slc;
  }

  String _generateGenre(List<String> selected) {
    String slc = '';
    for (int i = 0; i < selected.length; i++) {
      slc = slc + '%3B' + convertMap[selected[i]];
    }
    return slc;
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
