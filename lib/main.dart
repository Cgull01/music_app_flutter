// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';
import 'package:music_app/queue_view.dart';

import 'globals.dart' as globals;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:id3/id3.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/bottom_music_bar.dart';
import 'package:music_app/common.dart';
import 'package:music_app/constants/routes.dart';
import 'package:music_app/homePageWidgets/folder_button.dart';
import 'package:music_app/homePageWidgets/mainmenu_button.dart';
import 'package:music_app/music_view.dart';
import 'package:music_app/notifiers/play_button_notifier.dart';
import 'package:music_app/notifiers/progress_notifier.dart';
import 'package:music_app/notifiers/repeat_button_notifier.dart';
import 'package:music_app/page_panager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

// FIRST: read and display music files, playlist names and stuff
// Look into filemanager it uses permission_handler
// look into sample code and maybe try it
// widgets for later use: tabs

//       Future <Directory> dir = await getExternalStorageDirectory();
// PROBLEM: can't read external storage
// potential fix: path_provider library

//bottom_music_bar has delayed state update, BUT titlelistener works nice like wat
// TODO: big text overflow, make audio control sizes normal V
// TODO: maybe scrollable text V
// TODO: progress bar at the bottom of screen V
// TODO: queue screen
// TODO: images
// TODO: alphabet + sorting
// TODO: music CRUD and other controls
// TODO: folder display info and screens
// TODO: Search bar
// TODO: localstorage with play amount, last queue, favorite
// TODO: responsive ui
// TODO: next up
// TODO: redesign, extract color from albums
// TODO: extternal storage
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black87, // navigation bar color
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
    systemNavigationBarDividerColor: Colors.greenAccent, //Navigation bar divider color

    statusBarColor: Colors.transparent, // status bar color
    statusBarIconBrightness: Brightness.light, //status barIcon Brightness
  ));
  runApp(const MyApp());
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    _init();
  }

  Directory dir = Directory('/storage/emulated/0/');
  late final List<FileSystemEntity> _files = dir.listSync(recursive: true, followLinks: false);

  void readMusicFilesDirectory() async {
    Playlist PL = Playlist(Title: '', Songs: []);
    String? previousFolderTitle;
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) {
        List<int> mp3Bytes = File(entity.path).readAsBytesSync();
        MP3Instance mp3instance = MP3Instance(mp3Bytes);

        String currentFolderTitle = entity.path.split('/').elementAt(entity.path.split('/').length - 2);

        // creates a new music folder
        if (previousFolderTitle != currentFolderTitle && previousFolderTitle != null) {
          PL.Title = previousFolderTitle;

          setState(() {
            // ! probably setting the state is bad everytime we get new song
            Playlists.add(PL);
          });
          PL = Playlist(Title: '', Songs: []);
        } else // adds a new song to playlist
        if (previousFolderTitle == currentFolderTitle && previousFolderTitle != null) {
          if (mp3instance.parseTagsSync()) {
            //print(mp3instance.getMetaTags());

            PL.Songs.add(musicData(
              songPath: entity,
              Title: mp3instance.metaTags['Title'].toString(),
              Artist: mp3instance.metaTags['Artist'],
              Album: mp3instance.metaTags['Album'],
            ));
          } else {
            PL.Songs.add(musicData(
              songPath: entity,
              Title: "Unknown Title",
              Artist: "Unknown Artist",
              Album: "Unknown Album",
            ));
          }
        }

        previousFolderTitle = currentFolderTitle;
      }
    }
    if (previousFolderTitle != null) {
      PL.Title = previousFolderTitle;
    }
  }

  checkPermissionManageStorage() async {
    var storageStatus = await Permission.storage.status;

    if (!storageStatus.isGranted) await Permission.storage.request();

    if (await Permission.storage.isGranted) {
      readMusicFilesDirectory();

      // for (Playlist p in Playlists) {
      //   print("${p.Title} (${p.Songs.length} songs)");
      //   for (musicData m in p.Songs) {
      //     print("${m.songPath} - ${m.Title} - ${m.Artist}");
      //   }
      // }

      //_pageManager.setPlaylist(Playlists[SelectedPlaylistIndex].Songs);
      //_pageManager.addSong();
    } else {
      // Ask for permission
      // showToast("Provide Camera permission to use camera.", position: ToastPosition.bottom);
    }
  }

  Future<void> _init() async {
    await checkPermissionManageStorage();

    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // await _player.setAsset("assets/audio/horse.mp3");
      // await _player.setAudioSource(AudioSource.uri(Uri.parse("/storage/emulated/0/Music/internal storage music/199X, DrDisrespect - Gillette.mp3")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    _pageManager.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      _player.positionStream,
      _player.bufferedPositionStream,
      _player.durationStream,
      (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(16, 16, 16, 1),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(16, 16, 16, 1),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(60, 60, 60, 1),
          ),
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Color.fromRGBO(42, 41, 45, 1),
        ),
      ),
      home: const MyHomePage(),
      routes: {
        musicRoute: (context) => const MusicView(),
        musicListViewRoute: (context) => const MusicListViewer(),
        queueRoute: (context) => const QueueView(),
      },
    );
  }
}

