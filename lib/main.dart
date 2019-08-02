import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen/screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

import 'API.dart';
import 'Changelog.dart';
import 'Getters/Anime.dart';
import 'Getters/AnimeGenres.dart';
import 'Login.dart';
import 'Views/AnimeGenresView.dart';
import 'Views/AnimeGridView.dart';
import 'Views/AnimeMainView.dart';

void main() => runApp(Shinden());

class Shinden extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: new ShindenLogin(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new ShindenLogin(),
        '/main': (BuildContext context) => new ShindenMain(),
        '/lookup': (BuildContext context) => new ShindenUp(),
        '/genres': (BuildContext context) => new ShindenGenres(),
      },
    );
  }
}

class ShindenLogin extends StatefulWidget {
  @override
  ShindenLoginState createState() => ShindenLoginState();
}

class ShindenLoginState extends State<ShindenLogin> {
  final email = TextEditingController();
  final pass = TextEditingController();
  var hasError = false;
  var emptyThings = false;
  var trueLogged = true;

  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    API.getInstance().then((api) {
      api.loggedIn().then((logged) {
        if (logged) {
          if (trueLogged) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ShindenMain()));
            trueLogged = false;
          }
        }
      });
    });
    return new Scaffold(
      appBar: AppBar(
        title: Text('Logowanie'),
        backgroundColor: Colors.black38,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.network(
                'https://shinden.pl/f//skins/2/img/shinden-title.png'),
            TextFormField(
                controller: email,
                style: TextStyle(
                  color: Colors.white70,
                ),
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    hintStyle: TextStyle(
                      color: Colors.white70,
                    ))),
            TextFormField(
              controller: pass,
              style: TextStyle(
                color: Colors.white70,
              ),
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Hasło',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  hintStyle: TextStyle(
                    color: Colors.white70,
                  )),
            ),
            RaisedButton(
              color: Colors.black38,
              highlightColor: Colors.amberAccent,
              child: Text('Zaloguj',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.left),
              onPressed: () {
                if (email.text.isEmpty && pass.text.isEmpty) {
                  setState(() {
                    emptyThings = true;
                    hasError = false;
                  });
                } else {
                  getIn(email.text, pass.text).then((success) {
                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShindenMain()),
                      );
                    } else {
                      setState(() {
                        hasError = true;
                        emptyThings = false;
                      });
                    }
                  });
                }
              },
            ),
            hasError
                ? Text('Zły login/hasło',
                    style: TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.left)
                : SizedBox(),
            emptyThings
                ? Text('Proszę wypełnić wymagane pola',
                    style: TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.left)
                : SizedBox(),
          ],
        ),
      ),
      backgroundColor: Colors.white10,
    );
  }
}

class ShindenGenres extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: Text('Gatunki'),
      ),
      body: new FutureBuilder<List<Genres>>(
        future: Genres.addGenres('https://shinden.pl/series?'),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new AnimeGenresView(genre: snapshot.data)
              : new Center(
                  child: new SpinKitWave(color: Colors.white, size: 50.0));
        },
      ),
      drawer: leftDrawer(context),
    );
  }
}

class ShindenDownloaded extends StatefulWidget {
  final List<File> downloadedVideos;
  final List<File> downloadedImages;

  ShindenDownloaded({Key key, this.downloadedVideos, this.downloadedImages})
      : super(key: key);

  @override
  ShindenDownloadedState createState() =>
      ShindenDownloadedState(this.downloadedVideos, this.downloadedImages);
}

class ShindenDownloadedState extends State<ShindenDownloaded> {
  ShindenDownloadedState(this.downloadedVideos, this.downloadedImages);

