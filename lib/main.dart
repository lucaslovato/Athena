import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'library.dart';

typedef void OnError(Exception exception);

void main() {
  runApp(new MaterialApp(home: new ExampleApp()));
}

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => new _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  String localFilePath;

  Widget localAsset(BuildContext ctx) {
    return Center(
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _btn('Select File', () => Library().addFolders(ctx),
                      Icons.folder),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _btn('Play', () => audioCache.play('audio.mp3'),
                            Icons.play_arrow),
                        _btn(
                            'Pause', () => advancedPlayer.pause(), Icons.pause),
                        _btn('Stop', () => advancedPlayer.stop(), Icons.stop)
                      ]),
                  slider()
                ])));
  }

  Widget _btn(String txt, VoidCallback onPressed,IconData x) {
    return ButtonTheme(
      minWidth: 60.0,
      child: IconButton(
        icon: Icon(x),
        color: Colors.blue,
        onPressed: onPressed)
    );
  }

  Widget slider() {
    return Slider(
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        });
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.audiotrack)),
              Tab(icon: Icon(Icons.library_books)),
            ],
          ),
          title: Text('Athena'),
        ),
        body: TabBarView(
          children: [localAsset(context), Icon(Icons.library_books)],
        ),
      ),
    );
  }
}