late final PageManager _pageManager = globals.pageManager;

final _player = AudioPlayer();

List<musicData> AllSongs = [];

List<Playlist> Playlists = [];

int SelectedPlaylistIndex = 0;

class musicData {
  final FileSystemEntity songPath;
  final String? Title;
  final String? Artist;
  final String? Album;

  musicData({
    required this.songPath,
    this.Title,
    this.Artist,
    this.Album,
  });
}

class Playlist {
  final List<musicData> Songs;
  String Title;
  Playlist({
    required this.Title,
    required this.Songs,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            labelText: "Search for songs",
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {},
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          const MainMenuButton(
            icon: Icons.music_note_rounded,
            text: 'All songs',
            routeName: musicListViewRoute,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 33),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.folder,
                        size: 20,
                      ),
                      Text(
                        ' Folders:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      FolderButton(
                        title: 'folder1',
                        songCount: '123',
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      FolderButton(
                        title: 'folder2',
                        songCount: '312',
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      FolderButton(
                        title: 'folder3',
                        songCount: '123',
                      ),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const MainMenuButton(
            icon: Icons.favorite_rounded,
            text: 'Favorites',
            routeName: "",
          ),
          const MainMenuButton(
            icon: Icons.timelapse_rounded,
            text: 'Recently played',
            routeName: "",
          ),
        ],
      ),
      bottomNavigationBar: BottomMusicBar(Pm: _pageManager),
    );
  }
}

class MusicListViewer extends StatefulWidget {
  const MusicListViewer({Key? key}) : super(key: key);

  @override
  State<MusicListViewer> createState() => _MusicListViewerState();
}

class _MusicListViewerState extends State<MusicListViewer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Playlists[SelectedPlaylistIndex].Songs.length,
              itemBuilder: ((context, index) {
                return MusicTile(mData: Playlists[SelectedPlaylistIndex].Songs[index], index: index);
              }),
            ),
          ),

          // Display play/pause button and volume/speed sliders.
          // ControlButtons(_player),
          //const CurrentSongTitle(),
          //const PlaylistWidget(),
          //const AudioProgressBar(),
          //const AudioControlButtons(),
        ],
      ),
      bottomNavigationBar: BottomMusicBar(Pm: _pageManager),
    );
  }
}

class MusicTile extends StatelessWidget {
  const MusicTile({
    Key? key,
    required this.mData,
    required this.index,
  }) : super(key: key);

  final musicData mData;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.green,
          ),
          confirmDismiss: (direction) async {
            _pageManager.AddToQueue(mData);
            return false;
          },
          key: const ValueKey<int>(0),
          child: InkWell(
            onTap: (() async {
              _pageManager.PlaySelectedSong(mData);
            }),
            child: ListTile(
              title: Text(mData.Title.toString(), overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded),
              ),
              // visualDensity: VisualDensity(vertical: -4),
              subtitle: Text('${mData.Artist.toString()} - ${mData.Album.toString()}', overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        const Divider(
          height: 5,
          thickness: 0.75,
          indent: 10,
          endIndent: 30,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: _pageManager.progressNotifier,
      builder: (_, value, __) {
        return SeekBar(
          position: value.current,
          duration: value.total,
          onChangeEnd: _pageManager.seek,
        );
      },
    );
  }
}