  void _getPollutedVideos() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory(appDocDirectory.path).createSync();
    final dir = Directory(appDocDirectory.path + '/animes');
    var files = dir.listSync().toList();
    files.forEach((e) {
      if (e.toString().contains('.mp4')) {
        downloadedVideos.add(e);
      }
    });
  }

  final List<File> downloadedImages;
  final List<File> downloadedVideos;

  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return new Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          backgroundColor: Colors.black38,
          title: Text('Pobrane'),
        ),
        drawer: leftDrawer(context),
        body: new ListView.builder(
          itemCount: downloadedImages.length,
          itemBuilder: (context, idx) {
            return new Column(children: <Widget>[
              Card(
                borderOnForeground: true,
                color: Colors.white10,
                elevation: 1.5,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    // tutaj do zdjecia dopasowuje video odpowiednie
                    new GestureDetector(
                      onTap: () {
                        List<File> newDownloaded = [];
                        downloadedVideos.forEach((file) {
                          if (file.toString().contains(downloadedImages[idx]
                              .toString()
                              .split('/animes/')[1]
                              .replaceAll("'", '')
                              .replaceAll('.img', ''))) {
                            newDownloaded.add(file);
                          }
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificDownloadList(
                                      name: downloadedImages[idx]
                                          .toString()
                                          .split('/animes/')[1]
                                          .replaceAll("'", '')
                                          .replaceAll('.img', ''),
                                      downloadedVideos: newDownloaded,
                                      imgFile: downloadedImages[idx],
                                      downloadedImages: downloadedImages,
                                    )));
                      },
                      child: new ClipRRect(
                        borderRadius: new BorderRadius.circular(0.0),
                        child: new Image.file(
                          downloadedImages[idx],
                          //tutaj wyswietla zdjecie o podanym idx
                          fit: BoxFit.fill,
                          height: queryData.size.height * 0.75,
                          width: queryData.size.width,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        width: queryData.size.width * 0.4,
                        child: new Center(
                          child: Text(
                            downloadedImages[idx]
                                .toString()
                                .split('/animes/')[1]
                                .replaceAll("'", '')
                                .replaceAll('.img', ''),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15.0,
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
              SizedBox(height: 20),
            ]);
          },
        ));
  }
}

class SpecificDownloadList extends StatefulWidget {
  final String name;
  final List<File> downloadedVideos;
  final List<File> downloadedImages;
  final File imgFile;

  SpecificDownloadList(
      {Key key,
      this.name,
      this.downloadedVideos,
      this.imgFile,
      this.downloadedImages})
      : super(key: key);

  @override
  SpecificDownloadListState createState() => SpecificDownloadListState(
        this.name,
        this.downloadedVideos,
        this.downloadedImages,
        this.imgFile,
      );
}

class SpecificDownloadListState extends State<SpecificDownloadList> {
  final String name;
  final List<File> downloadedVideos;
  final List<File> downloadedImages;
  final File imgFile;

  SpecificDownloadListState(
      this.name, this.downloadedVideos, this.downloadedImages, this.imgFile);

  void _getPollutedImages() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory(appDocDirectory.path).createSync();
    final dir = Directory(appDocDirectory.path + '/animes');
    var files = dir.listSync().toList();
    files.forEach((e) {
      if (e.toString().contains('.img')) {
        downloadedImages.add(e);
      }
    });
  }

  void _getPollutedVideos() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory(appDocDirectory.path).createSync();
    final dir = Directory(appDocDirectory.path + '/animes');
    var files = dir.listSync().toList();
    files.forEach((e) {
      if (e.toString().contains(imgFile
              .toString()
              .split('/animes/')[1]
              .replaceAll("'", '')
              .replaceAll('.img', '')) &&
          e.toString().contains('.mp4')) {
        downloadedVideos.add(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              await downloadedVideos.clear();
              await downloadedImages.clear();
              await _getPollutedVideos();
              await _getPollutedImages();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShindenDownloaded(
                          downloadedImages: downloadedImages,
                          downloadedVideos: downloadedVideos)));
            },
          ),
          backgroundColor: Colors.black38,
          title: Text(name),
        ),
        body: ListView.builder(
            itemCount: downloadedVideos.length,
            itemBuilder: (context, idx) {
              return new Card(
                  color: Colors.transparent,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          downloadedVideos[idx]
                              .toString()
                              .split('/animes/')[1]
                              .replaceAll("'", '')
                              .split('- ')[1]
                              .replaceAll('.mp4', ''),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18.0,
                          ),
                          softWrap: true,
                        ),
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShindenVideo(
                                          title: downloadedVideos[idx]
                                              .toString()
                                              .split('/animes/')[1]
                                              .replaceAll("'", '')
                                              .split('- ')[1]
                                              .replaceAll('.mp4', ''),
                                          file: downloadedVideos[idx]),
                                    ));
                              }),
                          SizedBox(width: 5),
                          Text(
                            '|',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.white70,
                              ),
                              onPressed: () async {
                                final snackBar = SnackBar(
                                    content: Text(
                                  'Usunięto: ' +
                                      downloadedVideos[idx]
                                          .toString()
                                          .split('/animes/')[1]
                                          .replaceAll("'", '')
                                          .replaceAll('.mp4', ''),
                                ));
                                Scaffold.of(context).showSnackBar(snackBar);
                                await downloadedVideos[idx]
                                    .deleteSync(recursive: true);
                                setState(() {
                                  downloadedVideos
                                      .remove(downloadedVideos[idx]);
                                  if (downloadedVideos.length == 0) {
                                    imgFile.deleteSync();
                                  }
                                });
                              }),
                        ])
                      ]));
            }));
  }
}

