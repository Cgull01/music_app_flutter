// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:music_app/globals.dart';
import 'package:music_app/views/home_page.dart';
import 'package:music_app/views/music_list_viewer.dart';
import 'package:music_app/views/queue_view.dart';

import 'globals.dart' as globals;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id3/id3.dart';
import 'package:music_app/constants/routes.dart';
import 'package:music_app/views/music_view.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
// TODO: queue button notifier, do like spotify, show that its pressed and pop screen if clicked again V
// TODO: queue screen PROBLEMS with queue: can't select a song from queue without messing it all up,
// Queue functions: move songs, select song to instantly play it and place below current song, delete songs from queue
// Minimal queue functionality: show current song, remove songs
// TODO: images
// TODO: alphabet + sorting
// TODO: queue
// TODO: music CRUD and other controls
// TODO: folder display info and screens
// TODO: Search bar
// TODO: localstorage with play amount, last queue, favorite
// TODO: responsive ui
// TODO: next up
// TODO: redesign, extract color from albums
// TODO: extternal storage

/*
Focusing on wrong things:
FIRST:
  V fix file structure, clean code
  V Playlists listener to update folders after loading
  V display buttons after loading, maybe add loading screen
  V Show icon instead of circular progress indicator
  - focus on creating fast loading time, asynchronous code
  O add alphabet on music list view import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
  - be able to open different folders
  - add music deletion
  - search bar
  - external storage
SECOND:
  - images
  - fully functional queue
  - localstorage
  - favorites, most played
  - song sorting

*/

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
  late Image image1;
  @override
  void initState() {
    super.initState();
    image1 = Image.asset(
      'assets/images/appLogo.png',
      height: 150,
      width: 150,
    );
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    _init();
  }

  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }

  Directory dir = Directory('/storage/emulated/0/');
  late final List<FileSystemEntity> _files = dir.listSync(recursive: true, followLinks: false);

  void readMusicFilesDirectory() async {
    Playlist PL = Playlist(title: '', songs: []);
    String? previousFolderTitle;

    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) {
        List<int> mp3Bytes = File(entity.path).readAsBytesSync();
        MP3Instance mp3instance = MP3Instance(mp3Bytes);

        String currentFolderTitle = entity.path.split('/').elementAt(entity.path.split('/').length - 2);

        final regex = RegExp("([^/]+)/?\$");

        // creates a new music folder
        if (previousFolderTitle != currentFolderTitle && previousFolderTitle != null) {
          PL.title = previousFolderTitle;

          setState(() {
            globals.playLists.add(PL);
            globals.allPlaylistsNotifier.value = globals.playLists;
            log('Value notifier updated');
          });
          PL = Playlist(title: '', songs: []);
        } else // adds a new song to playlist
        if (previousFolderTitle == currentFolderTitle && previousFolderTitle != null) {
          if (mp3instance.parseTagsSync()) {
            // log('${mp3instance.metaTags['APIC']['base64'].toString()}');
            globals.allsongs.add(
              MusicData(
                songPath: entity,
                title: mp3instance.metaTags['Title'].toString() == "null"
                    ? regex.firstMatch(entity.path)!.group(0).toString()
                    : mp3instance.metaTags['Title'].toString(),
                artist: mp3instance.metaTags['Artist'] == "null" ? "Unknown artist" : mp3instance.metaTags['Artist'],
                album: mp3instance.metaTags['Album'] == "null" ? "Unknown album" : mp3instance.metaTags['Album'],
                // artwork: mp3instance.metaTags['APIC']['base64'],
              ),
            );
            // log("added ${globals.allsongs[globals.allsongs.length - 1].title} ${entity.path}");
            PL.songs.add(
              MusicData(
                songPath: entity,
                title: mp3instance.metaTags['Title'].toString(),
                artist: mp3instance.metaTags['Artist'],
                album: mp3instance.metaTags['Album'],
                // artwork: mp3instance.metaTags['APIC']['base64'],
              ),
            );
          } else {
            PL.songs.add(MusicData(
              songPath: entity,
              title: RegExp("([^/]+)/?\$").firstMatch(entity.path).toString(),
              artist: "Unknown Artist",
              album: "Unknown Album",
              artwork: null,
            ));
            globals.allsongs.add(
              MusicData(
                songPath: entity,
                title: RegExp("([^/]+)/?\$").firstMatch(entity.path).toString(),
                artist: mp3instance.metaTags['Artist'],
                album: mp3instance.metaTags['Album'],
                // artwork: mp3instance.metaTags['APIC']['base64'],
              ),
            );
          }
        }

        previousFolderTitle = currentFolderTitle;
      }
    }
    if (previousFolderTitle != null) {
      PL.title = previousFolderTitle;
    }
    globals.allsongs.sort((a, b) => a.title.compareTo(b.title));

    for (int i = 0; i < globals.allsongs.length; i++) {
      for (int j = 1; j < globals.allsongs.length; j++) {
        globals.MusicData a = globals.allsongs[i];
        globals.MusicData b = globals.allsongs[j];
        if (a.title == b.title) {
          globals.allsongs.removeAt(j);
        }
      }
    }

    globals.testingBool.value = false;
  }

  checkPermissionManageStorage() async {
    var storageStatus = await Permission.storage.status;

    if (!storageStatus.isGranted) await Permission.storage.request();

    if (await Permission.storage.isGranted) {
      readMusicFilesDirectory();
      // readMusicFilesDirectory();
    } else {
      // Ask for permission
      // showToast("Provide Camera permission to use camera.", position: ToastPosition.bottom);
    }
  }

  readMusicFilesDirectory2() async {
    Playlist PL = Playlist(title: '', songs: []);
    String? previousFolderTitle;

    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) {
        String currentFolderTitle = entity.path.split('/').elementAt(entity.path.split('/').length - 2);

        // creates a new music folder
        if (previousFolderTitle != currentFolderTitle && previousFolderTitle != null) {
          PL.title = previousFolderTitle;

          setState(() {
            // ! probably setting the state is bad everytime we get new song
            globals.playLists.add(PL);
          });
          PL = Playlist(title: '', songs: []);
        } else // adds a new song to playlist
        if (previousFolderTitle == currentFolderTitle && previousFolderTitle != null) {
          MetadataRetriever.fromFile(
            File(entity.path),
          )
            ..then(
              (metadata) {
                // log('${metadata.trackName} ${metadata.trackArtistNames} ${metadata.albumName}');
                PL.songs.add(MusicData(
                  songPath: entity,
                  title: metadata.trackName ?? "-",
                  artist: metadata.trackArtistNames.toString(),
                  album: metadata.albumName,
                  // artwork: metadata.albumArt,
                ));

                log('Added ${metadata.trackName}');
              },
            )
            ..catchError((_) {
              setState(() {
                log('Couldn\'t extract metadata');
              });
            });
        }

        previousFolderTitle = currentFolderTitle;
      }
    }
    if (previousFolderTitle != null) {
      PL.title = previousFolderTitle;
    }
  }

  Future<void> _init() async {
    await checkPermissionManageStorage();

    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    log('________App fully loaded, all data read from storage');

    // Listen to errors during playback.
    // _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
    //   log("Error occured: $e");
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    globals.pageManager.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      globals.pageManager.stop();
    }
  }

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
      home: HomePage(
        logoImage: image1,
      ),
      routes: {
        musicRoute: (context) => const MusicView(),
        musicListViewRoute: (context) => const MusicListViewer(),
        queueRoute: (context) => const QueueView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.logoImage}) : super(key: key);

  final Image logoImage;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: globals.testingBool,
      builder: (_, isLoading, __) {
        return isLoading == true
            ? Scaffold(
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: logoImage,
                        ),
                        const Text('Loading music player'),
                      ],
                    )
                  ],
                ),
              )
            : const MyHomePage();
      },
    );
  }
}