class QueueShowButton extends StatelessWidget {
  const QueueShowButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () {
        Navigator.push(context, globals.createRoute(QueueView()));
      },
      icon: const Icon(Icons.queue_music_rounded),
      iconSize: 30,
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          RepeatButton(
            iconSize: 32,
          ),
          PreviousSongButton(
            iconSize: 32,
          ),
          PlayButton(
            iconSize: 32,
          ),
          NextSongButton(
            iconSize: 32,
          ),
          ShuffleButton(
            iconSize: 32,
          ),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key, required this.iconSize}) : super(key: key);
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RepeatState>(
      valueListenable: _pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = Icon(
              Icons.repeat,
              color: Colors.grey,
              size: iconSize,
            );
            break;
          case RepeatState.repeatSong:
            icon = Icon(
              Icons.repeat_one,
              size: iconSize,
            );
            break;
          case RepeatState.repeatPlaylist:
            icon = Icon(
              Icons.repeat,
              size: iconSize,
            );
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: _pageManager.onRepeatButtonPressed,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({
    Key? key,
    required this.iconSize,
  }) : super(key: key);
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: Icon(
            Icons.skip_previous,
            size: iconSize,
          ),
          onPressed: (isFirst) ? null : _pageManager.onPreviousSongButtonPressed,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key? key,
    required this.iconSize,
  }) : super(key: key);
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: _pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: iconSize,
              height: iconSize,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow_rounded),
              iconSize: iconSize,
              onPressed: _pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: iconSize,
              onPressed: _pageManager.pause,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({
    Key? key,
    required this.iconSize,
  }) : super(key: key);
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: Icon(Icons.skip_next_rounded, size: iconSize),
          onPressed: (isLast) ? null : _pageManager.onNextSongButtonPressed,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    Key? key,
    required this.iconSize,
  }) : super(key: key);
  final int iconSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled) ? const Icon(Icons.shuffle_rounded) : const Icon(Icons.shuffle_rounded, color: Colors.grey),
          onPressed: _pageManager.onShuffleButtonPressed,
        );
      },
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _pageManager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 40)),
        );
      },
    );
  }
}

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<List<musicData>>(
        valueListenable: _pageManager.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ReorderableListView.builder(
            reverse: false,
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              if (index == globals.pageManager.GetIndex()) {
                return ListTile(
                  key: Key('$index'),
                  title: Text(globals.pageManager.currentSongDataNotifier.value['title'], overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                      '${globals.pageManager.currentSongDataNotifier.value['artist']} - ${globals.pageManager.currentSongDataNotifier.value['album']}',
                      overflow: TextOverflow.ellipsis),
                );
              } else
                return QueueTile(key: Key('$index'), mData: playlistTitles[index], index: index);
            },
            onReorder: (int oldIndex, int newIndex) {},
          );
        },
      ),
    );
  }
}

class QueueTile extends StatelessWidget {
  const QueueTile({
    Key? key,
    required this.mData,
    required this.index,
  }) : super(key: key);

  final musicData mData;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.green,
          ),
          confirmDismiss: (direction) async {
            _pageManager.AddToQueue(mData);
            return false;
          },
          key: const ValueKey<int>(0),
          child: InkWell(
            onTap: (() async {
              _pageManager.PlaySelectedSong(mData);
            }),
            child: ListTile(
              title: Text(mData.Title.toString(), overflow: TextOverflow.ellipsis),
              subtitle: Text('${mData.Artist.toString()} - ${mData.Album.toString()}', overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.drag_handle),
            ),
          ),
        ),
        const Divider(
          height: 5,
          thickness: 0.75,
          indent: 10,
          endIndent: 30,
          color: Colors.grey,
        ),
      ],
    );
  }
}
