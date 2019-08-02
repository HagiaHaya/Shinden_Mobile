import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html/parser.dart' as parser;
import 'package:path_provider/path_provider.dart';
import 'package:shinden_mobile/Hosts/VK.dart';
import 'package:shinden_mobile/Hosts/cda.dart';
import 'package:video_player/video_player.dart';

import '../API.dart';
import '../Getters/Hosts.dart';
import '../Hosts/Facebook.dart';
import '../Hosts/MP4Upload.dart';
import '../Hosts/Openload.dart';

class AnimeHosts extends StatelessWidget {
  final List<Hosts> anime;
  final String name;
  final String img;

  AnimeHosts({Key key, this.anime, this.name, this.img}) : super(key: key);

  Row getConstructedRow(Hosts anime, BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(anime.getService(),
            style: TextStyle(
              color: Colors.white70,
            )),
        Spacer(flex: 5),
        Row(
          children: <Widget>[
            Text(anime.getQuality(),
                style: TextStyle(
                  color: Colors.white70,
                )),
          ],
        ),
        Spacer(flex: 5),
        Text(anime.getSubtitles(),
            style: TextStyle(
              color: Colors.white70,
            )),
        Spacer(flex: 5),
        Text(anime.getAdded(),
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
          onPressed: () async {
            final waitsnack =
                SnackBar(content: Text('Proszę poczekać 5 sekund.'));
            Scaffold.of(context).showSnackBar(waitsnack);
            String _link;
            bool _working = false;
            if (_link != null) {
              return Future.value(_link);
            }
            if (_working) {
              return Future.value();
            }
            _working = true;
            String id = anime.getID().toString();
            var api = API.getNullableInstance();
            var seconds = await api
                .get("https:" +
                    api.xhrService +
                    "/" +
                    id +
                    "/player_load?auth=" +
                    api.basicAuth.replaceAll("=", "%3D"))
                .then((response) {
              return int.parse(response);
            });
            sleep(Duration(seconds: seconds));

            var links = await api
                .get("https:" +
                    api.xhrService +
                    "/" +
                    id +
                    "/player_show?auth=" +
                    api.basicAuth.replaceAll("=", "%3D"))
                .then((response) {
              var parse = parser.parse(response);
              return parse.getElementsByTagName("iframe").map((e) {
                if (e.attributes["src"].startsWith("//")) {
                  return "https:" + e.attributes["src"];
                }
                return e.attributes["src"];
              }).toList(growable: false);
            });
            var link = links.first;
            if (link.contains('openload') ||
                link.contains('oload') ||
                link.contains('mp4upload') ||
                link.contains("vk.com") ||
                link.contains("cda.pl")) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Video(links, name, img)));
            } else {
              final snackBar = SnackBar(
                  content:
                      Text('Hosting nieobsługiwany. \nLink do video: ' + link));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      primary: true,
      children: List.generate(anime.length, (index) {
        return getConstructedRow(anime[index], context);
      }),
    );
  }
}

class Video extends StatefulWidget {
  Video(this.links, this.filename, this.img);

  final String img;
  final String filename;
  final List<String> links;

  @override
  State<StatefulWidget> createState() {
    return _VideoState(links, filename, img);
  }
}

class _VideoState extends State<Video> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  String img;
  String _link;
  String filename;

  _VideoState(this.links, this.filename, this.img);

  final List<String> links;

  Future<String> checkLink(List<String> initlinks) async {
    if (_link != null) {
      return Future.value(_link);
    }
    if (links.map((e) {
      return e.contains("facebook.com");
    }).contains(true)) {
      return getFacebookUploadVideo(links);
    }
    if (links.length == 1) {
      var link = links.first;
      if (link.contains('openload') || link.contains('oload')) {
        print('Its openload ' + link);
        return getOpenloadVideo(link);
      }
      if (link.contains('mp4upload')) {
        print('Its mp4upload ' + link);
        return getMP4UploadVideo(link);
      }
      if (link.contains('flix555')) {
        print('Its flix555 ' + link);
        return getMP4UploadVideo(link);
      }
      if (link.contains("vk.com")) {
        print('Its vk ' + link);
        return getVKUploadVideo(link);
      }
      if (link.contains("cda.pl")) {
        print('Its cda ' + link);
        return getCDAUploadVideo(link);
      }
    }
    return Future.value(null);
  }

  @override
  void initState() {
    super.initState();
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
      title: widget.filename,
      theme: ThemeData.dark().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.filename),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: new FutureBuilder<String>(
                    future: checkLink(this.links),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          _chewieController == null &&
                          snapshot.data != null) {
                        _link = snapshot.data;
                        _videoPlayerController =
                            VideoPlayerController.network(snapshot.data);
                        _chewieController = ChewieController(
                            videoPlayerController: _videoPlayerController,
                            aspectRatio: 16 / 9,
                            autoPlay: true,
                            looping: false,
                            routePageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondAnimation,
                                provider) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (BuildContext context, Widget child) {
                                  return VideoScaffold(
                                    child: Scaffold(
                                      resizeToAvoidBottomPadding: false,
                                      body: Container(
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                        child: provider,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            materialProgressColors: ChewieProgressColors(
                              playedColor: Colors.amber,
                              handleColor: Colors.deepPurpleAccent,
                              backgroundColor: Colors.black,
                              bufferedColor: Colors.lightGreenAccent,
                            ),
                            placeholder: new SpinKitWave(
                                color: Colors.white, size: 50.0),
                            autoInitialize: false,
                            errorBuilder: (context, errorMessage) {
                              return Center(
                                  child: Text(
                                errorMessage,
                                style: TextStyle(color: Colors.white),
                              ));
                            });
                      }

                      return snapshot.hasData
                          ? new Chewie(controller: _chewieController)
                          : new Center(
                              child: new SpinKitWave(
                                  color: Colors.white, size: 50.0));
                    }),
              ),
            ),
            OutlineButton(
              child: Text('Pobierz'),
              color: Colors.black38,
              splashColor: Colors.indigo,
              onPressed: () {
                _downloadVideo(_link);
                _downloadImg(img);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _downloadVideo(String url) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory(appDocDirectory.path).createSync();
    final dir = Directory(appDocDirectory.path + '/animes');
    if (!dir.existsSync()) {
      dir.createSync();
    }
    await FlutterDownloader.enqueue(
      fileName: filename + '.mp4',
      url: url,
      savedDir: dir.path,
      showNotification: true,
      openFileFromNotification: false,
    );
  }

  void _downloadImg(String url) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory(appDocDirectory.path).createSync();
    final dir = Directory(appDocDirectory.path + '/animes');
    await FlutterDownloader.enqueue(
      fileName: filename.split(' - ')[0] + '.img',
      url: url,
      savedDir: dir.path,
      showNotification: false,
      openFileFromNotification: false,
    );
  }
}

class VideoScaffold extends StatefulWidget {
  const VideoScaffold({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _VideoScaffoldState();
}

class _VideoScaffoldState extends State<VideoScaffold> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