Drawer leftDrawer(BuildContext context) {
  final lookfor = TextEditingController();
  final List<File> downloadedVideos = [];
  final List<File> downloadedImages = [];
  void _getPollutedVideos() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory(appDocDirectory.path).createSync();
    final dir = Directory(appDocDirectory.path + '/animes');
    var files = dir.listSync().toList();
    files.forEach((e) {
      if (e.toString().contains('.mp4')) {
        downloadedVideos.add(e);
      }
    });
  }

  void _getPollutedImages() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory(appDocDirectory.path).createSync();
    final dir = Directory(appDocDirectory.path + '/animes');
    var files = dir.listSync().toList();
    files.forEach((e) {
      if (e.toString().contains('.img')) {
        downloadedImages.add(e);
      }
    });
  }

  return new Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: new Column(
            children: <Widget>[
              Text(
                'Zalogowano jako: ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                ),
              ),
              Text(
                loggedUser,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 25.0,
                ),
              ),
              SizedBox(height: 10),
              ClipOval(
                child: FadeInImage.memoryNetwork(
                  fit: BoxFit.contain,
                  height: 70,
                  width: 70,
                  image: loggedAvatar,
                  placeholder: kTransparentImage,
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.rectangle,
          ),
        ),
        ListTile(
          title: Text('Strona główna'),
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/main', (Route<dynamic> route) => false);
          },
        ),
        ListTile(
          title: Text('Wyszukaj anime'),
          onTap: () {
            Navigator.pop(context);
            showDialog(
                context: context,
                // ignore: deprecated_member_use
                child: new SimpleDialog(
                  backgroundColor: Colors.black38,
                  children: <Widget>[
                    Center(
                      child: Text('Podaj nazwę: ',
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                          textAlign: TextAlign.left),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    TextField(
                        controller: lookfor,
                        autofocus: true,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                            hintText: 'Nazwa',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ))),
                    RaisedButton(
                      shape: StadiumBorder(),
                      color: Colors.black38,
                      splashColor: Colors.amberAccent,
                      child: Text('Wyszukaj',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.left),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShindenUp(lookfor: lookfor.text)));
                      },
                    ),
                  ],
                ));
          },
        ),
        ListTile(
          title: Text('Gatunki'),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ShindenGenres()));
          },
        ),
        ListTile(
          title: Text('Pobrane'),
          onTap: () async {
            await _getPollutedVideos();
            await _getPollutedImages();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ShindenDownloaded(
                          downloadedVideos: downloadedVideos,
                          downloadedImages: downloadedImages,
                        )));
          },
        ),
        ListTile(
          title: Text('Wyloguj'),
          onTap: () {
            // wyloguj sie
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', (Route<dynamic> route) => false);
          },
        ),
      ],
    ),
  );
}

class ShindenVideo extends StatefulWidget {
  final String title;
  final File file;

  ShindenVideo({Key key, this.title, this.file}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShindenVideoState(title, file);
  }
}

class ShindenVideoState extends State<ShindenVideo> {
  final String title;
  final File file;

  ShindenVideoState(this.title, this.file);

  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(file);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.amber,
          handleColor: Colors.deepPurpleAccent,
          backgroundColor: Colors.black,
          bufferedColor: Colors.lightGreenAccent,
        ),
        placeholder: new SpinKitWave(color: Colors.white, size: 50.0),
        autoInitialize: false,
        errorBuilder: (context, errorMessage) {
          return Center(
              child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ));
        });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.dark().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Wyszukiwanie anime
class ShindenUp extends StatelessWidget {
  final String lookfor;

  ShindenUp({Key key, this.lookfor});

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: Text(lookfor),
      ),
      body: new FutureBuilder<List<Animes>>(
        future: Animes.search(lookfor),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new AnimeGridView(
                  anime: snapshot.data,
                  link: 'https://shinden.pl/series?search=' + lookfor)
              : new Center(
                  child: new SpinKitWave(color: Colors.white, size: 50.0));
        },
      ),
      drawer: leftDrawer(context),
    );
  }
}

class ShindenMain extends StatefulWidget {
  @override
  createState() => ShindenMainState();
}

//main page
class ShindenMainState extends State<ShindenMain> {
  final lookfor = TextEditingController();
  final List<File> downloaded = [];
  bool pressedChangelog = false;
  int times = 0;

  @override
  void dispose() {
    lookfor.dispose();
    super.dispose();
  }

  @override
  initState() {
    Screen.keepOn(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: Text('Strona główna'),
      ),
      body: ListView(children: <Widget>[
        SizedBox(height: 15),
        Center(
            child: Text('Ostatnie sezony',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30.0,
                ))),
        SizedBox(height: 15),
        new FutureBuilder<List<Animes>>(
          future: Animes.mainList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new Container(
                    height: queryData.size.height * 0.7,
                    child: AnimeMainView(anime: snapshot.data))
                : new Center(
                    child: new SpinKitWave(color: Colors.white, size: 50.0));
          },
        ),
        SizedBox(height: 15),
//        Center(
//            child: Text('- Rekomendacje -',
//                style: TextStyle(
//                  color: Colors.white70,
//                  fontSize: 30.0,
//                ))),
//        SizedBox(height: 15),
//        new FutureBuilder<List<Recommendation>>(
//          future: Recommendation.recommendation(),
//          builder: (context, snapshot) {
//            if (snapshot.hasError) print(snapshot.error);
//            return snapshot.hasData
//                ? new AnimeRecommendationView(anime: snapshot.data)
//                : new Center(
//                    child: new SpinKitWave(color: Colors.white, size: 50.0));
//          },
//        ),
        SizedBox(height: 5),
        Center(
            child: new OutlineButton(
          color: Colors.black38,
          splashColor: Colors.amberAccent,
          shape: StadiumBorder(),
          child: Text('Changelog',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.left),
          onPressed: () {
            if (times % 2 == 0) {
              setState(() {
                pressedChangelog = true;
              });
            } else {
              setState(() {
                pressedChangelog = false;
              });
            }
            times++;
          },
        )),
        pressedChangelog
            ? Center(
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: generateChangelog()))
            : SizedBox(),
      ]),
      drawer: leftDrawer(context),
      backgroundColor: Colors.white10,
    );
  }
}
